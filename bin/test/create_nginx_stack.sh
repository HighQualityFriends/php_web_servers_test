#!/usr/bin/env bash -e -u
source $DOCKERUTILPATH; set -a; source $TESTENVPATH; set +a;

export NGINX_SERVER_APP_CONFIG=$(dockerutil::pwd)/$NGINX_SERVER_APP_CONFIG
docker stack deploy -c nginx/docker-stack.yml $STACK
