#!/bin/bash
cd `dirname $0`
REAL_PATH=$(cd `dirname $0`; pwd)
NGINX_DEFAULT_CONF='default.conf'
NGINX_SITE_EXAMPLE_PATH='nginx/sites-example/'
NGINX_SITE_ENABLED_PATH='nginx/sites-enabled/'

if [ -e './.env' ]; then
    . .env
else
    echo '.env文件不存在，请先配置.env文件'
    exit
fi

if [ ! -e ${NGINX_SITE_ENABLED_PATH}${NGINX_DEFAULT_CONF} ]; then
    echo '请先复制'${NGINX_SITE_EXAMPLE_PATH}${NGINX_DEFAULT_CONF}'文件到'${NGINX_SITE_ENABLED_PATH}'目录下,并更改fastcgi_pass值为对应PHP版本（默认版本为7.1）';
    exit
fi

if [ ! -e ${SITE_DIR} ]; then
    mkdir -p ${SITE_DIR}
fi

if [ ! -e ${MYSQL_DATA_DIR} ]; then
    mkdir -p ${MYSQL_DATA_DIR}
fi

function splitStr()
{
    OLD_IFS=${IFS}
    IFS=$2,
    arr=($1)
    IFS=${OLD_IFS}
}

splitStr ${PHP_VERSION}, ','

function dkup()
{
    for version in ${arr[*]}
    do
        docker-compose -f docker-compose${version}.yml up -d
    done
}

function dkdown()
{
    for version in ${arr[*]}
    do
        docker-compose -f docker-compose${version}.yml down
    done
}

case $1 in
    'up')
        dkup
    ;;
    'down')
        dkdown
    ;;
    *)
    dkup
    ;;
esac
