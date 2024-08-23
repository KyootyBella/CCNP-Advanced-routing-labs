# ticket 1
router bgp 65000
 address-family ipv4 unicast
  neighbor 192.168.99.3 next-hop-self
 exit
 address-family ipv6 unicast
  neighbor 2001:db8:c0c0:99::3 next-hop-self
 end

ping 10.2.1.1 source lo1
ping 2001:db8:b0b:f002::1 source lo1

banner motd # This is $(hostname) FIXED from ticket 1 #
wri 

# ticket 2
no route-map AS65100-CAFE permit 10
route-map AS65100-CAFE permit 10
 match ipv6 address prefix-list CAFE-POLICY
 set local-preference 100
 end

clear bgp all 65000

banner motd # This is $(hostname) FIXED from ticket 2 #
wri 