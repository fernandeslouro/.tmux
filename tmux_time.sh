#!/bin/bash

Time_fn () {
  booly="$1"
  FILE=/tmp/stopwatch
  if test -f "$FILE"; then
      timestr=$(head -n 1 $FILE)
      if [ "$booly" = "true" ]; then
        rm -f $FILE 
      fi
  fi
}

Pid () {
  FILE=/tmp/stopwatch_pid
  booly="$1"
  if test -f "$FILE"; then
      pidstr=$(head -n 1 $FILE)
      if [ "$booly" = "true" ]; then
        rm -f $FILE
      fi
  fi
}
order="$1"
time="$2"
if [ "$order" = "start" ]; then
  Pid true
  Time_fn true
  printf "$time"
  printf "\n"
  eval "sh -c 'echo $$ > /tmp/stopwatch_pid; exec termdown ${time} -o /tmp/stopwatch > /dev/null '"
  printf "aystret"
  printf "\n"
 
elif [ "$order" = "pause" ]; then
  Pid false
  printf "aystret"
  kill $pidstr
elif [ "$order" = "continue" ];then
  Pid true
  Time_fn true
  printf "$timestr"
  eval " sh -c 'echo $$ > /tmp/stopwatch_pid; exec termdown ${timestr}  -o /tmp/stopwatch > /dev/null ' "
fi


