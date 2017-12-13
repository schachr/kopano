#!/bin/sh

set -e

_workdir="/root/download/kopano/"
_build=$(curl https://download.kopano.io/community/core:/ 2>&1 | sed 's/a href="/\n/g' | sed 's/\(amd64.tar.gz\)".*/\1/'  | fgrep Debian_8.0-amd64)
_file=$(echo "$_build" | sed 's/.*\/\(.*\)/\1/')
_dir=$(echo $_file | sed 's/\.[a-z]*\.[a-z]*$//' | php -r 'echo urldecode(fgets(STDIN));')
_prefix="https://download.kopano.io"

cd $_workdir
wget -q ${_prefix}${_build} -O $_file
tar zxf $_file && rm -f $_file

cd $_dir
set +e
rm -f *-dev_* *-dbg_* *dbgsym* gsoap* *gsoap-doc* *gsoap-kopano-doc* > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive dpkg -i --skip-same-version --refuse-downgrade --force-confdef --force-confold *.deb 2>&1 > /dev/null | egrep -v "already installed, skipping$|^dpkg: will not downgrade .* skipping$"
set -e

cd $_workdir
rm -rf $_dir
