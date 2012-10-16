# strongswan chef cookbook

## Important Note
=================
When reading/adjusting any StrongSwan configurations, remember these important words:

        left is local to the machine it's stated on; right is remote in the same manner

So on the server side left is local to the server and on the client left is local to that client. Remembering this will save you many a headache.

## Overview
=================
There are three core recipes to this cookbook:
1) ipsec - core ipsec daemons (pluto for ikev1, charon for ikev2), configured according to the chosen scenario:
  a) xauth-psk - XAUTH with a pre-shared key
  b) xauth-id-psk-config - as above, and also able to allocate IP addresses (default)
2) xl2tp - Level 2 tunneling (for Macintosh, etc. clients)
3) routing - set up sysctl and iptables to allow ipsec to do NAT for internal VPN hosts
  NOTE: this recipe does some unsafe manipulation of core config files; beware using it on a non-dedicated server

xl2tp depends on ipsec; routing technically doesn't, but isn't likely to be functional without it.