#!/bin/bash

git status
echo ""
read -p "New commit comment: " message
echo ""
git add .
echo ""
git commit -m " $message "
echo ""
git status