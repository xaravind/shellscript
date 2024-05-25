#!/bin/bash


VALIDATE () {
  if [ $? -ne 0 ]
   then
     echo "$2...failre"
      exit 1
    else
    echo "$2...suceess"
   fi
}

userid=$(id -u)

if [ $userid -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi

dnf install mysql -y
VALIDATE $? "INSTALLLING MYSQL"

dnf install git -y
VALIDATE $? "INSTALLLING GIT"
