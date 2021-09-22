#!/usr/bin/env bash

# Usage:
# sw
#  - start a stopwatch from 0, save start time
# sw [-r|--resume]
#  - start a stopwatch from the last saved start time (or current time if no last saved start time exists)
#  - "-r" stands for --resume

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


# UNIX timestamp of time imput when continuing count
if [[ "$1" == "-c" || "$1" == "--continue" ]]; then
  time="$2"
  hours="$(cut -d':' -f1 <<<"$time"|bc)"
  minutes="$(cut -d':' -f2 <<<"$time"|bc)"
  seconds="$(cut -d':' -f3 <<<"$time"|bc)"
  DATE_INPUT=$((hours*3600+minutes*60+seconds))
  #START_TIME=$((-DATE_INPUT))
  START_TIME=$((START_TIME+DATE_INPUT))
fi

DATE_INPUT="--date now-${START_TIME}sec"

while [ true ]; do
    #STOPWATCH=$(TZ=UTC datef $DATE_INPUT $DATE_FORMAT | ( [[ "$NANOS_SUPPORTED" ]] && sed 's/.\{7\}$//' || cat ) )
    STOPWATCH=$(TZ=UTC date $DATE_INPUT $DATE_FORMAT)
    echo $STOPWATCH > /tmp/stopwatch
    sleep 1
done


