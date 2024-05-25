#!/bin/bash

userid=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log


VALIDATE () {
  if [ $? -ne 0 ]
   then
     echo "$2...failre"
      exit 1
    else
    echo "$2...suceess"
   fi
}


if [ $userid -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "INSTALLLING MYSQL"

dnf install git -y  &>>$LOGFILE
VALIDATE $? "INSTALLLING GIT"
