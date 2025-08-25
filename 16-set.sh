#!/bin/bash

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$( echo $0 | cut -d "." -f1)
LOG_FILE=/tmp/$SCRIPT_NAME-$SCRIPT_NAME.sh
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2... $R Failure $N"
        exit 1
    else
        echo -e "$2... $G SUCCESS $N"
    fi
}

if [ $EUID -ne 0 ]
then
    echo "re-running script as root"
    exec sudo "$0" "$@"
fi


for i in $@
do
    echo "installing $i"
    dnf list installed $i &>>$LOG_FILE
    if [ $? -eq 0 ]
    then    
        echo -e "$i already installed $Y skipping $N"
    else
        dnf install -y $i
        VALIDATE $? "installation of $i"
    fi
done