#!/usr/bin/python3

import sys
import random
from hashlib import sha1 as sha
username=""
password=""
authlevel=5

length=len(sys.argv)

if length >= 4:
    username = sys.argv[1]
    password = sys.argv[2]
    authlevel = sys.argv[3]
elif length >= 3:
    username = sys.argv[1]
    password = sys.argv[2]
    authlevel= 10
elif length >= 2:
    username = sys.argv[1]
    password = random.random()
    authlevel= 10
else:
    username="localclient"
    password=random.random()
    authlevel=10

if password == '' :
    password=random.random()

hashed_password=sha(str(password).encode('utf8')).hexdigest()
auth_level=str(authlevel)

account_string = "{username}:{hashed_password}:{authlevel}".format(username=username,hashed_password=hashed_password,authlevel=auth_level)
print(account_string)