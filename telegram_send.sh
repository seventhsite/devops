#!/bin/bash

set -e
# Replace YOUR_BOT_TOKEN and YOUR_CHAT_ID with your actual bot token and chat ID
# You can get your bot token from BotFather and your chat ID by sending a message to your bot and visiting this URL:
# https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates
BOT_TOKEN="YOUR_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"

# Remove the $1 to not pass the text received at the input of the script
TEXT="YOUR_TEXT $1"
LOG=/PATH/TO/FILE.LOG

# Send the message to Telegram using curl
RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d chat_id="${CHAT_ID}" \
    -d text="$TEXT")

# Logging
echo $RESPONSE | sed "s/^/$(date +"%Y-%m-%d %H:%M:%S") /" >> $LOG
