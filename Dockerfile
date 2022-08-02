FROM php:8.0-alpine3.15 as vendor

ENV OS_ARCH="amd64" \
    OS_NAME="alpine-3.15"

COPY alpine/prebuildfs /

ARG IS_CHINA="true"
ENV MIRROR=${IS_CHINA}

# Install composer
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "composer" "2.3.10" -c 52d10f40187bbce89b853276145d6961c849f460f9e41e62bdacb525bfa7f4d2

RUN install_packages unzip \
    && install-php-extensions gd bcmath

ARG VERSION

WORKDIR /apps/2fauth

RUN mkdir tmp \
    && curl -sL https://github.com/Bubka/2FAuth/archive/refs/tags/v${VERSION}.tar.gz | tar xvz -C tmp \
    && cp -rp tmp/2FAuth-${VERSION}/artisan ./ \
    && cp -rp tmp/2FAuth-${VERSION}/database ./ \
    && cp -rp tmp/2FAuth-${VERSION}/composer.json ./ \
    && composer_config \
    && composer install --prefer-dist --no-scripts --no-dev --no-autoloader \
    && composer dump-autoload --no-scripts --no-dev --optimize

#========== Main Image ============
FROM alpine:3.15

ENV OS_ARCH="amd64" \
    OS_NAME="alpine-3.15" \
    HOME_PAGE="docs.2fauth.app"


LABEL maintainer "zhouyueqiu <zhouyueqiu@easycorp.ltd>"

COPY alpine/prebuildfs /

ARG IS_CHINA="true"
ENV MIRROR=${IS_CHINA}

# Set timezone
RUN install_packages tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" >  /etc/timezone \
    && date \
    && apk del --no-cache tzdata

# Install php and nginx
RUN install_packages php8 php8-phar php8-pdo_sqlite php8-sqlite3 php8-xml \
    php8-gd php8-mbstring php8-tokenizer php8-cli php8-fileinfo php8-bcmath \
    php8-ctype php8-dom php8-session php8-json php8-openssl php8-fpm php8-opcache \
    nginx curl bash s6

# Install composer
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "composer" "2.3.10" -c 52d10f40187bbce89b853276145d6961c849f460f9e41e62bdacb525bfa7f4d2

# Install render-template
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum c14bb8abe5d7683a24f7c72cc7cdbe334f97a89c48efd3cb7cd88fb9cf39583d

ARG UID=1000
ARG GID=1000
ENV USER_ID=${UID} \
    GROUP_ID=${GID}

RUN addgroup -g ${GID} quickon \
    && adduser -D -H -G quickon -u ${UID} quickon \
    && mkdir /run/php \
    && chmod 700 /run/php /var/log/php8 \
    && touch /run/nginx/nginx.pid /var/lib/nginx/logs/error.log \
    && chown quickon:quickon /run/php /var/log/php8 /var/lib/nginx /run/nginx/nginx.pid /var/lib/nginx/logs/error.log

ARG VERSION
ENV APP_VERSION=${VERSION}
ENV EASYSOFT_APP_NAME="2FAuth $APP_VERSION"

WORKDIR /apps/2fauth
COPY --from=vendor /apps/2fauth/tmp/2FAuth-${VERSION} /apps/2fauth/
COPY --from=vendor /apps/2fauth/vendor /apps/2fauth/vendor
RUN chown -R quickon:quickon /apps/2fauth \
    && chmod 700 /apps/2fauth

EXPOSE 8000

# Persistence directory
RUN mkdir -p /data \
    && chown -R quickon:quickon /data \
    && chmod 700 /data

COPY alpine/rootfs /

VOLUME [ "/data"]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]