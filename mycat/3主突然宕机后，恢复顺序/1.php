1）查看数据是否同步，人为同步数据，同步数据时注意，主从同步状态时一定要在主的那一端执行操作，然后主会同步到从；但是一旦在从那一端操作的话，执行到主，主又会返回给从，如执行下面的操作，有drop table操作非常危险

2）恢复主节点
3）在DB中做主从对调，先停止原从节点的从复制操作slave stop，再启动原主节点的从复制操作slave start
4）到新的从服务器执行以下语句，查看主从状态是否正常，首先手动启动新的slave，因为加入了skip-slave-start参数
slave start
show slavestatus \G
5）执行插入验证，至此操作结束
6）注意：Mycat不要重启，心跳一直会检测，在DB里把主从对调好就没错误提示了，恢复了心跳就会恢复正常
7）注意：如需要恢复原来配置，执行switch操作，但不建议这样做（switch操作执行较慢，并且似乎有问题，并不能保证执行正确）。switch之前要检查日志主的心跳有没有恢复正常，正常了才能切。
mysql -utest -ptest -hlocalhost -P9066 -DTESTDB
switch @@datasource localhost1:0

8）注意：目前主从都是通过show slave status，当主宕机以后，发生切换，从变为主，原来的主变为从，这时候show slave status就会发生错误，因为原来的主没有开启slave，不建议直接使用switch操作，而是在DB中做主从对调。