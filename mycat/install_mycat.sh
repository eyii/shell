#!/bin/sh

mysql1='192.168.0.151'
mysql2='192.168.0.151'
MYCAT_HOME=/usr/local/mycat

prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt 'centos7 安装MYCAT'
prompt 'https://github.com/MyCATApache/Mycat-download'



prompt '1设置客户端mysql IP地址'

add_hosts(){
sed 's/$/'$1' sam_server_1/' /etc/hosts
sed 's/$/'$1' sam_server_2/' /etc/hosts
}
add_hosts $mysql1 $mysql2


replace_myconf(){
echo 'lower_case_table_names=1' >>/etc/my.cnf
}
replace_myconf

prompt '配置java环境'
JAVA_PATH=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.91-2.6.2.3.el7.x86_64/
install_java_env(){
yum search jdk|grep jdk
yum -y install java-1.7.0-openjdk.x86_64
export JAVA_HOME=$JAVA_PATH
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib/rt.jar
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
source /etc/profile
}
install_java_env $JAVA_PATH


prompt '2下载安装mycat'
prompt '官网https://github.com/MyCATApache/Mycat-download/'
install_mycat(){
cd /usr/local
wget -c https://raw.githubusercontent.com/MyCATApache/Mycat-download/master/1.6-RELEASE/Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz -O mycat.tar.gz
tar -zxvf mycat.tar.gz    
cp -r  mycat /usr/local/  
cd $MYCAT_HOME
chmod +x *    
export MYCAT_HOME=$MYCAT_HOME
source /etc/profile
cd $MYCAT_HOME/bin/
ln -s /usr/local/mycat/bin/mycat /usr/bin/mycat
mycat start
mycat status
}
install_mycat

prompt '防火墙'
install_iptables(){
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8066 -j ACCEPT  
-A INPUT -m state --state NEW -m tcp -p tcp --dport 9066 -j ACCEPT  
}
prompt '开启自动启动'
install_autostart(){
systemctl enable mycat
systemctl daemon-reload
}
install_autostart 

prompt '修改schema.xml数据库名'
dn1_database='db1dddd'
dn1_dataHost='localhost1'
dn2_database='db2'
install_schema_dataNode(){
sed -i 's%name="dn'$3'" dataHost="localhost1" database="db'$3'" />%name="dn'$3'" dataHost="'$1'" database="'$2'" />%' /usr/local/mycat/conf/schema.xml
cat /usr/local/mycat/conf/schema.xml
}
#install_schema_dataNode $dn1_dataHost $dn1_database 1
#install_schema_dataNode $dn1_dataHost $dn1_database 2
prompt '修改schema.xml数据库名'
host='hostM2'
url='10.0.21.103:3307'
user='root2'
password='82868781mulpA'
install_schema_writeType(){
sed -i '46,49s#password="123456">#password="'$4'">#' /usr/local/mycat/conf/schema.xml
sed -i 's%<writeHost host="hostM1" url="localhost:3306" user="root"%<writeHost host="'$1'" url="'$2'" user="'$3'"%' /usr/local/mycat/conf/schema.xml
sed -i '46,49s#password="123456">#password="'$4'">#' /usr/local/mycat/conf/schema.xml
cat /usr/local/mycat/conf/schema.xml
}
#install_schema_writeType $host $url $user $password 

prompt '分库分表'
install_mod_long(){
sed -i '1,$d' $MYCAT_HOME/conf/schema.xml
sed -i '$a\<?xml version="1.0"?>
<!DOCTYPE mycat:schema SYSTEM "schema.dtd">
<mycat:schema xmlns:mycat="http://io.mycat/">

<!--	1修改dN->database数据库名
	4个dH的
	2wH->url服务器地址
	3wH->user用户名
	4wH->password密码-->
	<!-- 配置逻辑数据库名字,以及配置需要分片的表，也可以配置字典全局表或者不分片的表，总之你要纳入mycat管理的表就要在此配置 -->
	<schema name="TESTDB" checkSQLschema="false" sqlMaxLimit="100">
		<!-- auto sharding by id (long) -->
		<table name="travelrecord" dataNode="dn1,dn2,dn3" rule="sharding-by-murmur" />
		<!-- dataNode配置数据节点名字 ，分片规则参照rule.xml -->
		<table name="t_gaojs" dataNode="dn1,dn2,dn3,dn4" rule="mod-long" />
	</schema>
	<!-- 配置数据节点名字以及  数据主机名字和  主机对应的数据库，个人觉得这个database应该配置在dataHost中更合理 -->
	<dataNode name="dn1" dataHost="localhost1_gaojingsong1" database="db1" />
	<dataNode name="dn2" dataHost="localhost1_gaojingsong2" database="db2" />
	<dataNode name="dn3" dataHost="localhost1_gaojingsong3" database="db3" />
	<dataNode name="dn4" dataHost="localhost1_gaojingsong4" database="db4" />
	<!-- 配置数据主机参数，数据库 名字以及数据库类型是否需要balance,以及在此配置主机的读写分离-->
	<dataHost name="localhost1_gaojingsong1" maxCon="1000" minCon="10"
		balance="0" writeType="0" dbType="mysql" dbDriver="native" slaveThreshold="100">
		<heartbeat>select now()</heartbeat>
		<!--can have multi write hosts -->
		<writeHost host="hostM1" url="10.0.1.36:3306" user="root" password="82868781mulpA">
			<!-- can have multi read hosts <readHost host="hostS2" url="192.168.1.200:3306" user="root" password="xxx" /> -->
		</writeHost>
	</dataHost>
	<dataHost name="localhost1_gaojingsong2" maxCon="1000" minCon="10"
		balance="0" writeType="0" dbType="mysql" dbDriver="native" slaveThreshold="100">
		<heartbeat>select now()</heartbeat>
		<writeHost host="hostS1" url="10.0.1.36:3306" user="root" password="82868781mulpA" />
	</dataHost>
	<dataHost name="localhost1_gaojingsong3" maxCon="1000" minCon="10"
		balance="0" writeType="0" dbType="mysql" dbDriver="native" slaveThreshold="100">
		<heartbeat>select now()</heartbeat>
		<writeHost host="hostM2" url="10.0.1.36:3306" user="root" password="82868781mulpA" />
	</dataHost>
	<dataHost name="localhost1_gaojingsong4" maxCon="1000" minCon="10"
		balance="0" writeType="0" dbType="mysql" dbDriver="native" slaveThreshold="100">
		<heartbeat>select now()</heartbeat>
		<writeHost host="hostM2" url="10.0.1.36:3308" user="root" password="82868781mulpA" />
	</dataHost>
</mycat:schema>' $MYCAT_HOME/conf/schema.xml
}
prompt '运行方式 ./mycat start'


prompt '执行完成'
