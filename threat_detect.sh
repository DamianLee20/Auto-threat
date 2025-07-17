#!/bin/bash

# === CONFIGURATION ===     
AUTH_LOG="/private/var/log/secure.log"         # macOS alternative to /var/log/auth.log
SYS_LOG="/private/var/log/system.log"          # macOS equivalent of syslog
ALERT_LOG="alerts.log"
FAILED_THRESHOLD=5
TRAFFIC_THRESHOLD=1000

touch "$ALERT_LOG"  # Ensure the alert log file exists


echo "=== Threat Detection Script ==="
echo "[*] Log file check started at: $(date)"
echo "-------------------------------"

# === 1. Failed Login Detection ===
echo "[*] Checking failed login attempts..."
if [[ ! -f "$AUTH_LOG" ]]; then
  echo "[-] Auth log not found: $AUTH_LOG"
else
  FAILED_LOGINS=$(grep "Failed password" "$AUTH_LOG" | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr)

  echo "$FAILED_LOGINS" | while read COUNT IP; do
    if [[ "$COUNT" -ge "$FAILED_THRESHOLD" ]]; then
      ALERT_MSG="[!] ALERT: $COUNT failed logins from $IP"
      echo "$ALERT_MSG"
      echo "$(date) $ALERT_MSG" >> "$ALERT_LOG"
    fi
  done
fi

# === 2. Traffic Spike Detection ===
echo "[*] Checking for traffic spikes..."

LINE_COUNT=$(wc -l < "$SYS_LOG")

if [ "$LINE_COUNT" -gt "$TRAFFIC_THRESHOLD" ]; then
  ALERT_MSG="[!] TRAFFIC SPIKE: $LINE_COUNT lines in $SYS_LOG"
  echo "$ALERT_MSG"
  echo "$(date) $ALERT_MSG" >> "$ALERT_LOG"
else
  echo "[-] Traffic normal: $LINE_COUNT lines."
fi

echo "[*] Log file check complete. Alerts saved to $ALERT_LOG"

