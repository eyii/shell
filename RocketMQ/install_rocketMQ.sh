#!/bin/sh
IP_1='192.168.1.121'
IP_2='192.168.1.122'
prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}

prompt '下载rocketMQ'
down_rocketmq(){
wget rockekqm.tar.gz

}
down_rocketmq

prompt '配置hosts'
install_hosts(){
sed -i 's/$/'$1' rocketmq_nameserver1/' /etc/hosts
sed -i 's/$/'$1' rocketmq_master1/' /etc/hosts
sed -i 's/$/'$2' rocketmq_nameserver2/' /etc/hosts
sed -i 's/$/'$2' rocketmq_master2/' /etc/hosts
prompt '重启下网卡'
service network restart
}
install_hosts $IP_1 $IP_2

prompt '配置rocketMQ'
config_rocketmq(){
cd /usr/local
tar -zxvf alibaba-rocketmq$1.tar.gz -C /usr/local
mv alibaba-rocketmq alibaba-rocketmq$1
ln -s alibaba-rocketmq$1 rocketmq 
}
config_rocketmq -3.2.6

prompt '3.4.	创建存储路径【两台机器】'
create_path(){
mkdir /usr/local/rocketmq/store
mkdir /usr/local/rocketmq/store/commitlog
mkdir /usr/local/rocketmq/store/consumequeue
mkdir /usr/local/rocketmq/store/index
}
create_path
prompt 'rocketmq配置文件'
config_recket_config_file(){
cat /dev/null >/usr/local/rocketmq/conf/2m-noslave/broker-a.properties
cat>/usr/local/rocketmq/conf/2m-noslave/broker-a.properties<<EOF
#所属集群名字 
brokerClusterName=rocketmq-cluster
#broker名字，注意此处不同的配置文件填写的不一样 
brokerName=broker-a
#0 表示 Master，>0 表示 Slave brokerId=0 #nameServer地址，分号分割
namesrvAddr=rocketmq-nameserver1:9876;rocketmq-nameserver2:9876

#在发送消息时，自动创建服务器不存在的topic，默认创建的队列数 
defaultTopicQueueNums=4
#是否允许 Broker 自动创建Topic，建议线下开启，线上关闭 
autoCreateTopicEnable=true

#是否允许 Broker 自动创建订阅组，建议线下开启，线上关闭 
autoCreateSubscriptionGroup=true

#Broker 对外服务的监听端口 
listenPort=10911

#删除文件时间点，默认凌晨 4点 
deleteWhen=04

#文件保留时间，默认 48 小时 
fileReservedTime=120
#commitLog每个文件的大小默认1G 
mapedFileSizeCommitLog=1073741824

#ConsumeQueue每个文件默认存30W条，根据业务情况调整

mapedFileSizeConsumeQueue=300000
#destroyMapedFileIntervalForcibly=120000
#redeleteHangedFileInterval=120000

#检测物理文件磁盘空间

diskMaxUsedSpaceRatio=88

#存储路径

storePathRootDir=/usr/local/rocketmq/store

#commitLog 存储路径 
storePathCommitLog=/usr/local/rocketmq/store/commitlog

#消费队列存储路径存储路径

storePathConsumeQueue=/usr/local/rocketmq/store/consumequeue

#消息索引存储路径

storePathIndex=/usr/local/rocketmq/store/index

#checkpoint 文件存储路径

storeCheckpoint=/usr/local/rocketmq/store/checkpoint

#abort 文件存储路径

abortFile=/usr/local/rocketmq/store/abort

#限制的消息大小 
maxMessageSize=65536

#flushCommitLogLeastPages=4

#flushConsumeQueueLeastPages=2

#flushCommitLogThoroughInterval=10000
#flushConsumeQueueThoroughInterval=60000

#Broker 的角色

#- ASYNC_MASTER 异步复制Master

#- SYNC_MASTER 同步双写Master

#- SLAVE 
brokerRole=ASYNC_MASTER

#刷盘方式

#- ASYNC_FLUSH 异步刷盘

#- SYNC_FLUSH 同步刷盘 
flushDiskType=ASYNC_FLUSH

#checkTransactionMessageEnable=false
EOF
}
prompt '执行完成'
