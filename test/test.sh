#!/bin/bash


function err() {
    echo error: $@ >&2
    exit 1
}

TREE=dir-tree
rm -rf $TREE
mkdir -p $TREE || err mkdir $TREE

for i in a/b/c  e/g/d x/y ; do
    mkdir -p $TREE/$i || err mkdir $i
done

echo hello world > $TREE/file || err file

find $TREE -mindepth 1 -type d -exec cp $TREE/file {}-copy \;  || err copy files

#./find-duplicates.rb -l $TREE || err $TREE failed

