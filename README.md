# webserver

本项目的目的是通过使用 **Docker** 快速搭建PHP开发环境，减少在开发过程中维护开发环境所付出的时间和精力，专注于开发和学习，提升效率。

## 为什么要使用 Docker？

#### 一致的运行环境

开发过程中一个常见的问题是环境一致性问题。由于开发环境、测试环境、生产环境不一致，导致有些 bug 并未在开发过程中被发现。而 Docker 的镜像提供了除内核外完整的运行时环境，确保了应用运行环境一致性，从而不会再出现 「这段代码在我机器上没问题啊」 这类问题。

#### 持续交付和部署

对开发和运维（DevOps）人员来说，最希望的就是一次创建或配置，可以在任意地方正常运行。使用 Docker 可以通过定制应用镜像来实现持续集成、持续交付、部署。开发人员可以通过Dockerfile 来进行镜像构建，并结合 持续集成(Continuous Integration) 系统进行集成测试，而运维人员则可以直接在生产环境中快速部署该镜像，甚至结合持续部署(ContinuousDelivery/Deployment) 系统进行自动部署。而且使用 Dockerfile 使镜像构建透明化，不仅仅开发团队可以理解应用运行环境，也方便运维团队理解应用运行所需条件，帮助更好的生产环境中部署该镜像。

#### 更轻松的迁移

由于 Docker 确保了执行环境的一致性，使得应用的迁移更加容易。Docker 可以在很多平台上运行，无论是物理机、虚拟机、公有云、私有云，甚至是笔记本，其运行结果是一致的。因此用户可以很轻易的将在一个平台上运行的应用，迁移到另一个平台上，而不用担心运行环境的变化导致应用无法正常运行的情况。

## 生产环境

### 组件

Nginx + PHP + Redis + MySQL + RabbitMQ

### 准备

首先，你得安装Docker，[官网下载页面](https://www.docker.com/community-edition#/download)，下载对应系统版本并安装。

另附一份很好的文档[Docker — 从入门到实践](https://yeasy.gitbooks.io/docker_practice/)。

**克隆项目到本地**

```shell
$ git clone https://github.com/GithubMrxia/webserver.git
```

### 安装

#### 配置

复制 .env.example 改名为 .env，参考注释进行配置

#### php

* php 版本为 `7.2`
* php开启了`opcache`，每次更新代码需要重启php容器 `docker container restart webserver-php`
* 项目进行`composer`等一些操作需要进入php容器内的根目录进行操作，进入容器 `docker exec -it webserver-php sh`
* composer镜像源已经替换为阿里
* php镜像已经整合了`supervisor`，可直接使用

#### Nginx

* 版本默认为**1.13.8**

* 配置文件放在`nginx/sites-enabled/`文件夹下，`nginx/sites-example/`下有配置文件可做参考

* 容器中站点目录为 `/var/wwwroot/site_name`

* 安装有 `Composer`, 可切换为用户`mrxia`使用

* 安装有 `NPM`，已配置淘宝源，可通过`cnpm`使用

* 站点日志路径为`/var/log/nginx/`，具体看各站点配置

<!-- * 配置文件里的`fastcgi_pass php:9000;`修改为需要使用的php版本（默认为7.2） -->

##### 新增站点

在nginx/sites-enabled/下新增配置文件，然后`docker exec webserver-nginx nginx -s reload`重新加载配置

#### MySQL

* 版本默认为**5.7**

连接配置

```php
<?php
$host     =  'mysql';
$port     =  3306;      # 如修改则改为你自己的
$user     =  'root';
$password =  123456;    # 如修改则改为你自己的
```

#### Redis

* 版本默认为**5.0**

连接配置

```php
<?php
$host     =  'redis';
$port     =  '3306'      # 如修改则改为你自己的
```

### 启动

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

### 使用

使用比较简单，主要是站点管理

#### 一些常用命令

```shell
# 查看容器列表
$ docker ps

# 进入容器(其他更换容器名即可)
$ docker exec -it webserver-php sh

# 退出容器
$ exit

# 重启容器
$ docker container restart webserver-nginx

# 查看网络详情
$ docker network inspect webserver-nginx
```
