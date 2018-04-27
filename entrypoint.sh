#!/usr/bin/env bash

php artisan migrate --force

crond
supervisord
