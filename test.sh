#!/bin/bash


function err() {
    echo error: $@ >&2
    exit 1
}

mkdir test || err mkdir test

for i in a/b/c  e/g/d x/y ; do
    mkdir -p $i || err mkdir $i
done

echo hello world > test/file || err file

find test -type d -exec cp test/file {} \;  || err copy files

./find-duplicates.rb -l test || err test failed

