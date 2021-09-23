#!/usr/bin/env bash


DATE_FORMAT="+%H:%M:%S"

time="$1"
hours="$(cut -d':' -f1 <<<"$time"|bc)"
minutes="$(cut -d':' -f2 <<<"$time"|bc)"
seconds="$(cut -d':' -f3 <<<"$time"|bc)"
DATE_INPUT=$((hours*3600+minutes*60+seconds))
NOW_TS=$(date '+%s')
START_TIME=$((NOW_TS-DATE_INPUT))
#TZ=UTC date --date now-$(($(date '+%s')-3600))sec "+%H:%M:%S"

DATE_INPUT="--date now-${START_TIME}sec"

while [ true ]; do
    STOPWATCH=$(TZ=UTC date $DATE_INPUT $DATE_FORMAT)
    echo $STOPWATCH > /tmp/stopwatch
    sleep 1
done


