FROM php:7.1-fpm-alpine

ENV ZEND_EXTENSION_DIR=/usr/local/lib/php/extensions/no-debug-non-zts-20160303/ \
    REDIS_VERSION=4.1.1 \
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

COPY conf/php7.1.ini         /usr/local/etc/php/php.ini
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

COPY resources/redis-${REDIS_VERSION}.tgz /home/resources/redis.tgz
RUN pecl install /home/resources/redis.tgz \
    && docker-php-ext-enable redis \
    && mkdir -p /var/log/php \
    && mkdir -p /var/log/php/supervisor \
    && chown www-data:www-data /var/log/php \
    && rm -rf /home/resources

COPY resources/composer.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer
#     && useradd -m -G www-data -s /bin/sh mrxia \
#     && usermod -G www-data mrxia

COPY supervisor/supervisord.conf   /etc/supervisor/supervisord.conf

# USER mrxia
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
# USER root
VOLUME ["/var/wwwroot"]
WORKDIR /var/wwwroot

CMD ["sh", "-c", "supervisord -c /etc/supervisor/supervisord.conf && php-fpm"]