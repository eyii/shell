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

prompt 'centos7 Dubbo安装部署 http://blog.itpub.net/27099995/viewspace-1394819/  http://dubbo.io/Administrator+Guide-zh.htm#AdministratorGuide-zh-%E7%A4%BA%E4%BE%8B%E6%8F%90%E4%BE%9B%E8%80%85%E5%AE%89%E8%A3%85'
prompt '下载dubbo 示例提供者安装'
function dubbo_xiazai(){
cd /usr/local/
wget http://code.alibabatech.com/mvn/releases/com/alibaba/dubbo-demo-provider/$dubbo_version/dubbo-demo-provider-$dubbo_version-assembly.tar.gz
tar zxvf dubbo-demo-provider-$dubbo_version-assembly.tar.gz
cd dubbo-demo-provider-$dubbo_version
#配置:
}
dubbo_xiazai

prompt '配置dubbo'
function dubbo_peizhi(){
cd dubbo-demo-provider-$dubbo_version
dubbo.container=log4j,spring,registry,jetty
dubbo.application.name=simple-monitor
dubbo.application.owner=
#dubbo.registry.address=multicast://224.5.6.7:1234
#dubbo.registry.address=zookeeper://127.0.0.1:2181
dubbo.registry.address=zookeeper://172.20.32.211:2181?backup=172.20.32.143:2181,172.20.32.143:2182
#dubbo.registry.address=redis://127.0.0.1:6379
#dubbo.registry.address=dubbo://127.0.0.1:9090
dubbo.protocol.port=7070
dubbo.jetty.port=4010
dubbo.jetty.directory=${user.home}/monitor
dubbo.charts.directory=${dubbo.jetty.directory}/charts
dubbo.statistics.directory=${user.home}/monitor/statistics
dubbo.log4j.file=logs/dubbo-monitor-simple.log
dubbo.log4j.level=WARN
}
dubbo_peizhi



prompt '命令'
function start(){
./bin/start.sh
./bin/stop.sh
./bin/restart.sh
./bin/start.sh debug
#系统状态:
./bin/dump.sh
#总控入口:
./bin/server.sh start
./bin/server.sh stop
./bin/server.sh restart
./bin/server.sh debug
./bin/server.sh dump
}
dubbo_xiazai
prompt '执行完成'
