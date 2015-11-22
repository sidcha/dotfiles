#!/bin/bash

if [ "$BOX_NAME" = "WORK" ]; then
	echo ""
else
	cat ~/customizer/scripts/ascii.art
fi
shuf -n 1 ~/customizer/scripts/quote.list | fold -w 75 -s
echo ""
