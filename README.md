# webserver

本项目的目的是通过使用 **Docker** 快速搭建PHP开发环境，减少在开发过程中维护开发环境所付出的时间和精力，专注于开发和学习，提升效率。

## 为什么要使用 Docker？

#### 一致的运行环境

开发过程中一个常见的问题是环境一致性问题。由于开发环境、测试环境、生产环境不一致，导致有些 bug 并未在开发过程中被发现。而 Docker 的镜像提供了除内核外完整的运行时环境，确保了应用运行环境一致性，从而不会再出现 「这段代码在我机器上没问题啊」 这类问题。

#### 持续交付和部署

对开发和运维（DevOps）人员来说，最希望的就是一次创建或配置，可以在任意地方正常运行。使用 Docker 可以通过定制应用镜像来实现持续集成、持续交付、部署。开发人员可以通过Dockerfile 来进行镜像构建，并结合 持续集成(Continuous Integration) 系统进行集成测试，而运维人员则可以直接在生产环境中快速部署该镜像，甚至结合持续部署(ContinuousDelivery/Deployment) 系统进行自动部署。而且使用 Dockerfile 使镜像构建透明化，不仅仅开发团队可以理解应用运行环境，也方便运维团队理解应用运行所需条件，帮助更好的生产环境中部署该镜像。

#### 更轻松的迁移

由于 Docker 确保了执行环境的一致性，使得应用的迁移更加容易。Docker 可以在很多平台上运行，无论是物理机、虚拟机、公有云、私有云，甚至是笔记本，其运行结果是一致的。因此用户可以很轻易的将在一个平台上运行的应用，迁移到另一个平台上，而不用担心运行环境的变化导致应用无法正常运行的情况。

## 开发环境

### 组件

Nginx + PHP + Redis + Mysql + Composer + NPM

### 准备

首先，你得安装Docker，[官网下载页面](https://www.docker.com/community-edition#/download)，下载对应系统版本并安装。

另附一份很好的文档[Docker — 从入门到实践](https://yeasy.gitbooks.io/docker_practice/)。国内访问困难的，可以[下载到本地浏览](https://github.com/yeasy/docker_practice/wiki/%E4%B8%8B%E8%BD%BD)。

**克隆项目到本地**

```shell
$ git clone https://github.com/GithubMrxia/webserver.git
```

### 安装

#### 配置.env文件

复制 .env.example 改名为 .env，修改里面的参数值为自己的

```shell
####        PHP        ####
# PHP版本(webserver.sh使用，多版本用","分隔)
PHP_VERSION=5.6,7.1
# 本地站点目录
SITE_DIR=/mac/wwwroot


####        NGINX        ####
# 版本
NGINX_VERSION=1.13.8
# nginx对外端口
NGINX_PORT=80


####        MYSQL        ####
# 版本
MYSQL_VERSION=5.7

# mysql对外端口
MYSQL_PORT=3306

# 本地mysql数据保存路径
MYSQL_DATA_DIR=/mac/Docker/mysql
MYSQL_ROOT_PASSWORD=123456

####        REDIS        ####
# 版本
REDIS_VERSION=4.0

# redis对外端口
REDIS_PORT=6379
```

#### Nginx

* 版本默认为**1.13.8**

* 配置文件放在`nginx/sites-enabled/`文件夹下，`nginx/sites-example/`下有配置文件可做参考

* 容器中站点目录为 `/var/wwwroot/site_name`

* 安装有 `Composer`, 可切换为用户`mrxia`使用

* 安装有 `NPM`，已配置淘宝源，可通过`cnpm`使用

* 站点日志路径为`/var/log/nginx/`，具体看各站点配置

* 配置文件里的`fastcgi_pass php7.1:9000;`修改为需要使用的php版本（默认为7.1）

##### 新增站点

在nginx/sites-enabled/下新增配置文件，然后`docker container restart webserver_nginx_1`重启Nginx即可

#### PHP

* PHP 扩展各版本有所不同，可通过`phpinfo()`查看，或进入PHP容器通过`php -m`查看

* 扩展配置文件夹路径为`/usr/local/etc/php/conf.d/`

#### MySQL

* 版本默认为**5.7**

php连接配置

```php
<?php
$host     =  'mysql'
$port     =  3306      # 如修改则改为你自己的
$user     =  'root'
$password =  123456    # 如修改则改为你自己的
```

#### Redis

* 版本默认为**4.0**

连接配置

```php
<?php
$host     =  'redis`
$port     =  3306      # 如修改则改为你自己的
```

软件连接`host`改成`127.0.0.1`即可

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
$ echo "alias webserver='/mac/webserver/webserver.sh'" >> ~/.bash_profile

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
