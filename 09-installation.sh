#!/bin/bash

userid=$(id -u)

if [ userid -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi

dnf instsll mysql -y

if [ $? -ne 0 ]
then
   echo " mysql installation failed"
   exit 1
else
    echo " mysql installed"
fi

dnf instsll git -y

if [ $? -ne 0 ]
then
   echo " git installation failed"
   exit 1
else
    echo " git installed"
fi
