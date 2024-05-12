#!/bin/bash

echo "ALL VARIABLES: $@"
echo "Numaber of varibles passes: $#"
echo "Scripr Name: $0"
echo "Current home directory: $PWD"
echo "Home directory of current user: $HOME"
echo "Which user is running this script: $USER"
echo "hOSTANME: $HOSTNAME"
echo "PROCESS ID of cureent shell script is : $$"
sleep 60 &
echo "Process ID of last background command: $!"

