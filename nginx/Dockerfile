FROM nginx:1.15.8-alpine


RUN set -xe \
    && apk add --no-cache --virtual .build-deps \
    tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* $HOME/.cache

RUN addgroup -g 1000 -S www-data \
    && adduser -u 1000 -D -S -G www-data www-data \
    && mkdir -p /etc/nginx/cert /etc/nginx/stream-enabled
