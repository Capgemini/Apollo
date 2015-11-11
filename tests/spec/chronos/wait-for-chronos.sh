#!/bin/bash

MAX_SECONDS=120
while /bin/true
do
    curl -s http://127.0.0.1:8080/v2/apps/chronos?embed=apps.tasks | grep -q '.*"tasksRunning":1.*' && exit 0 || sleep 1
    [[ "$SECONDS" -ge "$MAX_SECONDS" ]] && exit 2
done

# EOF
