#!/usr/bin/env bash

PID_FILE=/tmp/stopwatch_pid
TIME_FILE=/tmp/stopwatch

Time_fn () {
  if test -f "$TIME_FILE"; then
      timestr=$(head -n 1 $TIME_FILE)
      if [ "$1" = "true" ]; then
        rm -f $TIME_FILE 
      fi
  fi
}

Pid () {
  if test -f "$PID_FILE"; then
      pidstr=$(head -n 1 $PID_FILE)
      if [ "$1" = "true" ]; then
        rm -f $PID_FILE
      fi
  fi
}

sw_f () {
  time="$1"
  hours="$(cut -d':' -f1 <<<"$time"|bc)"
  minutes="$(cut -d':' -f2 <<<"$time"|bc)"
  seconds="$(cut -d':' -f3 <<<"$time"|bc)"
  DATE_INPUT=$((hours*3600+minutes*60+seconds))
  NOW_TS=$(date '+%s')
  START_TIME=$((NOW_TS-DATE_INPUT))
  #TZ=UTC date --date now-$(($(date '+%s')-3600))sec "+%H:%M:%S"

  DATE_INPUT="--date now-${START_TIME}sec"
  DATE_FORMAT="+%H:%M:%S"
  while [ true ]; do
      STOPWATCH=$(TZ=UTC date $DATE_INPUT $DATE_FORMAT)
      echo $STOPWATCH > /tmp/stopwatch
      sleep 1
  done
}


order="$1"
time="$2"

if [ "$order" = "start" ]; then
  Pid true
  Time_fn true
    sw_f 00:00:00 &
    echo $! > /tmp/stopwatch_pid
    #echo "$time" > /tmp/stopwatch
    #~/.tmux/sw.sh "${timestr// /}" &
    #echo $! > /tmp/stopwatch_pid
elif [ "$order" = "pause" ]; then
  Pid false
  kill $pidstr
elif [ "$order" = "continue" ];then
  Pid true
  Time_fn true
  sw_f "${timestr// /}" &
  echo $! > /tmp/stopwatch_pid
elif [ "$order" = "finish" ];then
  Pid true
  Time_fn true
  kill $pidstr
fi


