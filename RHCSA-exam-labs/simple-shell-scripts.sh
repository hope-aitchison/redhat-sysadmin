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
echo what directory?
read DIR

for i in ${DIR}/*.txt; do 
        SHORTNAME=${i%.txt}
        BACKUP="${SHORTNAME}.bak"
        echo the shortname is $SHORTNAME
        mv $i $BACKUP
        echo the backup file is $BACKUP
done