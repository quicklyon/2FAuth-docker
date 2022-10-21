#!/bin/bash
# shellcheck disable=SC1091

APP_NAME=$1
APP_VER=$2
ACTION=$3
SUCCESS_STRING="2FAuth"
SERVICE_PORT=8000
MAXWAIT=180

. alpine/prebuildfs/opt/easysoft/scripts/liblog.sh

info "Testing $APP_NAME $APP_VER"

info "Clear previous services."
make clean > /dev/null 2>&1

info "Run $APP_NAME"
make "$ACTION"  > /dev/null 2>&1

info "Checking service"

retries=${MAXWAIT:-30}
for ((i = 1; i <= retries; i += 1)); do
    if [ "$(curl --connect-timeout 0.1 -sL  http://localhost:"$SERVICE_PORT" | htmlq  -t 'title' )" == "$SUCCESS_STRING" ];then
        info "$APP_NAME is ok!"
        break
    fi

    warn "Waiting $APP_NAME $i seconds"
    sleep 1

    if [ "$i" == "$retries" ]; then
        error "$APP_NAME is unavailable after 30 seconds,please check."
        return 1
    fi
done

info "Clear services"
make clean > /dev/null 2>&1
