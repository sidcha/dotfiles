#!/bin/bash

IFACE=$1
CHAN=$2

ifconfig $IFACE down
iwconfig $IFACE mode managed
ifconfig $IFACE up
echo "setting channel to $CHAN"
iwconfig $IFACE channel $CHAN
ifconfig $IFACE down
echo "Setting interface $IFACE to monitor mode"
iwconfig $IFACE mode monitor
ifconfig $IFACE up

echo -e "\n$IFACE is now monitoring on channnel $CHAN"
