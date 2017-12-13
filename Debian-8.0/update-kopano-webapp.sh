#!/bin/sh

set -e

_workdir="/root/download/kopano/"
_build=$(curl https://download.kopano.io/community/webapp:/ 2>&1 | sed 's/a href="/\n/g' | sed 's/\(Debian_8.0-all.tar.gz\)".*/\1/' | fgrep Debian_8.0-all.tar.gz)
_file=$(echo "$_build" | sed 's/.*\/\(.*\)/\1/')
_dir=$(echo $_file | sed 's/\.[a-z]*\.[a-z]*$//' | php -r 'echo urldecode(fgets(STDIN));')
_prefix="https://download.kopano.io"

cd $_workdir
wget -q ${_prefix}${_build} -O $_file
tar zxf $_file && rm -f $_file

cd $_dir
set +e
rm -f kopano-dev* > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive dpkg -i --skip-same-version --refuse-downgrade --force-confdef --force-confold *.deb 2>&1 > /dev/null | egrep -v "already installed, skipping$"
set -e

cd $_workdir
rm -rf $_dir

