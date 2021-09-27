#!/usr/bin/env bash

PID_FILE=/tmp/tmux_tempus_pid
TIME_FILE=/tmp/tmux_tempus
TMUX_FILE=/tmp/tmux_tempus_bar

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
      echo $STOPWATCH > $TIME_FILE
      sleep 1
  done
}


order="$1"
time="$2"

if [ "$order" = "start" ]; then
  Pid true
  Time_fn true
  if [ -z "$2" ];then
    sw_f 00:00:00 &
    echo $! > $PID_FILE
  else
    sw_f "$time" &
    echo $! > $PID_FILE
  fi
    echo "~" > $TMUX_FILE
elif [ "$order" = "toggle" ];then
  if test -f "$PID_FILE"; then
    #running,we want to pause
    Pid true
    Time_fn false
    kill $pidstr
    echo " $timestr " > $TMUX_FILE
  else
    #not running,we want to continue
    Time_fn true
    sw_f "${timestr// /}" &
    echo $! > $PID_FILE
    echo " ~ " > $TMUX_FILE
  fi
elif [ "$order" = "finish" ];then
  Pid true
  Time_fn true
  rm -f $TMUX_FILE 
  kill $pidstr
fi
