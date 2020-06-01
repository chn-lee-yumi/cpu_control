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
