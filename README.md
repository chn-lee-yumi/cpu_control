# cpu_control
cpu controller script for termux

```
Usage:
cpu_control -info                        查看cpu信息
cpu_control -online cpu序号[,cpu序号...]  设置cpu在线
cpu_control -offline cpu序号[,cpu序号...] 设置cpu离线
cpu_control -governor governor [-policy policy]
                                 设置调度器
Examples:
cpu_control -online 0,1,2,3
cpu_control -offline 4,5,6,7
cpu_control -governor performance -policy policy0
If using termux, try `sudo bash cpu_control` to run on root.
```

Preview:

```
u0_a223@localhost:~$ sudo bash cpu_control -info
cluster数量: 2
cpu present: 0-7
cpu online: 0-3
cpu offline: 4-7
==========
policy name: policy0
related cpus: 0 1 2 3
min freq: 633600
max freq: 1843200
current freq: 633600
avail freq: 633600 902400 1113600 1401600 1536000 1747200 1843200
governor: interactive conservative ondemand userspace powersave performance
current governor: powersave
==========
policy name: policy4
related cpus: 4 5 6 7
min freq: 1113600
max freq: 2208000
current freq: 1113600
avail freq: 1113600 1401600 1747200 1958400 2150400 2208000
governor: interactive conservative ondemand userspace powersave performance
current governor: powersave
==========
```
