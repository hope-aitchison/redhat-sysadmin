#!/bin/bash

a = apend, goes into insert mode but at the end of the line
o = open new line in input mode
dd = delete the current line
yy = yank (copy) the current line
p = paste
v = visual mode
u = undo the last operation
crtl-r = redo the last operation
gg = go to top of doc
G = end of doc
/text = searches forwards
?text = searches backwards
^ = start of the line
$ = end of the line
w = move to next word
:%s/old/new/g = sub all occurences of "old" with "new" globally
:se number = shows the line numbers
vimtutor = brings up the online tutor for all vim commands
ZZ = same as :wq!

## manual commands
man command
man -k command # searches all man pages for specific word
man -k command | grep 8 # same as above but just (8) pages
man man # for manual on the manual