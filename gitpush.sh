#!/bin/bash

git status
read -p "Comment: " message
git add .
git commit -m " $message "
git status