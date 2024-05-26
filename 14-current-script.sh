#!/bin/bash

COURSE="Devops from  Current script"

echo "Before calling other script, course: $COURSE"
echo "Process ID of current shell script: $$"

chmod +x /homr/ec2-user/shellscript/16-other-script.sh

#./16-other-script.sh

source ./16-other-script.sh

echo "After calling other script, course: $COURSE"
