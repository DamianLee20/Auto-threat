#!/bin/bash

# Define the log file path
LOG_FILE="/var/log/auth.log"

# Search for failed login attempts and count occurrences by IP address
grep "Failed password" "$LOG_FILE" | awk '{print $11}' | sort | uniq -c | sort -nr

