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
  ~/.tmux/sw.sh &
  echo $! > /tmp/stopwatch_pid
elif [ "$order" = "pause" ]; then
  Pid false
  kill $pidstr

elif [ "$order" = "continue" ];then
  Pid true
  Time_fn true
  ~/.tmux/sw.sh -c "${timestr// /}" &
  echo $! > /tmp/stopwatch_pid
fi


