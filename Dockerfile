# base image provide patched qt wkhtmltopdf out-of-box
FROM surnet/alpine-wkhtmltopdf:3.12-0.12.6-full

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

WORKDIR /var/www

RUN apk --no-cache add tzdata && \
    cp /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    echo "UTC" | tee /etc/timezone && \
    apk del tzdata

 RUN apk --no-cache add \
    php7@7.4.13-r1 php7-opcache@7.4.13-r1 php7-fpm@7.4.13-r1 php7-cgi@7.4.13-r1 php7-ctype@7.4.13-r1 php7-json@7.4.13-r1 php7-dom@7.4.13-r1 php7-zip@7.4.13-r1 php7-zip@7.4.13-r1 php7-gd \
   @7.4.13-r1 php7-curl@7.4.13-r1 php7-mbstring@7.4.13-r1 php7-redis@7.4.13-r1 php7-mcrypt@7.4.13-r1 php7-posix@7.4.13-r1 php7-pdo_mysql@7.4.13-r1 php7-tokenizer@7.4.13-r1 php7-simplexml@7.4.13-r1 php7-session \
   @7.4.13-r1 php7-xml@7.4.13-r1 php7-sockets@7.4.13-r1 php7-openssl@7.4.13-r1 php7-fileinfo@7.4.13-r1 php7-ldap@7.4.13-r1 php7-exif@7.4.13-r1 php7-pcntl@7.4.13-r1 php7-xmlwriter@7.4.13-r1 php7-phar@7.4.13-r1 php7-zlib \
   @7.4.13-r1 php7-intl@7.4.13-r1 php7-gmp@7.4.13-r1 php7-iconv@7.4.13-r1 php7-bcmath@7.4.13-r1 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main

RUN apk --no-cache add bash curl git openssh-client nodejs nodejs-npm supervisor \
    jpegoptim optipng pngquant gifsicle libpng-dev autoconf automake build-base libtool file nasm \
    nginx xvfb

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer
    
RUN npm install -g yarn && npm install -g svgo    

ADD php.ini /etc/php7/php.ini
ADD nginx.conf /etc/nginx/nginx.conf
ADD www.conf /etc/php7/php-fpm.d/www.conf
ADD worker.ini /etc/supervisor.d/worker.ini
ADD crontab /var/spool/cron/crontabs/root
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
