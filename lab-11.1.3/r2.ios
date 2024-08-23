hostname R2
no ip domain lookup
line con 0
 logging sync
 exec-time 0 0
 exit

ipv6 unicast-routing

interface Loopback0
 ip address 192.168.2.1 255.255.255.224
 ipv6 address FE80::2:3 link-local
 ipv6 address 2001:DB8:ACAD:2000::1/64
 no shut

interface Loopback1
 ip address 192.168.2.65 255.255.255.192
 ipv6 address FE80::2:4 link-local
 ipv6 address 2001:DB8:ACAD:2001::1/64
 no shut

interface G0/0/0
 ip address 10.1.2.2 255.255.255.0
 ipv6 address FE80::2:1 link-local
 ipv6 address 2001:DB8:ACAD:1012::2/64
 no shut

interface G0/0/1
 ip address 10.2.3.2 255.255.255.0
 ipv6 address FE80::2:2 link-local
 ipv6 address 2001:DB8:ACAD:1023::2/64
 no shut
 exit

router bgp 500
 bgp router-id 2.2.2.2
 neighbor 10.1.2.1 remote-as 1000
 neighbor 10.2.3.3 remote-as 300
 neighbor 2001:db8:acad:1012::1 remote-as 1000
 neighbor 2001:db8:acad:1023::3 remote-as 300


address-family ipv4 unicast
 neighbor 10.1.2.1 activate
 neighbor 10.2.3.3 activate
 network 192.168.2.0 mask 255.255.255.224
 network 192.168.2.64 mask 255.255.255.192
 exit

address-family ipv6 unicast
 neighbor 2001:db8:acad:1012::1 activate
 neighbor 2001:db8:acad:1023::3 activate
 network 2001:db8:acad:2000::/64
 network 2001:db8:acad:2001::/64
 exit
