FROM php:7.1-fpm

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

COPY tgz/redis-3.1.5.tgz /home/redis.tgz
COPY tgz/xdebug-2.5.5.tgz /home/xdebug.tgz
RUN pecl install /home/redis.tgz && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \
    && pecl install /home/xdebug.tgz && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so\nxdebug.remote_enable=on\nxdebug.remote_port=9000\nxdebug.remote_connect_back=on\nxdebug.remote_handler=dbgp" > /usr/local/etc/php/conf.d/xdebug.ini

COPY composer.phar /usr/local/bin/composer
RUN  chmod 755 /usr/local/bin/composer

WORKDIR /var/wwwroot
RUN usermod -u 1000 www-data

# php-fpm:8000 xdebug:9000
EXPOSE 8000 9000
VOLUME ["/var/wwwroot"]