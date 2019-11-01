#!/bin/bash

cd "$(dirname "$0")" || exit 1
D="$PWD/../.."

openresty=openresty-1.15.8.2
pcre=pcre-8.43
zlib=zlib-1.2.11
openssl=openssl-1.1.1d

encrypted_session_nginx_module=0.08

download_tgz() {
    local url=$1
    local name=$2
    (
    mkdir -p src && cd src || exit 1
    [ -d $name ] && return
    wget $url.tar.gz -O $name.tar.gz
    tar xvfz $name.tar.gz
    [ -d $name ] || { echo "error downloading $name."; exit 1; }
    )
}

download() {
    download_tgz $1/$2 $2
}

download_github_release() {
    download_tgz https://github.com/$1/$2/archive/v$3 $2-$3
}

download https://openresty.org/download/ $openresty
download https://ftp.pcre.org/pub/pcre/ $pcre
download https://zlib.net/ $zlib
download https://www.openssl.org/source/ $openssl

download_github_release openresty encrypted-session-nginx-module $encrypted_session_nginx_module

# ----------------------------------------------------------------------------

mkdir -p openresty
cd src/$openresty

./configure \
    --prefix=../../openresty \
    --with-luajit=../../.. \
    --with-pcre=../$pcre \
    --with-pcre-jit \
    --with-zlib=../$zlib \
    --with-openssl=../$openssl
    --add-module=../encrypted-session-nginx-module

make -j2
make install

exit

# ----------------------------------------------------------------------------

cd "$D"

S=csrc/openresty/openresty
B=bin/linux64
C=$B/clib

mkdir -p $B/openresty/lua/jit
mkdir -p openresty/jit

cp -rf $S/nginx/sbin/nginx bin/linux64/nginx-bin

cp -rf $S/luajit/lib/libluajit-5.1.so.2.1.0 $B/openresty/libluajit-5.1.so.2
cp -rf $S/luajit/share/luajit-2.1.0-beta3/jit openresty/
rm -rf openresty/jit/vmdef.lua
cp -rf $S/luajit/share/luajit-2.1.0-beta3/jit/vmdef.lua $B/openresty/lua/jit/

cp -rf $S/lualib/librestysignal.so $C/
cp -rf $S/lualib/tablepool.lua ./
cp -rf $S/lualib/ngx ./
cp -rf $S/lualib/rds $C/
cp -rf $S/lualib/redis $C/
cp -rf $S/lualib/resty ./

patch resty/mysql.lua < $S/../mysql.lua.patch
