#!/bin/bash

## basic commands
more
less # better

head # first ten lines
tail # last ten lines

head -3 /etc/passwd
tail -3 /etc/passwd | head -1 # first line out of the last 3 

echo hello | tr [:lower:] [:upper:]
HELLO

#######################################
## GREP

man grep
grep  searches  for PATTERNS in each FILE

ps aux | grep ssh
# lists all running ssh processes

ps aux | grep ssh | grep -v grep
# removes the grep process from the list output

grep -A 5 -B 5 Allow /etc/ssh/sshd_config
# first 5 lines and last 5 lines search "Allow"

grep root /etc/shadow fn=35
# show location in magenta

#######################################
## REGEXP

# used to match character combinations in strings
# always put between single quotes
# grep, vim, awk, sed

vim users
alex
alexander
linda
belind

leanna
anna
annabella
anna bella
banana

bit
bet
bot
boat
boot
booooot

grep 'l' users
alex
alexander
linda
belind
leanna
annabella
anna bella

grep '^l' users
linda
leanna

grep 'anna$' users
leanna
anna

grep 'b.*t' users
bit
bet
bot
boat
boot
booooot

grep 'b.+t' users

grep -E 'b.+t' users # extended regex! 1 or more characters
bit
bet
bot
boat
boot
booooot

grep -E 'b.?t' users # 0 or 1 character
bit
bet
bot

grep -E 'b.*t' users # 0 or more chacters
bit
bet
bot
boat
boot
booooot

grep 'bo\{3\}t' users
grep 'bo\{4\}t' users
grep 'bo\{5\}t' users # o occurs 5 times
booooot


#######################################
## AWK

# text processing
# data extraction and reporting

awk -F: '$3 >= 1000 { print $1 }' /etc/passwd # how many users present

awk -F: '{ print $1 }' /etc/passwd # all users and running processes (with UUIDs)

awk -F: '/ssm-user/ { print $4 }' /etc/passwd # UUID of specific user

awk -F: '{ print $NF }' /etc/passwd # prints the last line

awk -F: '{ sum += $3 } END { print sum }' /etc/passwd # adds up all numbers in column 3 and prints sum

awk 'END {print NR}' /etc/passwd # counts number of lines in a file

ls -l | awk '{print $9, $5}' # prints file / directory name and its size

df -h | awk '$NF=="/"{print $5}' # prints disk usage percentage of partition mounted on /

free -m | awk 'NR==2{ print $3 }' # prints the available memory in mb


#######################################
## SED

# stream editor for filtering and transforming text
# text transformations on an input stream e.g. a file or input from a pipeline

sed -n 5p /etc/passwd # prints line 5

sed -i s/old/new/g file.txt # swaps "old" for "new" globally
# /g globally -i interactive

sed -i -e '4d' users.txt # removes the 4th line from a file