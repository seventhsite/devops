#!/bin/bash

# Add all files, commit it and push

git status
echo ""
read -p "New commit comment: " message
git add .
echo ""
git commit -m " $message "
echo ""
git push origin main
echo ""
git status