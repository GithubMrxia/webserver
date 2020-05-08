FROM php:7.2-fpm-alpine

ENV ZEND_EXTENSION_DIR=/usr/local/lib/php/extensions/no-debug-non-zts-20160303/ \
    REDIS_VERSION=5.2.2 \
    NODE_VERSION=node-v8.12.0-linux-x64

RUN set -xe \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libmcrypt-dev \
    shadow \
    supervisor \
    postgresql-dev \
    tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* $HOME/.cache

COPY conf/php7.2.ini         /usr/local/etc/php/php.ini
COPY conf/php-fpm.conf    /usr/local/etc/php-fpm.conf

RUN set -ex \
    && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/freetype2/freetype \
    --with-jpeg-dir=/usr/include \
    --with-png-dir=/usr/include \
    && docker-php-ext-install -j$(nproc) gd \
    bcmath \
    zip \
    opcache \
    iconv \
    pdo_mysql \
    mysqli \
    pgsql \
    pdo_pgsql \
    sockets

RUN wget -O redis.tgz  https://pecl.php.net/package/redis/${REDIS_VERSION} \
    && pecl install redis.tgz \
    && docker-php-ext-enable redis \
    && mkdir -p /var/log/php/supervisor /var/log/project \
    && chown www-data:www-data /var/log/php /var/log/project \
    && rm -rf redis.tgz

RUN wget -O composer https://getcomposer.org/composer-stable.phar \
    && mv composer /usr/local/bin/composer \
    && chmod 755 /usr/local/bin/composer

COPY supervisor/supervisord.conf   /etc/supervisor/supervisord.conf

RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# USER root
VOLUME ["/var/wwwroot"]
WORKDIR /var/wwwroot

CMD ["sh", "-c", "supervisord -c /etc/supervisor/supervisord.conf && php-fpm"]
