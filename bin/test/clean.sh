#!/usr/bin/env bash
set -e -u
source $DOCKERUTILPATH;
set -a;
source $TESTENVPATH;
set +a;

docker stack ls --format '{{.Name}}' | grep -E -i "test_nginx|test_haproxy" | xargs -I{} docker stack rm {}
sleep 2
dockerutil::clean_all_with_label $TESTENV_LABEL
