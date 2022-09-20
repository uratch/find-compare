#!/bin/bash

if [ -d dir_nas ];then
  rm -rf dir_nas
fi

if [ -d dir_anf ];then
  rm -rf dir_anf
fi

mkdir dir_nas
mkdir dir_anf
###mkdir dir_nas/dir
###mkdir dir_anf/dir

#
# both same file.
#
echo "A" > dir_nas/a.txt
###echo "A" > dir_nas/dir/a.txt
# add sleep difference for buffering.
sleep 1
echo "A" > dir_anf/a.txt
###echo "A" > dir_anf/dir/a.txt

touch -r dir_nas/a.txt     dir_anf/a.txt
###touch -r dir_nas/dir/a.txt dir_anf/dir/a.txt

#
# different file.
#
echo "B" > dir_nas/b.txt
###echo "B" > dir_nas/dir/b.txt
# add sleep difference for buffering.
sleep 2
echo "b" > dir_anf/b.txt
###echo "b" > dir_anf/dir/b.txt

#
# milli sec difference file.
#
echo "C" > dir_nas/c.txt
###echo "C" > dir_nas/dir/c.txt
echo "C" > dir_anf/c.txt
###echo "C" > dir_anf/dir/c.txt

TIMESTAMP=`stat dir_nas/c.txt |grep Modify|awk '{print $2$3}'| sed -e 's/[-|:]//g' | awk -F'.' '{print $1}' | sed -e 's/\(..\)$/.\1/'`
touch -t $TIMESTAMP dir_anf/c.txt
###TIMESTAMP=`stat dir_nas/dir/c.txt |grep Modify|awk '{print $2$3}'| sed -e 's/[-|:]//g' | awk -F'.' '{print $1}' | sed -e 's/\(..\)$/.\1/'`
###touch -t $TIMESTAMP dir_anf/dir/c.txt

#
# only NAS.
#
echo "D" > dir_nas/d.txt
###echo "D" > dir_nas/dir/d.txt

#
# only ANF.
#
echo "E" > dir_anf/e.txt
###echo "E" > dir_anf/dir/e.txt

#
# find
#
if [ -f find_nas.txt ];then
  rm -rf find_nas.txt
fi

if [ -f find_anf.txt ];then
  rm -rf find_anf.txt
fi

cd dir_nas
find . -type f -printf "%M %u %U %g %G %s %TD %TT %p \n" > ../find_nas.txt

cd ../

cd dir_anf
find . -type f -printf "%M %u %U %g %G %s %TD %TT %p \n" > ../find_anf.txt


