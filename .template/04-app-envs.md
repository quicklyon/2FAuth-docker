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
