ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

ENV ZEND_EXTENSION_DIR=/usr/local/lib/php/extensions/no-debug-non-zts-20160303/ \
    REDIS_VERSION=3.1.5 \
    XDEBUG_VERSION=2.6.0beta1 \
    XDEBUG_REMOTE_HOST=10.0.75.1

COPY sources.list /etc/apt/sources.list
COPY php.ini         /usr/local/etc/php/php.ini
COPY php-fpm.conf    /usr/local/etc/php-fpm.conf

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    && rm -r /var/lib/apt/lists/*
    
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) zip \
    gd \
    mbstring \
    iconv \
    mcrypt \
    mysqli \
    pdo_mysql

COPY tgz/redis-${REDIS_VERSION}.tgz /home/redis.tgz
COPY tgz/xdebug-${XDEBUG_VERSION}.tgz /home/xdebug.tgz
RUN pecl install /home/redis.tgz \
    && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \
    && pecl install /home/xdebug.tgz \
    && echo "zend_extension=${ZEND_EXTENSION_DIR}xdebug.so\nxdebug.remote_enable=1\nxdebug.remote_port=9000\nxdebug.remote_autostart=on\nxdebug.remote_host=${XDEBUG_REMOTE_HOST}\nxdebug.remote_log=/var/log/php/x-debug-remote.log" > /usr/local/etc/php/conf.d/xdebug.ini \
    && mkdir -p /var/log/php \
    && chmod 777 /var/log/php

COPY composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer \
    && useradd -m -G www-data -s /bin/bash mrxia \
    && usermod -G www-data mrxia
    # && curl "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" -O /usr/local/bin/gosu \
    # && chmod +x /usr/local/bin/gosu \
    # && gosu mrxia \
USER mrxia
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com
USER root
EXPOSE 9000
VOLUME ["/var/wwwroot"]