#!/bin/bash
# Name: ip-list.sh
# Zeigt Interfaces mit ihren IPv4- und IPv6-Adressen untereinander an

ip addr | awk '
/^[0-9]+: / {
    iface=$2
    gsub(":", "", iface)
    print iface
}
/inet / {
    print "  " $2
}
/inet6 / {
    print "  " $2
}'
