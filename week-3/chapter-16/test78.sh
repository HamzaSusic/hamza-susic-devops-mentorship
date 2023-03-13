#!/bin/bash
# Test using at command
#
echo "This script ran at $(date +%B%d,%T)" > test78.out
echo >> test78.out
sleep 5
echo "This is the script's end..." >> test78.out
#