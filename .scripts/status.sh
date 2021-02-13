#!/bin/sh

# nerdfont
export ICON_RCD='辶 '
export ICON_MSC=' '
export ICON_MTD='ﱝ '
export ICON_VOL=' '
export ICON_NIC=' '
export ICON_WFI=' '
export ICON_MEM=' '
export ICON_TMP=' '
export ICON_PLG=' '
export ICON_BA0=' '
export ICON_BA1=' '
export ICON_BA2=' '
export ICON_BA3=' '
export ICON_BA4=' '
export ICON_DAT=' '
statusbar() {
    time_pre=$(date +%s%N)
    RX_pre=$(cat /proc/net/dev | grep enp4s0f1 | sed 's/:/ /g' | awk '{print $2}')
    TX_pre=$(cat /proc/net/dev | grep enp4s0f1 | sed 's/:/ /g' | awk '{print $10}')
    # volume
    amixer get Master | awk 'END {
        ICO = $NF == "[off]" ? ENVIRON["ICON_MTD"] : ENVIRON["ICON_VOL"]
        match($0, / \[([0-9]+%)\] /, m)
        VOL = m[1]
        printf "  %s%s ", ICO, VOL
    }'
    # wifi
    nmcli device status | grep 已连接 | grep wifi | awk '{
        printf "%s%s", ENVIRON["ICON_WFI"], $4
    }'
    # ethernet
    nmcli device status | grep 已连接 | grep ethernet | awk '{
        printf "%s%s", ENVIRON["ICON_NIC"], $4
    }'
    # netspeed
    time_next=$(date +%s%N)
    RX_next=$(cat /proc/net/dev | grep enp4s0f1 | sed 's/:/ /g' | awk '{print $2}')
    TX_next=$(cat /proc/net/dev | grep enp4s0f1 | sed 's/:/ /g' | awk '{print $10}')
    time_diff=$(($((${time_next}-${time_pre}))))
    RX=$(($((${RX_next}-${RX_pre}))*1000000000/${time_diff}))
    TX=$(($((${TX_next}-${TX_pre}))*1000000000/${time_diff}))
    if [[ $RX -lt 1024 ]];then
    RX="0KB/s"
    elif [[ $RX -gt 1048576 ]];then
    RX=$(echo $RX | awk '{printf "%.1fMB/s", $1/1048576}')
    else
    RX=$(echo $RX | awk '{printf "%iKB/s", $1/1024}')
    fi
    if [[ $TX -lt 1024 ]];then
    TX="0KB/s"
    elif [[ $TX -gt 1048576 ]];then
    TX=$(echo $TX | awk '{printf "%.1fMB/s", $1/1048576}')
    else
    TX=$(echo $TX | awk '{printf "%iKB/s", $1/1024}')
    fi
    printf " %s%s%s%s"' '$RX'  '$TX
    # memory usage
    free | awk 'NR == 2 {
        printf " %s%iMB ", ENVIRON["ICON_MEM"], $3/1024+$5/1024
    }'
    # battery
    if [ -f /sys/class/power_supply/BAT0/capacity ]; then
        grep -q '1' /sys/class/power_supply/AC/online && export PLUGGED=yes
        awk '{
            if (ENVIRON["PLUGGED"] == "yes")
                ICON=ENVIRON["ICON_PLG"]
            else if ($0 > 90)
                ICON=ENVIRON["ICON_BA4"]
            else if ($0 > 75)
                ICON=ENVIRON["ICON_BA3"]
            else if ($0 > 50)
                ICON=ENVIRON["ICON_BA2"]
            else if ($0 > 25)
                ICON=ENVIRON["ICON_BA1"]
            else
                ICON=ENVIRON["ICON_BA0"]
            printf "%s%s%% ", ICON, $0
        }' /sys/class/power_supply/BAT0/capacity
    fi
    # datetime
    [ ! -f /tmp/recording.pid ] && printf  "%s%s" "$ICON_DAT""$(date +"%Y-%m-%d %H:%M:%S %A")"
}

xsetroot -name "$(statusbar)"
