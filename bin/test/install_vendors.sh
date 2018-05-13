#!/usr/bin/env bash
set -e -u

docker run \
  --rm \
  --interactive --tty \
  --volume $PWD:/app \
  --user $(id -u $DEPLOY_USER):$(id -g $DEPLOY_USER) \
  composer install --no-dev --optimize-autoloader --prefer-dist --no-suggest --ignore-platform-reqs
