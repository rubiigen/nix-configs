while true
do
    date=$(date "+%a %F %H:%M")
    vol=$(pamixer --get-volume)
    uptime=$(uptime | cut -d ',' -f1  | cut -d ' ' -f4,5)
    echo "$date | $uptime | ♪ $vol | "
done
