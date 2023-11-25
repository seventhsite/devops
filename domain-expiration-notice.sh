#!/bin/bash
set -e

# Replace YOUR_TELEGRAM_BOT_TOKEN and YOUR_TELEGRAM_CHAT_ID with the corresponding values of your Telegram bot and chat
TELEGRAM_BOT_TOKEN="123:xyz"
TELEGRAM_CHAT_ID="12345"

# Path to the file with domain names
DOMAINS_FILE="/path/to/domains.txt"

# Function to check the expiration date of a domain name
check_domain_expiration() {
    domain="$1"
    expiration_date=$(whois "$domain" | grep -E "paid-till:|Expiry Date:" | awk -F': ' '{print $2}')
    if [ -n "$expiration_date" ]; then
        echo "$expiration_date"
    else
        echo "Failed to check domain $domain expiration."
    fi
}

# Function to send notification to Telegram
send_notification() {
    message="$1"
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" -d "chat_id=${TELEGRAM_CHAT_ID}&text=${message}"
}

# Read domain names from the file and check each one
while read -r domain; do
    expiration_date=$(check_domain_expiration "$domain")
    if [ -n "$expiration_date" ]; then
        days_until_expiration=$(( ($(date -d "$expiration_date" +%s) - $(date +%s)) / 86400 ))
        if [ $days_until_expiration -le 30 ]; then
            message="Domain $domain will expire in $days_until_expiration days."
            send_notification "$message"
        fi
    else
        message="Failed to check domain $domain expiration."
        send_notification "$message"
    fi
done < "$DOMAINS_FILE"
