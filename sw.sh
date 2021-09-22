#!/usr/bin/env bash

# Usage:
# sw
#  - start a stopwatch from 0, save start time
# sw [-r|--resume]
#  - start a stopwatch from the last saved start time (or current time if no last saved start time exists)
#  - "-r" stands for --resume

finish () {
  tput cnorm # Restore cursor
  exit 0
}

trap finish EXIT

# Use GNU date if possible as it's most likely to have nanoseconds available
hash gdate 2>/dev/null
USE_GNU_DATE=$?
datef () {
    if [[ $USE_GNU_DATE == "0" ]]; then 
        gdate "$@"
    else
        date "$@"
    fi
}

DATE_FORMAT="+%H:%M:%S"

tput civis # hide cursor

# If -r is passed, use saved start time from ~/.sw
if [[ "$1" == "-r" || "$1" == "--resume" ]]; then
    if [[ ! -f $HOME/.sw ]]; then
        datef +%s > $HOME/.sw
    fi
    START_TIME=$(cat $HOME/.sw)
else
    START_TIME=$(datef +%s)
    echo -n $START_TIME > $HOME/.sw
fi

# UNIX timestamp of time imput when continuing count
if [[ "$1" == "-c" || "$1" == "--continue" ]]; then
  time="$2"
  hours="$(cut -d':' -f1 <<<"$time"|bc)"
  minutes="$(cut -d':' -f2 <<<"$time"|bc)"
  seconds="$(cut -d':' -f3 <<<"$time"|bc)"
  DATE_INPUT=$((hours*3600+minutes*60+seconds))
  echo "$DATE_INPUT"
  START_TIME=$((START_TIME+24*3600-DATE_INPUT))
  echo "$START_TIME"
fi

# GNU date accepts the input date differently than BSD
if [[ $USE_GNU_DATE == "1" ]]; then
    DATE_INPUT="--date now-${START_TIME}sec"
else
    DATE_INPUT="-v-${START_TIME}S"
fi


echo $DATE_INPUT 
echo $(TZ=UTC datef $DATE_INPUT $DATE_FORMAT)

while [ true ]; do
    STOPWATCH=$(TZ=UTC datef $DATE_INPUT $DATE_FORMAT | ( [[ "$NANOS_SUPPORTED" ]] && sed 's/.\{7\}$//' || cat ) )
    echo $STOPWATCH > /tmp/stopwatch
    sleep 1
done


