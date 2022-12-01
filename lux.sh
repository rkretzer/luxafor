#!/bin/zsh

# Seconds to sleep in between checks
SLEEP=5

ison=0
lastfocus="No focus"
declare -A emojis


emojis=( [Arbeiten]="stopwatch" [DoNotDisturb]="no_bell" [Fahren]="car" [Meeting]="date" [Schlafen]="moon")

while [ true ]; do
  busy=0

  # Check if Zoom is running
  if ps -ef | grep -v grep | grep zoom.us | grep cpthost > /dev/null; then
    busy=1
    if [[ ison -eq 0 ]]; then
      slack status edit --text Meeting --emoji :slack_call: > /dev/null;
    fi
  fi

  # Check if Slack is in a call
  slack=$(python3 lswin.py | grep -i slack | wc -l)
  if [[ $slack -gt 1 ]]; then
    busy=1
  fi

  focusonoff=$(./dnd-monterey)
  focusstatus=$(osascript ./WhichFocus.scpt)
  if [[ "$focusonoff" == "off" ]]; then
    focusstatus="No focus"
  fi

  statuscode=$(sed 's/ //g' <<< $focusstatus)
#echo "$statuscode Emoji: ${emojis[${statuscode}]}"
  if [[ "$focusstatus" != "No focus" ]]; then
    busy=1
    if [[ "$focusstatus" != "$lastfocus" ]]; then
      slack snooze start 120 > /dev/null;
      slack status edit --text "Fokus: $focusstatus" --emoji :${emojis[${statuscode}]}: > /dev/null;
    fi
  fi

  if [[ $busy -eq 1 ]]; then
    `luxcli -wave=5 -speed=50 -rgb=#FF0000`
    ison=1
  else
    `luxcli -rgb=#00FF00`
    if [[ $ison -eq 1 ]]; then
      slack status clear > /dev/null;
      slack snooze end > /dev/null;
      ison=0
    fi
  fi

 sleep $SLEEP
done
