#!/bin/bash

set -e
set -v

rm -r Base64/ || :
mkdir Base64
cp -R Base64-src/Base64/* Base64/
cd Base64
for x in *.h ; do mv "$x" "JR$x" ; done
for x in *.m ; do mv "$x" "JR$x" ; done
# I would really like to do some name mangling to accomodate the global ObjC namespace here, but that is too hard for now
touch DO_NOT_EDIT_THESE_FILES_SEE_UPDATE_SCRIPT_IN_PARENT_DIRECTORY
cd ..
git add Base64


