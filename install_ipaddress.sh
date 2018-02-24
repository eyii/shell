#! /bin/bash
install_path=/usr/local
prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}

prompt '安装依赖包'
install_depencence(){
DEVICE=eth0                                 //物理设备名称
IPADDR=192.168.1.x                     // IP地址
NETMASK=255.255.255.0           //子网掩码
NETWORK=192.168.1.0               //指定网络，通过IP地址和子网掩码自动计算得到
GATEWAY=192.168.1.1                 //网关地址
BROADCAST=192.168.1.255      //广播地址，通过IP地址和子网掩码自动计算得到
ONBOOT=[yes|no]                          //引导时是否激活设备
USERCTL=[yes|no]                        //非ROOT用户是否可以控制该设备
BOOTPROTO=[none|static|bootp|dhcp]       //引导时不使用协议|静态分配|BOOTP协议|dhcp协议
HWADDR=00:13:D3:27:9F:80                     // MAC地址(若只有一张网卡，此项可省略)
NAME=eth0                                                    //文件名
}
install_depencence
