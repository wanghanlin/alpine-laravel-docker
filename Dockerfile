# base image provide patched qt wkhtmltopdf out-of-box
FROM surnet/alpine-wkhtmltopdf:3.10-0.12.5-full

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

WORKDIR /var/www

RUN apk --no-cache add tzdata && \
    cp /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    echo "UTC" | tee /etc/timezone && \
    apk del tzdata

 RUN apk --no-cache add \
    php7 php7-opcache php7-fpm php7-cgi php7-ctype php7-json php7-dom php7-zip php7-zip php7-gd \
    php7-curl php7-mbstring php7-redis php7-mcrypt php7-posix php7-pdo_mysql php7-tokenizer php7-simplexml php7-session \
    php7-xml php7-sockets php7-openssl php7-fileinfo php7-ldap php7-exif php7-pcntl php7-xmlwriter php7-phar php7-zlib \
    php7-intl php7-gmp

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
