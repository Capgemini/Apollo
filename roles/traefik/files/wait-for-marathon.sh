#!/bin/bash

[[ -n "$1" ]] && host=$1 || host=$HOSTNAME

MAX_SECONDS=60
while /bin/true
do
    ping -q -c1 "$host" &>/dev/null
    if [[ $? -ne 0 ]]; then
      sleep 1
      [[ "$SECONDS" -ge "$MAX_SECONDS" ]] && exit 1
    else
      exit 0
    fi
done

# EOF
