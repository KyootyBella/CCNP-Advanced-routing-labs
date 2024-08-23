hostname R1
no ip domain lookup
line con 0
 logging sync
 exec-time 0 0
 exit

ipv6 unicast-routing

interface Loopback0
 ip address 192.168.1.1 255.255.255.224
 ipv6 address FE80::1:4 link-local
 ipv6 address 2001:DB8:ACAD:1000::1/64
 no shut

interface Loopback1
 ip address 192.168.1.65 255.255.255.192
 ipv6 address FE80::1:5 link-local
 ipv6 address 2001:DB8:ACAD:1001::1/64
 no shut

interface G0/0/0
 ip address 10.1.2.1 255.255.255.0
 ipv6 address FE80::1:1 link-local
 ipv6 address 2001:DB8:ACAD:1012::1/64
 no shut

interface S0/1/0
 ip address 10.1.3.1 255.255.255.128
 ipv6 address FE80::1:2 link-local
 ipv6 address 2001:DB8:ACAD:1013::1/64
 no shut

interface S0/1/1
 ip address 10.1.3.129 255.255.255.128
 ipv6 address FE80::1:3 link-local
 ipv6 address 2001:DB8:ACAD:1014::1/64
 no shut
 exit

router bgp 1000
 bgp router-id 1.1.1.1
 neighbor 10.1.2.2 remote-as 500
 neighbor 10.1.3.3 remote-as 300
 neighbor 10.1.3.130 remote-as 300
 neighbor 2001:db8:acad:1012::2 remote-as 500
 neighbor 2001:db8:acad:1013::3 remote-as 300
 neighbor 2001:db8:acad:1014::3 remote-as 300
 exit

address-family ipv4 unicast
 neighbor 10.1.2.2 activate
 neighbor 10.1.3.3 activate
 neighbor 10.1.3.130 activate
 network 192.168.1.0 mask 255.255.255.224
 network 192.168.1.64 mask 255.255.255.192

address-family ipv6 unicast
 neighbor 2001:db8:acad:1012::2 activate
 neighbor 2001:db8:acad:1013::3 activate
 neighbor 2001:db8:acad:1014::3 activate
 network 2001:db8:acad:1000::/64
 network 2001:db8:acad:1001::/64
 exit

router bgp 1000
 address-family ipv6 unicast
  aggregate-address 2001:db8:acad:1000::/52 summary-only