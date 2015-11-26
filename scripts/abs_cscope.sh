#!/bin/sh

find $PWD -name '*.[ch]' -exec echo \"{}\" \; | sort -u > cscope.files
cscope -bvq
