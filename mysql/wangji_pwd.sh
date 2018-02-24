#!/bin/sh
su root
#文章地址http://www.centoscn.com/mysql/2016/0626/7537.html
prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt 'centos7 安装mysql57'
prompt 'https://github.com/MyCATApache/Mycat-download'


prompt '下载mysql源安装包'
down_mysql_rpm(){
sed -i "/\[mysqld\]/a\skip-grant-tables" /etc/my.cnf
sudo systemctl restart mariadb.service
mysql -h$1 -uroot -p -e 'use mysql;'
mysql -h$1 -uroot -p -e 'show tables;'
mysql -h$1 -uroot -p -e "UPDATE user SET Password = password ( '123456 ) WHERE User = 'root' ; "
mysql -h$1 -uroot -p -e "flush privileges;"
mysql -h$1 -uroot -p -e "exit;"
}
down_mysql_rpm localhost

