#!/bin/sh
su root
prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt 'centos7 安装配置mysql-proxy读写分离'
prompt 'https://github.com/MyCATApache/Mycat-download'

prompt '先安装依赖'
yum_dependency(){
yum -y install gcc* gcc-c++* autoconf* automake* zlib* libxml* ncurses-devel* libmcrypt* libtool* flex* pkgconfig* libevent* glib* readline-devel  
yum -y libreadline-dev
}
yum_dependency

prompt '安装lua'
import_lua(){
mkdir /opt/install/
cd /opt/install/
wget http://www.lua.org/ftp/lua-$1.tar.gz
tar zxvf lua-$1.tar.gz -C /opt/install/
cd /opt/install/lua-$1
make linux 
make install
export LUA_CFLAGS="-I/usr/local/include" LUA_LIBS="-L/usr/local/lib -llua -ldl" LDFLAGS="-lm" 
}
import_lua 5.2.3



prompt '验证结果'
verity_mysql(){
mysql
show databases;
use sakila;
show tables;
select count(*) from customer;
}
verity_mysql

prompt '执行完成'
