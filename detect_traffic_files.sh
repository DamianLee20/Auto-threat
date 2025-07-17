#!/bin/bash

LOG_FILE="/var/log/auth.log"
THRESHOLD=3  # Set a threshold for the number of lines or the size of the file

# Count the number of lines in the log file
LINE_COUNT=$(wc -l < "$LOG_FILE")

if [ "$LINE_COUNT" -gt "$THRESHOLD" ]; then
    echo "Traffic spike detected! $LINE_COUNT lines in $LOG_FILE"
else
    echo "Traffic is normal."
fi

