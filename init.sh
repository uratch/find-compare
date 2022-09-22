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
# only NAS.
#
for i in {1..3}; do
    echo "A-$i" > dir_nas/a-$i.txt
    echo "A-$i" > dir_nas/dir/a-$i.txt
done

#
# both same file.
#

# for is simulate: many many files exist.
for i in {1..50}; do
    echo "B1-$i" > dir_nas/b1-$i.txt
    echo "B1-$i" > dir_nas/dir/b1-$i.txt
    # give different_timestamp for buffering.
    sleep 1
    echo "B1-$i" > dir_anf/b1-$i.txt
    echo "B1-$i" > dir_anf/dir/b1-$i.txt
    # simulate 'rsync -a'
    touch -r dir_nas/b1-$i.txt     dir_anf/b1-$i.txt
    touch -r dir_nas/dir/b1-$i.txt dir_anf/dir/b1-$i.txt
done

#
# collapsed file.
#
echo "B-2" > dir_nas/b-2.txt
echo "B-2" > dir_nas/dir/b-2.txt
# give different_timestamp for buffering.
sleep 1
echo "B-2" > dir_anf/b-2.txt
echo "B-2" > dir_anf/dir/b-2.txt
# simulate 'rsync -a'
touch -r dir_nas/b-2.txt     dir_anf/b-2.txt
touch -r dir_nas/dir/b-2.txt dir_anf/dir/b-2.txt
# simulate collapse
chmod 644 dir_nas/b-2.txt dir_nas/dir/b-2.txt
chmod 600 dir_nas/b-2.txt dir_nas/dir/b-2.txt

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
# different file. - normal update
#
echo "D" > dir_nas/d.txt
echo "D" > dir_nas/dir/d.txt
echo "D" > dir_anf/d.txt
echo "D" > dir_anf/dir/d.txt
# give different_timestamp for buffering.
sleep 1
# simulate update source file.
echo "d" > dir_nas/d.txt
echo "d" > dir_nas/dir/d.txt

#
# only ANF.
#
echo "E" > dir_anf/e.txt
echo "E" > dir_anf/dir/e.txt



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


