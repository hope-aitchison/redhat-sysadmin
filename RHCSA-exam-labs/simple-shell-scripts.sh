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

echo "which directory are you in currently?"
read DIR
echo "we are creating backup files in $DIR"

for i in ${DIR}/*.txt; do

        NO_EXT=${i%.txt}
        BACKUP=${NO_EXT}.bak
        echo $i to be saved as $BACKUP
        mv $i $BACKUP
done

## parameter expansion

${VAR%PATTERN} - Remove the shortest match of PATTERN from the end
${VAR%%PATTERN} - Remove the longest match of PATTERN from the end
${VAR#PATTERN} - Remove the shortest match of PATTERN from the beginning
${VAR##PATTERN} - Remove the longest match of PATTERN from the beginning

# shortest match from end
FILENAME="file.txt.bak"
NO_EXT=${FILENAME%.txt.bak}
echo "$NO_EXT"
file

FULLPATH="dir/subdir/file.txt"
DIR=${FULLPATH%/*}
echo "$DIR"
dir/subdir

OLDNAME="file.txt"
NEWNAME=${OLDNAME%.txt}.bak
echo "$NEWNAME"
file.bak

# longest match from the beginning
FILENAME="document.pdf"
EXT=${FILENAME##*.}
echo "$EXT"
pdf

FULLPATH="dir/subdir/file.txt"
FILENAME=${FULLPATH##*/}
echo FILENAME
file.txt