#!/usr/bin/env bash
root=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )
. $root/bin/colors.sh
. $root/.env.sh

provider=$1

# uses 'mo'
which mo > /dev/null
if [ $? -ne 0 ]; then
  echo "'mo' needs to be installed:"
  echo "curl https://raw.githubusercontent.com/tests-always-included/mo/master/mo -o mo && chmod u+x mo && mv mo /usr/local/bin"
  exit 1
fi

parseFiles() {
  cat $root/templates/service-index.html | mo > $root/docgen/${provider}-service-index.html
  shift
  for f in "$@"; do
    echo generating releases/$f
    mkdir -p "$(dirname "$root/releases/$f")"
    cat "$f" | mo > $root/releases/$f
  done
}

printf "${COLOR_WHITE}GENERATING VALUES:${COLOR_NC}\n"

rm -rf $root/releases/*
cd $root/releases.tpl > /dev/null
baseFiles=$(find . -name "*.yaml" -maxdepth 2 | cut -c 3-)
# echo $baseFiles
# exit

. $root/secrets/${provider}.sh
parseFiles $baseFiles
cat $root/templates/README.md | mo > $root/README.md

cd $root > /dev/null