no ip domain lookup
hostname R2

line con 0
 exec-timeout 0 0
 logging synchronous

banner motd # This is R2, BGP Path Manipulation Lab #

ipv6 unicast-routing

interface g0/0/0
 ip address 10.1.2.2 255.255.255.0
 ipv6 address fe80::2:1 link-local
 ipv6 address 2001:db8:acad:1012::2/64
 no shutdown

interface g0/0/1
 ip address 10.2.3.2 255.255.255.0
 ipv6 address fe80::2:2 link-local
 ipv6 address 2001:db8:acad:1023::2/64
 no shutdown

interface loopback0
 ip address 192.168.2.1 255.255.255.224
 ipv6 address fe80::2:3 link-local
 ipv6 address 2001:db8:acad:2000::1/64
 no shutdown

interface loopback1
 ip address 192.168.2.65 255.255.255.192
 ipv6 address fe80::2:4 link-local
 ipv6 address 2001:db8:acad:2001::1/64
 no shutdown

router bgp 500
 bgp router-id 2.2.2.2
 no bgp default ipv4-unicast
 neighbor 10.1.2.1 remote-as 6500
 neighbor 10.2.3.3 remote-as 300
 neighbor 2001:db8:acad:1012::1 remote-as 6500
 neighbor 2001:db8:acad:1023::3 remote-as 300

address-family ipv4
 network 192.168.2.0 mask 255.255.255.224
 network 192.168.2.64 mask 255.255.255.192
 neighbor 10.1.2.1 activate
 neighbor 10.2.3.3 activate
 no neighbor 2001:db8:acad:1012::1 activate
 no neighbor 2001:db8:acad:1023::3 activate
 exit

address-family ipv6
 network 2001:db8:acad:2000::/64
 network 2001:db8:acad:2001::/64
 neighbor 2001:db8:acad:1012::1 activate
 neighbor 2001:db8:acad:1023::3 activate
 exit
