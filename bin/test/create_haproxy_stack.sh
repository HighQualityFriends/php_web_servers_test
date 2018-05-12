#!/usr/bin/env bash -e -u
source $DOCKERUTILPATH; set -a; source $TESTENVPATH; set +a;



docker config create --label $TESTENV_LABEL haproxy_custom_backend.tmpl haproxy/backend.tmpl
docker config create --label $TESTENV_LABEL haproxy_custom_frontend.tmpl haproxy/frontend.tmpl
docker config create --label $TESTENV_LABEL haproxy_custom_haproxy.tmpl haproxy/haproxy.tmpl

docker service create --name swarm-listener \
    --network $NETWORK \
    --mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
    --env DF_NOTIFY_CREATE_SERVICE_URL=http://proxy:8080/v1/docker-flow-proxy/reconfigure \
    --env DF_NOTIFY_REMOVE_SERVICE_URL=http://proxy:8080/v1/docker-flow-proxy/remove \
    --constraint 'node.role==manager' \
    --detach=true \
    --restart-delay 10s \
    --restart-max-attempts 5 \
    --update-parallelism 0 \
    --with-registry-auth \
    --limit-memory $GATEWAY_LIMIT_MEMORY \
    --limit-cpu $GATEWAY_LIMIT_CPU \
    --label $TESTENV_LABEL \
    dockerflow/docker-flow-swarm-listener:beta

sleep 5

docker service create --name proxy \
    --publish $GATEWAY_PORT:80 \
    --network $NETWORK \
    --env MODE=swarm \
    --env STATS_URI=/stats \
    --env STATS_USER=test \
    --env STATS_PASS=test \
    --env LISTENER_ADDRESS=swarm-listener \
    --detach=true \
    --restart-delay 10s \
    --restart-max-attempts 5 \
    --update-parallelism 0 \
    --with-registry-auth \
    --limit-memory $GATEWAY_LIMIT_MEMORY \
    --limit-cpu $GATEWAY_LIMIT_CPU \
    --label $TESTENV_LABEL \
    --config source='haproxy_custom_backend.tmpl',target=/cfg/custom_backend.tmpl,mode=0444 \
    --config source='haproxy_custom_frontend.tmpl',target=/cfg/custom_frontend.tmpl,mode=0444 \
    --config source='haproxy_custom_haproxy.tmpl',target=/cfg/tmpl/haproxy.tmpl,mode=0444 \
    --constraint 'node.role==manager' \
    dockerflow/docker-flow-proxy:18.05.08-46


docker service create \
    --name $APP_SERVICE \
    --with-registry-auth \
    --replicas 5 \
    --restart-delay 10s \
    --restart-max-attempts 5 \
    --update-parallelism 0 \
    --network $NETWORK \
    --restart-condition any \
    --env INSTANCE_ID='{{.Task.Slot}}' \
    --detach=true \
    --limit-memory $APP_LIMIT_MEMORY \
    --limit-cpu $APP_LIMIT_CPU \
    --label $TESTENV_LABEL \
    --endpoint-mode dnsrr \
    --label com.df.discoveryType=DNS \
    --label com.df.distribute=false \
    --label com.df.notify=true \
    --label com.df.port=9000 \
    --label com.df.servicePath=/app \
    --label com.df.templateBePath=/cfg/custom_backend.tmpl \
    --label com.df.templateFePath=/cfg/custom_frontend.tmpl \
    $APP_IMAGE
