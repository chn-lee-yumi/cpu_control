DEBUG=false

debug(){
    if [[ $DEBUG ]]
    then
        color_echo yellow "[DEBUG]" $@
    fi
}

skyblue(){
    echo "\033[36m$@\033[0m"
}

yellow(){
    echo "\033[33m$@\033[0m"
}

color_echo(){
    echo -e `$1 $2` ${@:3}
}

argparse(){
    until [[ $# -eq 0 ]]
    do
        name=${1:1}
        shift
        if [[ -z "$1" || $1 == -* ]]
        then
            {  # try
                eval "export $name=true 2>/dev/null"
            } || {  # catch
                usage
            }
            debug "$name=true"
        else
            {  # try
                eval "export $name=$1 2>/dev/null"
            } || {  # catch
                ussage
            }
            debug "$name=$1"
            shift
        fi
    done
}

usage(){
    cat <<EOF
Usage:
$0 -info                        查看cpu信息
$0 -online cpu序号[,cpu序号...]  设置cpu在线
$0 -offline cpu序号[,cpu序号...] 设置cpu离线
$0 -governor governor [-policy policy]
                                 设置调度器
Examples:
$0 -online 0,1,2,3
$0 -offline 4,5,6,7
$0 -governor performance -policy policy0
If using termux, try `sudo bash $0` to run on root.
EOF
    exit 1
}

cpu_info(){
    policies=$(ls /sys/devices/system/cpu/cpufreq/)
    color_echo skyblue "cluster数量:" $(expr ${#policies[*]} + 1)
    color_echo skyblue "cpu present:" $(cat /sys/devices/system/cpu/present)
    color_echo skyblue "cpu online:" $(cat /sys/devices/system/cpu/online)
    color_echo skyblue "cpu offline:" $(cat /sys/devices/system/cpu/offline)
    echo "=========="
    for p in $policies
    do
        policy_path=/sys/devices/system/cpu/cpufreq/$p
        color_echo skyblue "policy name:" $p
        color_echo skyblue "related cpus:" $(cat $policy_path/related_cpus)
        color_echo skyblue "min freq:" $(cat $policy_path/cpuinfo_min_freq)
        color_echo skyblue "max freq:" $(cat $policy_path/cpuinfo_max_freq)
        color_echo skyblue "current freq:" $({
            cat $policy_path/cpuinfo_cur_freq 2>/dev/null
        } || {
            yellow "NEED ROOT PRIVILEGE"
        })
        color_echo skyblue "avail freq:" $(cat $policy_path/scaling_available_frequencies)
        color_echo skyblue "governor:" $(cat $policy_path/scaling_available_governors)
        color_echo skyblue "current governor:" $(cat $policy_path/scaling_governor)
        echo "=========="
    done
}

cpu_online(){
    if [[ $online == true ]]; then
        exit 0
    fi
    IFS=","
    for num in $online
    do
        {
            echo 1 2>/dev/null > /sys/devices/system/cpu/cpu$num/online
        } || {
            color_echo yellow "NEED ROOT PRIVILEGE"
            exit 1
        }
    done
}

cpu_offline(){
    if [[ $offline == true ]]; then
        exit 0
    fi
    IFS=","
    for num in $offline
    do
        {
            echo 0 2>/dev/null > /sys/devices/system/cpu/cpu$num/online
        } || {
            color_echo yellow "NEED ROOT PRIVILEGE"
            exit 1
        }
    done
}

cpu_governor(){
    if [[ $policy ]]; then
        echo $governor > /sys/devices/system/cpu/cpufreq/$policy/scaling_governor
    else
        policies=$(ls /sys/devices/system/cpu/cpufreq/)
        for p in $policies
        do
            echo $governor > /sys/devices/system/cpu/cpufreq/$p/scaling_governor
        done
    fi
}

main(){
    argparse $@
    if [[ $info ]]; then
        cpu_info
    elif [[ $online ]]; then
        cpu_online
    elif [[ $offline ]]; then
        cpu_offline
    elif [[ $governor ]]; then
        cpu_governor
    else
        usage
    fi
}

main $@