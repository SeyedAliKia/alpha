#!/bin/bash 
 COUNTER=0
while [  $COUNTER -lt 5 ]; do
kill $(pgrep telegram-cli)
rm -r ../.telegram-cli/state
sudo restart telegram
sleep 300
#let COUNTER=COUNTER+1 
done
