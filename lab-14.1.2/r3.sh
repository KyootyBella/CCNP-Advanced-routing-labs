# ticket 1
router bgp 65000
 address-family ipv4 unicast
  neighbor 192.168.99.1 next-hop-self
 exit
 address-family ipv6 unicast
  neighbor 2001:db8:c0c0:99::1 next-hop-self
 end

banner motd # This is $(hostname) FIXED from ticket 1 #
wri 

# ticket 2
no route-map AS65200-CAFE permit 10
route-map AS65200-CAFE permit 10
 match ipv6 address prefix-list CAFE-POLICY
 set local-preference 400
 end

clear bgp all 65000

banner motd # This is $(hostname) FIXED from ticket 2 #
wri 