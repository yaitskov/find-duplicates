find-duplicates
===============


This tool is written directly for 1 usecase.
There is 2 folders containing relativly similar files
but these files are in different pathes.
And you need to merge folder structures
without space overhead.

Example you have files on your stick and PC HDD.
Often these parallel structures are tend to diverse since the time.

Solution. Merge file sets with cp or rsync.
Start this script over the result directory structure.
Script builds hashes for all files.
Groups paths to files with the same hash.

There is one deletion policy.
A file from a duplicates group with longest path servive other are removed.
Dry mode is used by default.



Installation
============

$ sudo gem install find-duplicates
