#!/bin/bash

if [ -d dir_nas ];then
  rm -rf dir_nas
fi

if [ -d dir_anf ];then
  rm -rf dir_anf
fi

mkdir dir_nas
mkdir dir_anf
mkdir dir_nas/dir
mkdir dir_anf/dir

### ----- ###

#
# both same file.
#

# for is simulate: many many files exist.
for i in {1..10}; do
    echo "A$i" > dir_nas/a$i.txt
    echo "A$i" > dir_nas/dir/a$i.txt
    # give different_timestamp for buffering.
    sleep 1
    echo "A$i" > dir_anf/a$i.txt
    echo "A$i" > dir_anf/dir/a$i.txt
    # simulate 'rsync -a'
    touch -r dir_nas/a$i.txt     dir_anf/a$i.txt
    touch -r dir_nas/dir/a$i.txt dir_anf/dir/a$i.txt
done

#
# different file. - normal update
#
echo "B" > dir_nas/b.txt
echo "B" > dir_nas/dir/b.txt
echo "B" > dir_anf/b.txt
echo "B" > dir_anf/dir/b.txt
# give different_timestamp for buffering.
sleep 1
echo "b" > dir_nas/b.txt
echo "b" > dir_nas/dir/b.txt

#
# milli sec difference file.
#
echo "C" > dir_nas/c.txt
echo "C" > dir_nas/dir/c.txt
echo "C" > dir_anf/c.txt
echo "C" > dir_anf/dir/c.txt

TIMESTAMP=`stat dir_nas/c.txt |grep Modify|awk '{print $2$3}'| sed -e 's/[-|:]//g' | awk -F'.' '{print $1}' | sed -e 's/\(..\)$/.\1/'`
touch -t $TIMESTAMP dir_anf/c.txt
TIMESTAMP=`stat dir_nas/dir/c.txt |grep Modify|awk '{print $2$3}'| sed -e 's/[-|:]//g' | awk -F'.' '{print $1}' | sed -e 's/\(..\)$/.\1/'`
touch -t $TIMESTAMP dir_anf/dir/c.txt

#
# collapsed file.
#
echo "D" > dir_nas/d.txt
echo "D" > dir_nas/dir/d.txt
# give different_timestamp for buffering.
sleep 1
echo "D" > dir_anf/d.txt
echo "D" > dir_anf/dir/d.txt
# simulate 'rsync -a'
touch -r dir_nas/d.txt     dir_anf/d.txt
touch -r dir_nas/dir/d.txt dir_anf/dir/d.txt
# simulate collapse
chmod 644 dir_nas/d.txt dir_nas/dir/d.txt
chmod 600 dir_nas/d.txt dir_nas/dir/d.txt

#
# only NAS.
#
echo "X" > dir_nas/x.txt
echo "X" > dir_nas/dir/x.txt

#
# only ANF.
#
echo "Y" > dir_anf/y.txt
echo "Y" > dir_anf/dir/y.txt



### ----- ###

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


