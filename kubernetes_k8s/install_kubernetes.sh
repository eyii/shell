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
prompt 'centos7 安装sakila'
prompt 'https://github.com/MyCATApache/Mycat-download'

prompt '下载解压sakila'
down_sakila(){
cd /usr/local
wget http://downloads.mysql.com/docs/sakila-db.zip
unzip sakila-db.zip

}
down_sakila

prompt '导入sakila结构和数据'
import_sakila(){
cd /usr/local/sakila-db
mysql -uroot -p <sakila-schema.sql
mysql -uroot -p <sakila-data.sql
}

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
