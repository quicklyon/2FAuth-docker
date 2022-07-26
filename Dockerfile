FROM php:7.4-alpine3.15 as vendor

ENV OS_ARCH="amd64" \
    OS_NAME="alpine-3.15"

COPY debian/prebuildfs /

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

COPY debian/prebuildfs /

ARG IS_CHINA="true"
ENV MIRROR=${IS_CHINA}

# Install php and nginx
RUN install_packages php7 php7-phar php7-pdo_sqlite php7-sqlite3 php7-xml \
    php7-gd php7-mbstring php7-tokenizer php7-cli php7-fileinfo php7-bcmath \
    php7-ctype php7-dom php7-session php7-json php7-openssl php7-fpm php7-opcache \
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
    && chmod 700 /run/php /var/log/php7 \
    && touch /run/nginx/nginx.pid /var/lib/nginx/logs/error.log \
    && chown quickon:quickon /run/php /var/log/php7 /var/lib/nginx /run/nginx/nginx.pid /var/lib/nginx/logs/error.log

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

COPY debian/rootfs /

VOLUME [ "/data"]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]