#!/usr/bin/env bash
set -e -u
source $DOCKERUTILPATH;
set -a;
source $TESTENVPATH;
set +a;

function run_benchmark() {
    local timeout=$1
    local concurrent_requests=$2
    local requests=$3
    echo -e "Test timeout: $timeout , concurrent_requests: $concurrent_requests , requests: $requests \n\n" >> $BENCHMARK_TESTS_RESULT_FILE
    ${BENCHMARK_COMMAND} -t $timeout -c $concurrent_requests -n $requests -q -k "${WEB_SERVER_IP}:${GATEWAY_PORT}/app" >> $BENCHMARK_TESTS_RESULT_FILE
    echo -e "\n\n" >> $BENCHMARK_TESTS_RESULT_FILE
}

[ -f "$BENCHMARK_TESTS_RESULT_FILE" ] && rm $BENCHMARK_TESTS_RESULT_FILE

while read test_line; do
    test_line=($test_line)
    benchmark_timeout=${test_line[0]}
    benchmark_concurrent_requests=${test_line[1]}
    benchmark_requests=${test_line[2]}
    dockerutil::print_note "Test timeout: $benchmark_timeout , concurrent_requests: $benchmark_concurrent_requests , requests: $benchmark_requests"
    run_benchmark $benchmark_timeout $benchmark_concurrent_requests $benchmark_requests
    sleep 20
done <${BENCHMARK_TESTS_FILE}