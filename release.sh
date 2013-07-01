#!/bin/bash

source require_clean_work_tree.sh
require_clean_work_tree

if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` <release_version_string>"
  echo
  echo "Where <release_version_string> is like v3.4.5"
  exit 1
fi

git tag -a "$1" -m "$1" && git commit --allow-empty -m "$1"
