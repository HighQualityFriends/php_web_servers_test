export DOCKERUTILPATH=./vendor/sarehub/dockerutil/bin/dockerutil
export TESTENVPATH=./bin/test/.env
export PROJECT = php_web_servers_test
export IMAGE_NAMESPACE = localhost:5000
export VERSION = test
export APP_IMAGE=$(IMAGE_NAMESPACE)/$(PROJECT)_$*:$(VERSION)
export DEPLOY_USER ?= ubuntu

export BENCHMARK_TESTS_FILE?=bin/test/benchmark_tests

export BENCHMARK_COMMAND ?= ab
export BENCHMARK_TESTS_RESULT_FILE ?= benchmark_tests_result.txt

HELP_TARGET_MAX_CHAR_NUM=30
SUBPROJECTS = reactphp_ev reactphp_event phpfpm

include makeutil/Help

# FUNCTIONS
# Building & pushing docker image
#  Params:
#   1: image tag
#   2: dockerfile

define deploy_image
	docker build --compress=true --tag $(1) --file $(2) .
	docker push $(1)
endef

define subprojects_target
	$(addprefix $(1)_,$(SUBPROJECTS))
endef
# END FUNCFTIONS

_subproject_deploy_image = $(call subprojects_target,deploy_image)
## Deploying selected subproject image
$(_subproject_deploy_image): deploy_image_%:
	$(call deploy_image,$(APP_IMAGE),$*/Dockerfile)

install_vendors:
	bash bin/test/install_vendors.sh

## Deploying subprojects images
deploy_images: $(_subproject_deploy_image)

## Cleans all docker resources with project testenv label
test_clean:
	bash bin/test/clean.sh

## Creates test network
test_create_network:
	bash bin/test/create_network.sh

## inits basic resources used in any app(executes clean)
test_init: test_clean test_create_network

_subproject_test_create_nginx = $(call subprojects_target,test_create_nginx)
## Creates nginx stack with selected subproject app
$(_subproject_test_create_nginx): test_create_nginx_%: test_init
	@export STACK=test_nginx_$*
	@export NGINX_SERVER_APP_CONFIG=$(subst _ev,,$(subst _event,,$*))/server_app.conf
	bash bin/test/create_nginx_stack.sh

_subproject_test_create_haproxy = $(call subprojects_target,test_create_haproxy, reactphp_ev reactphp_event)
## Creates haproxy stack with selected subproject app
$(_subproject_test_create_haproxy): test_create_haproxy_%: test_init
	@export HAPROXY_STACK=test_haproxy
	@export APP_SERVICE=$*
	bash bin/test/create_haproxy_stack.sh

## Runs ab benchmark tests from file
run_benchmark_tests:
	bash bin/test/run_benchmark_tests.sh