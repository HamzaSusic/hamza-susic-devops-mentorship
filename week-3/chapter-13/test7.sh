#!/bin/bash
# iterating through multiple directories
for file in /home/hamza/.local/week3/test* /home/hamza/.local/week3/badtest
do
if [ -d "$file" ]
then
echo "$file is a directory"
elif [ -f "$file" ]
then
echo "$file is a file"
else
echo "$file doesn't exist"
fi
done