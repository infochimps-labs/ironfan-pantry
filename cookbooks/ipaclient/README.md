ipaclient Cookbook
==================
Installation cookbook for freeipa-client

Requirements
------------
The location of the FreeIPA server and the domain we use for IPA is hardcoded 
in the default attributes script. 
This package is dependent upon [ipa-secret](https://github.com/4thAce/ipa-secret) and will include it at run time. (Contact me if you need access to that repo.)

Attributes
----------

#### ipaclient::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>nsspasswordfile</tt></td>
    <td>String</td>
    <td>Path to the password file for nss</td>
  </tr>
  <tr>
    <td><tt>secretpath</tt></td>
    <td>String</td>
    <td>Path to the secret file unlocking the encrypted data bag</td>
  </tr>
  <tr>
    <td><tt>domain</tt></td>
    <td>String</td>
    <td>DNS subdomain</td>
  </tr>
  <tr>
    <td><tt>masterhostname</tt></td>
    <td>String</td>
    <td>Hostname of the IPA server (not including the domain)</td>
  </tr>
  <tr>
    <td><tt>opensshver</tt></td>
    <td>String</td>
    <td>Version of openssh which supports dynamically loading authorized 
        user keys</td>
  </tr>
  <tr>
    <td><tt>ns</tt></td>
    <td>List of strings</td>
    <td>Nameservers for the subdomain</td>
  </tr>
</table>

Usage
-----
#### ipaclient::default
Dummy method
#### ipaclient::install_client
Install the ipa client. After it completes you should be able to ssh in to the
client using a login on the specified ipa installation, and to sudo if your
account belongs to the proper user groups.
#### ipaclient::update_hosts
Set the hostname and edit /etc/hosts to agree with it

License and Authors
-------------------
Authors: Rich Magahiz
