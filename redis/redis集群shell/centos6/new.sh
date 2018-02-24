#! /bin/bash
#source config.sh


#http://blog.csdn.net/xu470438000/article/details/42971091

prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}

wgetex(){
while true
do
wget $1
read -p "是否重新下载输入[1=重新下载 0=不下载]" is_again
case $is_again in
1)
echo '继续'
;;
0)
break
;;
esac
done
}

prompt '1：下载redis。官网下载3.0.0版本，之前2.几的版本不支持集群模式'

downredis(){
wgetex https://github.com/antirez/redis/archive/3.0.0-rc2.tar.gz
}
downredis

prompt '2：上传redis服务器，解压，编译'
installredis(){
tar -zxvf redis-3.0.0-rc2.tar.gz 
mv redis-3.0.0-rc2.tar.gz redis3.0
cd /usr/local/redis3.0
make
make install
}

prompt '3：创建集群需要的目录'
chuangjian_cluster_dir(){
mkdir -p /usr.local/cluster
cd /usr.local/cluster
mkdir 7000
mkdir 7001
mkdir 7002
mkdir 7003
mkdir 7004
mkdir 7005
}
chuangjian_cluster_dir

prompt '4：修改配置文件redis.conf ##注意：拷贝完成之后要修改7001/7002/7003/7004/7005目录下面redis.conf文件中的port参数，分别改为对应的文件夹的名称'
chg_redis_conf(){
cp /usr/local/redis3.0/redis.conf  /usr.local/cluster
vi redis.conf
prompt '##修改配置文件中的下面选项
port 7000
daemonize yes
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes'

}
chg_redis_conf


prompt '5：conf分别拷到7000/7001/7002/7003/7004/7005目录下面'
cp_redis_conf(){
cp /usr/local/cluster/redis.conf /usr/local/cluster/7000
cp /usr/local/cluster/redis.conf /usr/local/cluster/7001
cp /usr/local/cluster/redis.conf /usr/local/cluster/7002
cp /usr/local/cluster/redis.conf /usr/local/cluster/7003
cp /usr/local/cluster/redis.conf /usr/local/cluster/7004
cp /usr/local/cluster/redis.conf /usr/local/cluster/7005
}
cp_redis_conf



prompt '6：分别启动这6个redis实例'
start_redis(){
cd /usr/local/cluster/7000
redis-server redis.conf
cd /usr/local/cluster/7001
redis-server redis.conf
cd /usr/local/cluster/7002
redis-server redis.conf
cd /usr/local/cluster/7003
redis-server redis.conf
cd /usr/local/cluster/7004
redis-server redis.conf
cd /usr/local/cluster/7005
redis-server redis.conf
}
start_redis



prompt '7:查看redis启动是否成功'
issuccess_redis(){
ps -ef|grep redis
}
issuccess_redis


prompt '8：执行redis创建集群命令'
create_cluster(){
cd /usr/local/redis3.0/src
./redis-trib.rb  create --replicas 1 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005
}
create_cluster