#!/usr/bin/env bash

PID_FILE=/tmp/stopwatch_pid
TIME_FILE=/tmp/stopwatch
STATUS_FILE=/tmp/timestatus

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
  echo "running" > /tmp/timestatus
  if [ -z "$2" ];then
    sw_f 00:00:00 &
    echo $! > /tmp/stopwatch_pid
  else
    sw_f "$time" &
    echo $! > /tmp/stopwatch_pid
  fi
elif [ "$order" = "toggle" ];then
  if test -f "$PID_FILE"; then
    Pid true
    #running,we want to pause
    kill $pidstr
  else
    #not running,we want to continue
    Time_fn true
    sw_f "${timestr// /}" &
    echo $! > /tmp/stopwatch_pid
  fi
elif [ "$order" = "finish" ];then
  Time_fn true
  kill $pidstr
fi


