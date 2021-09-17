#!/bin/bash

PID_FILE=/tmp/stopwatch_pid
TIME_FILE=/tmp/stopwatch

Time_fn () {
  booly="$1"
  if test -f "$TIME_FILE"; then
      timestr=$(head -n 1 $TIME_FILE)
      if [ "$booly" = "true" ]; then
        rm -f $TIME_FILE 
      fi
  fi
}

Pid () {
  booly="$1"
  if test -f "$PID_FILE"; then
      pidstr=$(head -n 1 $PID_FILE)
      if [ "$booly" = "true" ]; then
        rm -f $PID_FILE
      fi
  fi
}
order="$1"
time="$2"
if [ "$order" = "start" ]; then
  Pid true
  Time_fn true
  printf "$time"
  printf "|"
  printf "\n"
  sh -c 'echo $$ > /tmp/stopwatch_pid; exec termdown '"${time}"' -o /tmp/stopwatch > /dev/null' 
  #termdown ${time} -o /tmp/stopwatch > /dev/null 

  #counter_pid=$!
  #printf "$counter_pid"
  #echo "$counter_pid" >> "$PID_FILE"

  printf "aystret"
  printf "\n"
 
elif [ "$order" = "pause" ]; then
  Pid false
  printf "aystret"
  printf "$pidstr"
  kill $pidstr
elif [ "$order" = "continue" ];then
  Pid true
  Time_fn true
  printf "$timestr"
  sh -c 'echo $$ > /tmp/stopwatch_pid; exec termdown '"${timestr// /}"' -o /tmp/stopwatch > /dev/null' 
fi


