#! /bin/bash

install_ssh(){
yum install nscd
sed -i '$a\enable-cache hosts yes' /etc/nscd.conf
service nscd start
}
install_ssh


