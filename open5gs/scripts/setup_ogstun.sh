#!/bin/sh

# create interfaces
ip tuntap add name ogstun mode tun
ip link set ogstun up
ip tuntap add name ogstun2 mode tun
ip link set ogstun2 up

# set addresses
ip addr add 10.45.0.1/16 dev ogstun
ip addr add 2001:db8:cafe::1/48 dev ogstun
ip addr add 10.46.0.1/16 dev ogstun2
ip addr add 2001:db8:babe::1/48 dev ogstun2

# setup firewall
iptables -I INPUT -i ogstun -j ACCEPT
iptables -I INPUT -i ogstun2 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE
ip6tables -t nat -A POSTROUTING -s 2001:db8:cafe::/48 ! -o ogstun -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.46.0.0/16 ! -o ogstun2 -j MASQUERADE
ip6tables -t nat -A POSTROUTING -s 2001:db8:babe::/48 ! -o ogstun2 -j MASQUERADE

