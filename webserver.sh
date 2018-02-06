#!/bin/bash
if [ -e .env.test ]; then
    . .env
else
    echo '.env文件不存在，请先配置.env文件'
    exit
fi

