# strongswan chef cookbook

My most important words for you to remember when adjusting any IPSEC configurations are this: 
`"left is local to the machine where the file that you are reading it in resides; right is remote in the same manner"`
SO, on the server side left is local to the server and on the client left is local to that client. Remembering this will save you many a headache when working with VPNs and their setup.

##Overview
=================

I have broken down the installation of the StrongSwan IPSEC daemon into 4 seperate Layers to facilitate the widest range of VPN types. This modular approach makes VPN topologies a little easier to configure and ensures that this process is...

		a) NOT cryptic and 
		b) promotes rampant reuse of code, where possible

This layered approach can be explained thusly:

**Layer One** contains basic connection types; one, and only one, of these will be used for any specific VPN.

**Layer Two** enables a given service and makes it available to the other recipes.

**Layer Three** is reserved for optional recipes which extend and/or add to recipes in Layer One.

**Layer Four** is the final step and holds things such as generating client configs and final steps not performed by other recipes.

## Simplified Naming Convention 
==================

Names for recipes in layer one are taken from the names of the suite of tests performed by the creators of StrongSwan itself which are listed at [ikev1](http://www.strongswan.org/uml/testresults/ikev1/) and [ikev2](http://www.strongswan.org/uml/testresults5/ikev2/). Our sanest default for layer one is `nat-psk`. I actually recommend using `xauth-id-psk-config` as it forces a virtual IP pool for the public computers from within StrongSwan.

Names for template follow this format: 
	<recipename>.[client].<filename>.erb => `nat-psk.ipsec.conf.erb` or
											`nat-psk.client.ipsec.conf.erb` 
	

## Requirements
==================

## Usage
==================

