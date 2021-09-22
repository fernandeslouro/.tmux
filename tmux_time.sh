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

order="$1"
time="$2"

if [ "$order" = "start" ]; then
  Pid true
  Time_fn true
  echo "$time"
  if [ -z "${time+x}" ];then
    # time is unset
    ~/.tmux/sw.sh &
    echo $! > /tmp/stopwatch_pid
    #if [ -z ${var+x} ]; then echo "var is unset"; else echo "var is set to '$var'"; fi
  else
    #time is set
    echo "$time"
    echo "$time" > /tmp/stopwatch
    ~/.tmux/sw.sh -c "${timestr// /}" &
    echo $! > /tmp/stopwatch_pid
  fi
elif [ "$order" = "pause" ]; then
  Pid false
  kill $pidstr

elif [ "$order" = "continue" ];then
  Pid true
  Time_fn true
  echo "${timestr// /}"
  ~/.tmux/sw.sh -c "${timestr// /}" &
  echo $! > /tmp/stopwatch_pid
fi


