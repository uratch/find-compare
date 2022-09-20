#!/bin/bash

if [ -d dir_nas ];then
  rm -rf dir_nas
fi

if [ -d dir_anf ];then
  rm -rf dir_anf
fi

mkdir -p dir_nas/dir
mkdir -p dir_anf/dir
