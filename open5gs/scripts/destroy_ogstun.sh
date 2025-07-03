#!/bin/sh

# destroy interfacs
ip link delete ogstun
ip link delete ogstun2

# setup firewall
#iptables -t nat -D POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE
#ip6tables -t nat -D POSTROUTING -s 2001:db8:cafe::/48 ! -o ogstun -j MASQUERADE
#iptables -t nat -D POSTROUTING -s 10.46.0.0/16 ! -o ogstun2 -j MASQUERADE
#ip6tables -t nat -D POSTROUTING -s 2001:db8:babe::/48 ! -o ogstun2 -j MASQUERADE

