#!/usr/bin/env bash

php artisan migrate --force

test -f run-after-deploy.sh && bash run-after-deploy.sh

supervisord
