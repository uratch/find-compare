#!/bin/bash

if [ -d dir_nas ];then
  rm -rf dir_nas
fi

if [ -d dir_anf ];then
  rm -rf dir_anf
fi

mkdir -p dir_nas/dir
mkdir -p dir_anf/dir

echo "A" > dir_nas/a.txt
echo "A" > dir_nas/dir/a.txt
echo "A" > dir_anf/a.txt
echo "A" > dir_anf/dir/a.txt

echo "B" > dir_nas/b.txt
echo "B" > dir_nas/dir/b.txt
echo "b" > dir_anf/b.txt
echo "b" > dir_anf/dir/b.txt
