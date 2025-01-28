#!/bin/bash

# shell scripts

# conditionally executing code

# check a file exists

if [ -f /etc/passwd ]; then
    echo "file exists"
else
    echo "file does not exist"
fi

[] is the same as test 

test -f /etc/passwd # this runs in the command line

# loops

for file in /etc; do
    echo "processing: $file"
done

for i in rpc-bind http mountd; do
    firewall-cmd --add-service $i --permanent
done


# read lines in a file
while read line; do
    echo "Line: $line"
done < myfile.txt


# process script inputs

#!/bin/bash 
echo "First argument: $1"
echo "Second argument: $2"

sh myscript.sh apple orange
First argument: apple
Second argument: orange

# when dealing with unknown number of argument

#!/bin/bash
echo "Number of arguments passed: $#"
echo "Fruits: $@"

sh myscript.sh apple orange pear banana
Number of arguments passed: 4
Fruits: apple orange pear banana

# process output of shell commands

files=$(ls /etc)
echo "Files: $files"
# prints all files in /etc

if grep -q root /etc/passwd; then 
    echo "root exists"
else
    echo "root user does not exist" 
fi

