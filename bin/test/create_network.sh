#!/usr/bin/env bash
set -e -u
source $DOCKERUTILPATH;
set -a;
source $TESTENVPATH;
set +a;

function create_test_network() {
    docker network create --label $TESTENV_LABEL --driver overlay $NETWORK --subnet $NETWORK_SUBNET 2> /dev/null
}

set +e
create_test_network
if [ $? -ne 0 ]; then
    set -e
    sleep 5
    create_test_network
fi
dockerutil::print_success "created network '$NETWORK'"
