#!/bin/sh
su root
PHP_VERSION='5.6.12'
zlib_version='-1.2.11'
pcre_version='2-10.23'
openssl_version='-1.1.0e'
nginx_version='-1.9.9'
prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt 'CentOS7安装keepalived http://blog.csdn.net/zhu_tianwei/article/details/44928609'


prompt '1安装keepalived'
install_gcc(){
yum -y install keepalived
}

prompt '执行完成'
