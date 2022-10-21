<!-- 该文档是模板生成，手动修改的内容会被覆盖，详情参见：https://github.com/quicklyon/template-toolkit -->
# QuickOn 2FAuth 应用镜像

![GitHub Workflow Status (event)](https://img.shields.io/github/workflow/status/quicklyon/2fauth-docker/build?style=flat-square)
![Docker Pulls](https://img.shields.io/docker/pulls/easysoft/2fauth?style=flat-square)
![Docker Image Size](https://img.shields.io/docker/image-size/easysoft/2fauth?style=flat-square)
![GitHub tag](https://img.shields.io/github/v/tag/quicklyon/2FAuth-docker?style=flat-square)

> 申明: 该软件镜像是由QuickOn打包。在发行中提及的各自商标由各自的公司或个人所有，使用它们并不意味着任何从属关系。

## 快速参考

- 通过 [渠成软件百宝箱](https://www.qucheng.com/app-install/install-2FAuth-130.html) 一键安装 **2FAuth**
- [Dockerfile 源码](https://github.com/quicklyon/2FAuth-docker)
- [2FAuth 源码](https://github.com/Bubka/2FAuth)
- [2FAuth 官网](https://docs.2fauth.app/)

## 一、关于 2FAuth

<!-- 这里写应用的【介绍信息】 -->

[2FAuth](https://docs.2fauth.app/) 是一款基于Web、可独立安装的一次性密码生成器（OTP），可替代 Google Authenticator，兼容移动设备与桌面浏览器。

![screenshots](https://raw.githubusercontent.com/quicklyon/2FAuth-docker/main/.template/2fauth_screenshots.png)

2FAuth官网：[https://docs.2fauth.app/](https://docs.2fauth.app/)


<!-- 这里写应用的【附加信息】 -->

### 1.1 为什么选择 2FAuth

近年来，双重身份验证（Two-factor authentication，简称2FA）变得非常流行，越来越多的网站都通过二次验证来对账号进行更高级的保护。可以想象未来会有更多的场景来使用二次身份验证。

2FAuth 的目的是简化您使用和管理 2FA 的方式，无论您使用什么设备，都具有简洁且适配的界面。在没有智能手机的情况下在电脑前处理二次验证的请求。2FAuth 就为此诞生，满足您手机与PC端管理2FA的新选择。

此外，作为一个开源和私有部署的应用程序，它可以让控制您的个人安全数据，为您提供隐私和备份的能力（您是否丢失了带有 Google Auth 中所有 2FA 帐户的智能手机？我遇到过 …… 这体验简直太烂了。）

### 1.2 特性

- **生成密码**
2FAuth 的主要目的：为您提供一些全新的 TOTP/HOTP 安全代码，即一次性密码。

- **随时随地工作**
它是一个 Web 应用程序，无论您使用什么设备，它都能正常工作。 您只需要一台设备（甚至不是您的设备）和互联网连接。

- **二维码扫描**
扫描并解码 二维码 可立即添加 2FA 帐户。 实际上，它可以解码任何二维码，甚至是非 2FA。

- **2FA管理**
管理您的 2FA 帐户，使用组对它们进行组织和分类，编辑和删除它们。 您甚至可以在不扫描二维码的情况下手动添加帐户。

- **保护您的数据**
2FAuth 代码开源，可私有化部署，通过 WebAuthn 身份验证、OTP 混淆和自动锁定来保护您的数据，最大程度保护您的隐私安全。

## 二、支持的版本(Tag)

由于版本比较多,这里只列出最新的5个版本,更详细的版本列表请参考:[可用版本列表](https://hub.docker.com/r/easysoft/2fauth/tags/)

<!-- 这里是镜像的【Tag】信息，通过命令维护，详情参考：https://github.com/quicklyon/template-toolkit -->
- [latest](https://github.com/Bubka/2FAuth/releases)
- [3.4.0-20221021](https://github.com/Bubka/2FAuth/releases/tag/v3.4.0)

## 三、获取镜像

推荐从 [Docker Hub Registry](https://hub.docker.com/r/easysoft/2fauth) 拉取我们构建好的官方Docker镜像。

```bash
docker pull easysoft/2fauth:latest
```

如需使用指定的版本，可以拉取一个包含版本标签的镜像，在Docker Hub仓库中查看 [可用版本列表](https://hub.docker.com/r/easysoft/2fauth/tags/)

```bash
docker pull easysoft/2fauth:[TAG]
```

## 四、持久化数据

如果你删除容器，所有的数据都将被删除，下次运行镜像时会重新初始化数据。为了避免数据丢失，你应该为容器提供一个挂在卷，这样可以将数据进行持久化存储。

为了数据持久化，你应该挂载持久化目录：

- /data 持久化数据

如果挂载的目录为空，首次启动会自动初始化相关文件

```bash
$ docker run -it \
    -v $PWD/data:/data \
docker pull easysoft/2fauth:latest
```

或者修改 docker-compose.yml 文件，添加持久化目录配置

```bash
services:
  2FAuth:
  ...
    volumes:
      - /path/to/gogs-persistence:/data
  ...
```

## 五、环境变量

<!-- 这里写应用的【环境变量信息】 -->

2FAuth提供了很多可配置的环境变量，详情可[参考文档](https://docs.2fauth.app/getting-started/installation/docker/docker-compose/)，这里介绍邮件相关的环境变量：

| 变量名 | 默认值 | 说明 |
| --- | --- | --- |
| `MAIL_HOST` | `smtp.mailtrap.io` |  SMTP 主机名 |
| `MAIL_PORT` | 2525 | SMTP 端口 |
| `MAIL_FROM` | `changeme@example.com` | 发送者地址 |
| `MAIL_USERNAME` | null | SMTP 用户名 |
| `MAIL_PASSWORD` | null | SMTP 密码 |

示例:

```sh
...
-e MAIL_HOST=smtp.example.com
-e MAIL_PORT=587
-e MAIL_FROM=2fauth@example.com
-e MAIL_USERNAME=2fauth@example.com
-e MAIL_PASSWORD=password1234
```

## 六、运行

### 6.1 单机Docker-compose方式运行

```bash
# 启动服务
make run

# 查看服务状态
make ps

# 查看服务日志
docker-compose logs -f 2fauth

```

<!-- 这里写应用的【make命令的备注信息】位于文档最后端 -->

**说明:**

- 启动成功后，打开浏览器输入 `http://<你的IP>:8000` 访问管理后台。
- 建议添加https证书，否则部分功能无法正常使用。
- [VERSION](https://github.com/quicklyon/2FAuth-docker/blob/main/VERSION) 文件中详细的定义了Makefile可以操作的版本。
- [docker-compose.yml](https://github.com/quicklyon/2FAuth-docker/blob/main/docker-compose.yml)。

## 七、版本升级

<!-- 这里是应用的【应用升级】信息，通过命令维护，详情参考：https://github.com/quicklyon/doc-toolkit -->
容器镜像已为版本升级做了特殊处理，当检测数据（数据库/持久化文件）版本与镜像内运行的程序版本不一致时，会进行数据库结构的检查，并自动进行数据库升级操作。

因此，升级版本只需要更换镜像版本号即可：

> 修改 docker-compose.yml 文件

```diff
...
  2fauth:
-    image: easysoft/2fauth:3.3.0-20220916
+    image: easysoft/2fauth:3.4.0-20221021
    container_name: 2fauth
...
```

更新服务

```bash
# 是用新版本镜像更新服务
docker-compose up -d

# 查看服务状态和镜像版本
docker-compose ps
```