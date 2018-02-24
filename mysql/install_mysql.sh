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
wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
yum localinstall mysql57-community-release-el7-8.noarch.rpm -y
yum repolist enabled | grep "mysql.*-community.*"
systemctl start mysqld
}
down_mysql_rpm

prompt '安装mysql源'
install_mysql_rpm(){
yum localinstall mysql57-community-release-el7-8.noarch.rpm -y
yum repolist enabled | grep "mysql.*-community.*"
}
install_mysql_rpm

prompt '2、安装MySQL'
install_mysql(){
yum install mysql-community-server -y
}
install_mysql

prompt '3、启动MySQL服务'
start_mysql(){
systemctl start mysqld
systemctl status mysqld
}
start_mysql

prompt '4、开机启动mysql'
auto_start_mysql(){
systemctl enable mysqld
systemctl daemon-reload
}
auto_start_mysql

prompt '5、修改root默认密码'
change_root_pwd(){
echo '修改mysql密码命令===set password for 'root'@'localhost'=password('密码:大小写特殊字符>8');'
echo '正在提取root密码'
grep 'temporary password' /var/log/mysqld.log
}
change_root_pwd

grant_root(){
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '密码' WITH GRANT OPTION;"
echo "FLUSH RIVILEGES"
echo "mysql -uroot -p'密码'"
}
grant_root


prompt '执行完成'
