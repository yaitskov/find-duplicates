#!/bin/bash


function err() {
    echo error: $@ >&2
    exit 1
}

rm -rf test
mkdir -p test || err mkdir test

for i in a/b/c  e/g/d x/y ; do
    mkdir -p test/$i || err mkdir $i
done

echo hello world > test/file || err file

find test -mindepth 1 -type d -exec cp test/file {}-copy \;  || err copy files

#./find-duplicates.rb -l test || err test failed

