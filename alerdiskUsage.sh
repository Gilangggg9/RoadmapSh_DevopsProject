#!/bin/bash

# Threshold 
THRESHOLD=80

# Webhook Discord
WEBHOOK_URL="https://discordapp.com/api/webhooks////"

# Mengecek penggunaan disk pada root "/"
USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    MESSAGE="ALERT!!: Penggunaan disk server sudah mencapai ${USAGE}% (batas ${THRESHOLD}%)"

    # Kirim notifikasi ke Discord
    curl -H "Content-Type: application/json" \
         -X POST \
         -d "{\"content\": \"${MESSAGE}\"}" \
         $WEBHOOK_URL
fi
