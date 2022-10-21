#!/bin/bash

# Info   : 2Fauth new version release
# Author : zhouyq zhouyueqiu@easycorp.ltd
# CTime  : 2022.10.22

# shellcheck disable=SC1091

. alpine/prebuildfs/opt/easysoft/scripts/liblog.sh

TODAY=$(date +%Y%m%d)
REPO_URL="https://api.github.com/repos/Bubka/2FAuth/releases/latest"

MATE_INFO=$(curl -s -L $REPO_URL)
LATEST_VER=$( echo "$MATE_INFO" | jq -r .tag_name | sed 's/^v//')
export LATEST_VER

BODY=$( echo "$MATE_INFO" | jq -r .body)
export BODY

TITLE=$( echo "$MATE_INFO" | jq -r .name)
export TITLE

CURRENT_VER=$( cat VERSION)
export CURRENT_VER

GITURL=$(jq -r .GitUrl app.json)
export GITURL

APP_NAME=$(jq -r .Name app.json)
export APP_NAME

# generate new version changelog
gen_changelog(){
  info "Generate changelog/${TODAY}.md ..."
  sleep 2
  render-template .template/changelog.md.tpl > changelog/"${TODAY}".md && cat changelog/"${TODAY}".md
}

# 镜像tag模板增加新版本信息
add_newtag(){
  ver=${1:? version is error}
  info "Add new tag to 03-release-tags.md ..."
  tag_exist=$(grep "$ver-$TODAY" .template/03-release-tags.md)
  
  # 如果tag不存在，添加新tag
  if [ "$tag_exist" == "" ];then
    sed -i "2 a - [$ver-$TODAY]($GITURL/releases/tag/v$ver)" .template/03-release-tags.md
  fi

  cat .template/03-release-tags.md
}

git_commit(){
  git add . \
  && git commit -m "$APP_NAME update to $LATEST_VER" \
  && git push \
  && gh release create v"$LATEST_VER" -F changelog/"$TODAY".md
}

#====== main =======
gen_changelog

# 生成镜像tag文档
add_newtag "$LATEST_VER"
  
# 更新readme文档
q-render-readme
  
# 提交代码
git_commit
