#! /bin/bash
demo(){
	read -p "输入1或者y安装0为安装" command
	case "$command" in
	[1])
	echo "to"
	;;
	[0])
	echo '不安装';;
	esac
}
for_echo_eq(){
	for((i=0;i<15;i++))
	do
	echo "."
	done
}

get_ip_addr(){ 
	#echo ifconfig eth0|grep 'inet addr'|grep '10.' | grep -v 'grep' | awk '{print $2}'| tr -d "addr:";
	a=`ifconfig $1 |grep -Po '(?<=inet addr:)[^ ]+'`; 
	echo $a; 
}


prompt(){
	read -p "请回车==============开始=======$1"
	CURRENT_PATH=$(pwd);
	echo "当前路径为==========$CURRENT_PATH"
	history -c
	unset CURRENT_PATH;
	clear
}

create_dir(){
	if [ ! -d $1 ]; then
	mkdir -p $1
	fi
}
#执行maket test 测试代码
ismake_test(){
	
	read -p "是否执行make test ==========1/0" command
	case "$command" in
	[1])
	clear
	make test
	;;
	[0])
	echo '不安装';;
	esac
	unset command
}
#是否退出脚本
is_exit(){
	read -p '是否退出[1/0]' command
	case "$command" in
	[1])
	goto end;;
	[0])echo '继续'
	echo "111";;
	esac
}

is_down_success(){
	if [ $(grep -c -e 'The file is already fully retrieved' -e '100%' $1) -lt 1 ]
	then
	  read -t 10 -p "下载===============$1=========失败请手动下载======"
	  is_exit
	else
	   read -t 10 -p "下载成功===============$1==============="
	   
	fi
}
configure_extend(){
	clear
./configure
	read - p "回车清屏clear"
	clear
}

demo4(){
	clear
	LOGFILE_PATH=$(date +%N.log)
	read -t 5 -p "开始下载===============$1===========后台下载中===具体查看=$LOGFILE_PATH"
CC:
	wget -c $1 
	echo $(pwd)
	read -p '是否重新下载' is_replicate
	#is_down_success $LOGFILE_PATH
	case $is_replicate in
	[1])
	goto CC
	;;
	[0])
	echo '继续'
	;;
	esac
	unset LOGFILE_PATH
	unset is_replicate
}

demo2(){
echo 'type <CTRL-D> to terminate'
echo -n 'enter your most liked film: '
FILM=100
while read -t 5 FILM
do
case $FILM in
[1])
echo "Yeah! great film the $FILM"
;;
[2])
echo "xxxx====2222"
;;
[3])
echo "xxxx====3333"
;;
*)
echo "默认的"
;;
esac
done
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

LOCALIP=$(get_ip_addr ens33)
