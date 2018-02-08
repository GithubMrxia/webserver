# webserver

通过使用Docker和本项目，能在一台全新的电脑上，快速搭建好PHP快速搭建开发环境。

Nginx + PHP + Redis + Mysql + Composer + NPM

## 准备

首先，你得安装Docker，[官网下载页面](https://www.docker.com/community-edition#/download)，下载对应系统版本并安装。

另附一份很好的文档[Docker — 从入门到实践](https://yeasy.gitbooks.io/docker_practice/)。国内访问困难的，可以[下载到本地浏览](https://github.com/yeasy/docker_practice/wiki/%E4%B8%8B%E8%BD%BD)。

**克隆项目到本地**

```shell
$ git clone https://github.com/GithubMrxia/webserver.git
```

## 安装

### 配置.env

复制 .env.example 改名为 .env，修改里面的参数值为自己的

```shell
####  PHP  ####
# PHP版本(webserver.sh使用，多版本用","分隔)
PHP_VERSION=5.6
# 站点目录
SITE_DIR=/mac/Docker/wwwroot
# xdebug ip 远程debug用
XDEBUG_REMOTE_HOST=192.168.1.103

####  NGINX  ####
NGINX_PORT=80

####  MYSQL  ####
# mysql对外端口
MYSQL_PORT=3306
# 本地mysql数据保存路径
MYSQL_DATA_DIR=/mac/Docker/mysql
MYSQL_ROOT_PASSWORD=123456

####  REDIS  ####
# redis对外端口
REDIS_PORT=6379
```

### 配置站点

nginx/sites-example里面准备的有一些配置文件可供参考，复制里面的default.conf文件到nginx/sites-enabled文件夹下，修改里面的配置文件

```shell
# 路径为nginx容器里的站点路径
root /var/wwwroot/html;
# 修改为自己的php版本（默认为7.1）
fastcgi_pass php7.1:9000;
```

### 启动

#### mac

```shell
$ chmod +x webserver.sh

# 启动，第一次会花较长时间
$ ./webserver.sh up

# 关闭
$ ./webserver.sh down
```

可以为脚本命名别名，方便使用(脚本路径改为自己的)

```shell
$ echo alias webserver='/mac/webserver/webserver.sh' >> ~/.bash_profile

# 启动，第一次会花较长时间
webserver up

# 关闭
webserver down
```

### windows

项目根目录下，使用以下命令

```shell
# 启动，第一次会花较长时间
$ docker-compose -f docker-compose7.1.yml up -d

# 关闭
$ docker-compose -f docker-compose7.1.yml down
```

如果同时使用php5.6和php7.1

```shell
# 启动，第一次会花较长时间
$ docker-compose -f docker-compose5.6.yml up -d
$ docker-compose -f docker-compose7.1.yml up -d

# 关闭
$ docker-compose -f docker-compose5.6.yml down
$ docker-compose -f docker-compose7.1.yml down
```

### 使用

使用比较简单，主要是站点管理

#### 一些常用命令

```shell
# 查看容器列表
$ docker container ls

# 进入容器(其他更换容器名即可)
$ docker run -it webserver_php7.1 bash

# 退出容器
$ exit

# 重启容器
$ docker container restart webserver_nginx_1

# 查看网络详情
$ docker network inspect webserver_webserver
```

#### Nginx


* 配置文件放在`nginx/sites-enabled/`文件夹下，`nginx/sites-example/`下有配置文件可做参考

* 站点工作目录为 `/var/wwwroot/`

* 安装有 `Composer`, 可切换为用户`mrxia`使用

* 安装有 `NPM`，已配置淘宝源，可通过`cnpm`使用

* 站点日志路径为`/var/log/nginx/`，具体看各站点配置

##### 新增站点

在nginx/sites-enabled/下新增配置文件，然后`docker container restart webserver_nginx_1`重启Nginx即可

#### PHP

* PHP 扩展各版本有所不同，可通过`phpinfo()`查看，或进入PHP容器通过`php -m`查看

* 扩展配置文件夹为`/usr/local/etc/php/conf.d/`

#### MySQL

连接配置

```shell
host      127.0.0.1 # php连接则改成对应内网ip
port      3306      # 如修改则改为你自己的
user      root
password  123456    # 如修改则改为你自己的
```

#### Redis

连接配置

```shell
host      127.0.0.1 # php连接则改成对应内网ip
port      3306      # 如修改则改为你自己的
```

