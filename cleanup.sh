#!/bin/bash

set -e

days_old=120
directory="/path/to/dir"
telegram_token="your_bot_token"
chat_id="your_telegram_chat_id"
cd "$directory" || exit

deleted_files=()

while IFS= read -r file; do
    deleted_files+=("$file")
    rm -v "$file"
done < <(find . -type f -mtime +$days_old)

if [ ${#deleted_files[@]} -gt 0 ]; then
    message="%f0%9f%97%91 Directory cleaned up. %0A ${#deleted_files[@]} files deleted: %0A" # ${deleted_files[*]}"
    for deleted_file in "${deleted_files[@]}"; do
        cleaned_file="${deleted_file#./}"
        message+="%0A$cleaned_file"
    done
    curl -s -X POST https://api.telegram.org/bot$telegram_token/sendMessage -d chat_id=$chat_id -d text="$message"
fi
