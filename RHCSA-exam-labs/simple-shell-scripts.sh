#!/bin/bash

### Looping constructs

## Write a script with the name /root/lab51.sh that makes a backup copy //
## of files. The script should meet the following requirements
## * prompts for the directory in which the files need to be backed up
## * makes a backup of all files that have the extension .txt but nothing else
## * backup has .txt replaced with .bak
## Test this by creating files testfile{1..9}.txt in /tmp

# test-file
#!/bin/bash

echo what directory?
read DIR
# waits for user to provide directory information
# User input now assigned to variables DIR

for i in ${DIR}/*.txt; do # loops over all the .txt files in DIR

        SHORTNAME=${i%.txt} # turns testfile1.txt into testfile1 //
        # anything after % is deleted
        echo the shortname is $SHORTNAME # prints to terminal the new SHORTNAME
        echo mv $i ${SHORTNAME}.bak # prints the command that would rename the file i //
        # to ${SHORTNAME}.bak
done

# final script

touch /tmp/testfile{1..9}.txt

#!/bin/bash

echo "which directory are you in currently?"
read DIR
echo "we are creating backup files in $DIR"

for i in ${DIR}/*.txt; do

        NO_EXT=${i%.txt}
        BACKUP=${NO_EXT}.bak
        echo $i to be saved as $BACKUP
        mv $i $BACKUP
done

### Conditionally executing code

## Write a script with the name /root/lab52.sh that checks if a user exists.
## If it exists, the script should print the login shell for that user. 
## If not, the script prints that the user does not exist
## Ensure script allows providing the user name as a CL argument
## if no user name provided, prompt for it
## should be able to work with multiple user names if provided

#!/bin/bash

echo which user should I check exists?

# first check if the usernames are passed in

if [[ $# -eq 0 ]]; then
        echo "No users provided, please input users"
        read USERS
else
        USERS=$@
fi

# this method checks if the number of arguments is 0
# this is saying "are the number of arguments 0" so slightly more explicit

# another format

if [[ -z $1 ]]; then
        echo "No users provided, please input users"
        read USERS
else
        USERS=$@
fi

# this method checks if the first positional parameter ($1) is empty
# if $1 is empty it implies no argumentd were passed into the script
# essentially this is saying "if zero at argument1"

# $@ special variable that represents all positional arguments passed to the script
# treats each arguments as separate strings
# $* treats all arguments as a single string

# test test

if [[ $# -eq 0 ]]; then
        echo "No users provided, please input users"
        read USERS
else
        USERS=$@
fi

echo print each user

for i in $USERS; do
        echo $i
done


## final scripy

if [[ $# -eq 0 ]]; then
        echo "No users provided, please input users"
        read USERS
else
        USERS=$@
fi

echo print each existing user login shell

for i in $USERS; do
        grep -q $i /etc/passwd && echo "user $i uses the shell $(grep $i /etc/passwd | awk -F : '{ print $NF }'" || echo "$i user does not exist"
done