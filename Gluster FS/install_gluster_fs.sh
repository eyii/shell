#!/bin/sh

redis_version='2.8.19'
prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt 'CentOS7安装Glusterfs  http://blog.163.com/yunlei_ma/blog/static/1272089352015104113856691/'




prompt 'glusterfs-epel.repo 关闭iptables和selinux'
install_epel_repo(){
wget -P /etc/yum.repos.d http://download.gluster.org/pub/gluster/glusterfs/LATEST/CentOS/glusterfs-epel.repo
yum install -y flex bison openssl-devel libacl-devel sqlite-devel libxml2-devel libtool automake autoconf gcc attr
sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/sysconfig/selinux
}
install_epel_repo

prompt '安装keepalived'
install_keepalived(){
#yum install centos-release-gluster -y

#yum install glusterfs-server  glusterfs glusterfs-fuse -y
yum install glusterfs-server
/etc/init.d/glusterd restart
#开机自动启动 
chkconfig glusterd on
service glusterd status    
}
install_keepalived 

prompt '．设置可信任的存储池'
install_keepalived_service(){
gluster peer probe server2 #在主机server1上：
gluster peer probe horizen
#查看存储池状态：
gluster peer status

#从存储池中移除指定服务器：
# gluster peer detach server2
}
install_keepalived_service


prompt '创建GlusterFS逻辑卷Volume'
install_keepalived_service(){
mkdir -p /data/gfsdata
gluster volume create gv0 replica 2 10.0.21.241:/data/gfsdata 10.0.21.242:/data/gfsdata
gluster volume start gv0
gluster volume info
}
install_keepalived_service
prompt '执行完成'
