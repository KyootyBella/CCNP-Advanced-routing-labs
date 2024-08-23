no ip domain lookup
hostname R1
line con 0
 exec-timeout 0 0
 logging synchronous
banner motd # This is R1, BGP Path Manipulation Lab #

ipv6 unicast-routing

interface g0/0/0 
 ip address 10.1.2.1 255.255.255.0
 ipv6 address fe80::1:1 link-local
 ipv6 address 2001:db8:acad:1012::1/64
 no shutdown

interface s0/1/0
 ip address 10.1.3.1 255.255.255.128
 ipv6 address fe80::1:2 link-local
 ipv6 address 2001:db8:acad:1013::1/64
 no shutdown

interface s0/1/1
 ip address 10.1.3.129 255.255.255.128
 ipv6 address fe80::1:3 link-local
 ipv6 address 2001:db8:acad:1014::1/64
 no shutdown

interface loopback0
 ip address 192.168.1.1 255.255.255.224
 ipv6 address fe80::1:4 link-local
 ipv6 address 2001:db8:acad:1000::1/64
 no shutdown

interface loopback1
 ip address 192.168.1.65 255.255.255.192
 ipv6 address fe80::1:5 link-local
 ipv6 address 2001:db8:acad:1001::1/64
 no shutdown
 exit

router bgp 6500
 bgp router-id 1.1.1.1
 no bgp default ipv4-unicast
 neighbor 10.1.2.2 remote-as 500
 neighbor 10.1.3.3 remote-as 300
 neighbor 10.1.3.130 remote-as 300
 neighbor 2001:db8:acad:1012::2 remote-as 500
 neighbor 2001:db8:acad:1013::3 remote-as 300
 neighbor 2001:db8:acad:1014::3 remote-as 300

address-family ipv4 unicast
network 192.168.1.0 mask 255.255.255.224
 network 192.168.1.64 mask 255.255.255.192
 no neighbor 2001:db8:acad:1012::2 activate
 no neighbor 2001:db8:acad:1013::3 activate
 no neighbor 2001:db8:acad:1014::3 activate
 neighbor 10.1.2.2 activate
 neighbor 10.1.3.3 activate
 neighbor 10.1.3.130 activate

address-family ipv6 unicast
 network 2001:db8:acad:1000::/64
 network 2001:db8:acad:1001::/64
 neighbor 2001:db8:acad:1012::2 activate
 neighbor 2001:db8:acad:1013::3 activate
 neighbor 2001:db8:acad:1014::3 activate


# RUN LATER

# Check first with this command
show bgp ipv4 unicast | begin 192.168.3

# rewrite IP to whatever runs on ASN 500
ip prefix-list ALLOWED_FROM_R2 seq 5 permit 192.168.x.0/24 le 27

# apply rule
router bgp 6500
 address-family ipv4 unicast
  neighbor 10.1.2.2 prefix-list ALLOWED_FROM_R2 in
  end

clear bgp ipv4 unicast 500 in


# run this command on R2 to check ASN6500
show bgp ipv4 unicast | begin Network

# config AS-PATH
ip as-path access-list 1 permit ^$

router bgp 6500
 address-family ipv4 unicast
  neighbor 10.1.2.2 filter-list 1 out
  end

clear bgp ipv4 unicast 500 out

# run this command on R1 to check ASN6500 IPV6
show bgp ipv6 unicast neighbors 2001:db8:acad:1012::2 routes

ipv6 prefix-list IPV6_ALLOWED_FROM_R2 seq 5 permit 2001:db8:acad:x::/64
ipv6 prefix-list IPV6_ALLOWED_FROM_R2 seq 10 permit 2001:db8:acad:x::/64

router bgp 6500
 address-family ipv6 unicast
   neighbor 2001:db8:acad:1012::2 prefix-list IPV6_ALLOWED_FROM_R2 in
   end

clear bgp ipv6 unicast 500 in

# bgp paths
show bgp ipv4 unicast 192.168.3.0

ip prefix-list PREFERRED_IPV4_PATH seq 5 permit 192.168.3.0/24 le 27
route-map USE_THIS_PATH_FOR_IPV4 permit 10
match ip address prefix-list PERFERRED_IPV4_PATH
set local-preference 250

router bgp 6500
 address-family ipv4 unicast
  neighbor 10.1.3.130 route-map USE_THIS_PATH_FOR_IPV4 in
  end

clear bgp ipv4 unicast 300 in
