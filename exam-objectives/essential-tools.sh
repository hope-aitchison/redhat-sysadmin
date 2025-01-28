#!/bin/bash

# Redirecting stdin stout & stderr

Standard input, stdin, 0
Standard output, stdout, 1
Standard error, stderr, 2

ls > output.txt # overwrite
ls >> output.txt # append
ls /nonexistantdir 2>> error.txt # send error messages to file

ls /nonexistantdir &>> error.txt # send output and error messages to file

# Redirecting stdin

Provide a file as input to a command

sort < names.txt

# Combination

command < file.txt > output.txt 2> error.txt


# pipe

Sends output of one command as input to another

ls -l | grep ".txt"
cat file.txt | wc -l
wc -l > file.txt # more efficient

#######################################

# grep

man grep
grep  searches  for PATTERNS in each FILE

grep -i # case insensitive

ps aux | grep ssh
# lists all running ssh processes

ps aux | grep ssh | grep -v grep
# removes the grep process from the list output

grep -A 5 -B 5 Allow /etc/ssh/sshd_config
# first 5 lines and last 5 lines search "Allow"

grep root /etc/shadow fn=35
# show location in magenta

#######################################

# regexp

Used to match character combinations in strings - pattern matching
Pattern declared in 'single' quotes

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

grep 'l' users # any names containing an l
alex
alexander
linda
belind
leanna
annabella
anna bella

grep '^l' users # any names beginning with l
linda
leanna

grep 'anna$' users # names that end in pattern anna
leanna
anna

grep 'b.*t' users # names that begin with b and end with t with any number of characters in between
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

grep 'bo\{3\}t' users # o occurs 3 times
grep 'bo\{4\}t' users # o occurs 4 times
grep 'bo\{5\}t' users # o occurs 5 times
booooot

# handy regexp greps

grep -E 'error|fail|warn' logs.txt

grep -E '^ERROR' logs.txt

grep -E 'done$' logs.txt 

# operators 

|| # or

&& # and 

ls /root &>/dev/null || (echo run this script with root privileges && exit 2)

# list contents of /root and silence all output
# or run the echo command and exit with exit status 2 (usage or permission issues)

& # runs commands in the background
&& # logical AND, runs second command only if first succeeds

