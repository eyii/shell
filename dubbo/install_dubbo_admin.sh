#! /bin/bash
dubbo_version='2.4.1'
prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}

prompt 'Linux Centos7下Dubbo Admin管理控制台的安装 http://blog.csdn.net/robertohuang/article/details/56497274'
prompt '1.下载Tomcat 2.解压Tuide-zh.htm#AdministratorGuide-zh-%E7%A4%BA%E4%BE%8B%E6%8F%90%E4%BE%9B%E8%80%85%E5%AE%89%E8%A3%85omcat重命名为dubbo-admin-tomcat'
function dubbo_admin_axiazai(){
tar -zxvf apache-tomcat-7.0.57.tar.gz 
mv apache-tomcat-7.0.57 dubbo-admin-tomcat
}
dubbo_admin_axiazai

prompt '3.移除Tomcat webapps目录下的所有文件'

function dubbo_admin_remove(){
cd dubbo-admin-tomcat/webapp
rm -rf * 
}
dubbo_admin_remove

prompt '4.上传Dubbo管理控制台程序 dubbo-admin-2.5.3.war 到Tomcat webapps目录下'

prompt '5.解压并把目录命名为ROOT'

function dubbo_admin_unzip(){
unzip dubbo-admin-2.5.3.war -d ROOT
}
dubbo_admin_unzip

prompt '6.配置 dubbo.properties'

function dubbo_admin_config(){
vi ROOT/WEB-INF/dubbo.properties
dubbo.registry.address=zookeeper://192.168.0.1:2181
dubbo.admin.root.password=root
dubbo.admin.guest.password=root（以上密码在正式上生产前要修改） 
}
dubbo_admin_unzip

prompt '7.防火墙开启8080端口，用root用户修改/etc/sysconfig/iptables'

function dubbo_admin_port(){
#增加： 
## dubbo-admin-tomcat:8080 
sed -i '$a\-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT' /etc/sysconfig/iptables 
#重启防火墙： 
service iptables restart 
}
dubbo_admin_port

prompt '8.启动Tomat'

prompt '9.浏览http://localhost:8080查看是否成功'