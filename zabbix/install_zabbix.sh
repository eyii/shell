#!/bin/sh

MYCAT_HOME=/usr/local/mycat
version='3.2.6'
password="82868781lpA_"
#https://ncu.dl.sourceforge.net/project/zabbix/ZABBIX Latest Stable/3.2.6/zabbix-3.2.6.tar.gz
prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt 'CentOS 6 安装zabbix2.2 '
prompt 'http://blog.sina.com.cn/s/blog_68f5fbcc0101oqn1.html'

prompt '1、安装LAMP环境及依赖包'
install_lamp(){
yum install make gcc mysql-server mysql-devel libcurl-devel net-snmp-devel php php-gd php-xml php-mysql php-mbstring php-bcmath httpd -y
yum -y install wget
wget -O mysql.rpm "https://repo.mysql.com//mysql57-community-release-el7-11.noarch.rpm"
rpm -ivh mysql.rpm
yum -y install mysql-community-server
}
install_lamp

prompt '2、添加用户'
install_adduser(){
groupadd zabbix
useradd zabbix -g zabbix
echo $password| passwd --stdin zabbix
}
install_adduser

prompt '3、创建数据库，添加用户授权'
install_mysql_sq(){
systemctl start mysqld.service
systemctl status  mysqld.service
#读log密
pwd=$(cat /var/log/mysqld.log | grep -oP "(?<=A temporary password is generated for root@localhost: ).*")
#awk -F: '/A temporary password is generated for root@localhost: (.*)/ {print $(NF-1)}' /var/log/mysqld.log
#改密
mysqladmin -uroot -p$pwd password $password
mysql -uroot -p$password  --connect-expired-password -e "show databases;"

#创库
mysql -uroot -p$password -e "create database zabbix character set utf8;"
mysql -uroot -p$password  --connect-expired-password -e "flush privileges;"
mysql -uroot -p$password  --connect-expired-password -e "show databases;"
mysql -uroot -p$password  --connect-expired-password -e "GRANT ALL PRIVILEGES ON *.* TO 'zabbix'@'%' IDENTIFIED BY '"$password"' WITH GRANT OPTION;  "
mysql -uroot -p$password  --connect-expired-password -e "flush privileges;"

firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --zone=public --add-port=10050/tcp --permanent
firewall-cmd --zone=public --add-port=10051/tcp --permanent
firewall-cmd --reload
}
install_mysql_sq $pwd


prompt '4、编译安装zabbix'
install_anzhuang_zabbix(){
cd /usr/local/src/
rm -f zabbix*
wget "http://jaist.dl.sourceforge.net/project/zabbix/ZABBIX Latest Stable/$version/zabbix-$version.tar.gz"
tar zxf zabbix-$version.tar.gz
cd zabbix-$version
./configure --prefix=/usr/local/zabbix --enable-server --enable-agent --with-mysql --with-net-snmp --with-libcurl
make test
make&&make install
}
install_anzhuang_zabbix

prompt '5、导入数据库'
install_import_db(){
mysql -uroot -p$password zabbix < /usr/local/src/zabbix-$version/database/mysql/schema.sql
mysql -uroot -p$password zabbix < /usr/local/src/zabbix-$version/database/mysql/images.sql
mysql -uroot -p$password zabbix < /usr/local/src/zabbix-$version/database/mysql/data.sql
}
install_import_db

prompt '6、拷贝、修改配置文件'
install_import_db(){
sed -i 's/^DBUser=.*$/DBUser=zabbix/g' /usr/local/zabbix/etc/zabbix_server.conf
sed -i "s/^.*DBPassword=.*$/DBPassword="$password"/g" /usr/local/zabbix/etc/zabbix_server.conf
cp -r /usr/local/src/zabbix-$version/frontends/php /var/www/html/zabbix
cp /usr/local/src/zabbix-$version/misc/init.d/fedora/core/zabbix_* /etc/init.d/
sed -i 's#BASEDIR=/usr/local#BASEDIR=/usr/local/zabbix#g' /etc/init.d/zabbix_server
sed -i 's#BASEDIR=/usr/local#BASEDIR=/usr/local/zabbix#g' /etc/init.d/zabbix_agentd
sed -i "s#zabbix_password#"$password"#g" /var/www/html/zabbix/conf/zabbix.conf.php.example
cd /var/www/html/zabbix/conf/
cp -r zabbix.conf.php.example zabbix.conf.php
}
install_import_db


prompt '7、添加服务端口 没有执行'
install_port(){
sed -i "$a#zabbix-agent 10050/tcp Zabbix Agent" /etc/services
sed -i "$a#zabbix-agent 10050/udp Zabbix Agent" /etc/services
sed -i "$a#zabbix-trapper 10051/tcp Zabbix Trapper" /etc/services
sed -i "$a#zabbix-trapper 10051/udp Zabbix Trapper" /etc/services
}
install_port

prompt '8、修改php.ini'
install_php_ini(){
sed -i "s#;date.timezone =#date.timezone = 'Asia/Shanghai'#" /etc/php.ini
sed -i 's#post_max_size =.*$#post_max_size = 16M#g' /etc/php.ini
sed -i 's#max_execution_time =.*$#max_execution_time = 300#g' /etc/php.ini
sed -i 's#max_input_time =.*$#max_input_time = 300#g' /etc/php.ini
sed -i 's#DirectoryIndex index.html.*$#DirectoryIndex index.html index.php#g' /etc/httpd/conf/httpd.conf
sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config
}
install_php_ini


prompt '9、启动服务'
install_start(){
/etc/init.d/zabbix_server start
/etc/init.d/zabbix_agentd start
systemctl start httpd
systemctl start zabbix_server
systemctl start zabbix_agentd
systemctl status zabbix_agentd
}
install_start

install_zabbix_repo(){
sed -i "$a#[zabbix]" $1
sed -i "$a#name=montior" $1
sed -i "$a#baseurl=http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/" $1
sed -i "$a#gpgcheck=0" $1
#'https://my.oschina.net/xxbAndy/blog/308371'
}
install_zabbix_repo /etc/yum.repos.d/CentOS-Base.repo

function install_com(){
yum install -y curl curl-devel net-snmp snmp net-snmp-devel perl-DBI php-gd php-xml php-bcmath php-mbstring
yum install zabbix-server-mysql zabbix-web-mysql -y
}
install_com


