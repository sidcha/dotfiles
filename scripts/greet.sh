#!/bin/bash

if [ "$BOX_NAME" = "WORK" ]; then
	echo ""
else
	cat ~/customizer/scripts/ascii.art
fi

FILE=$(ls ~/customizer/scripts/*.list |sort -R |tail -1)

shuf -n 1 $FILE | fold -w 75 -s
echo ""
