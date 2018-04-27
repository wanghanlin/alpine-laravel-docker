#!/usr/bin/env bash

php artisan migrate --force

nginx
php-fpm7 -R
supervisord
crond
