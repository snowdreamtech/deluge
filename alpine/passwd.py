#!/usr/bin/python3


# Deluge Password Generator
# https://github.com/deluge-torrent/deluge/blob/7f3f7f69ee78610e95bea07d99f699e9310c4e08/deluge/ui/web/auth.py#L188

import hashlib
import os
import sys

password = sys.argv[1]
salt = hashlib.sha1(os.urandom(32)).hexdigest()
s = hashlib.sha1(salt.encode('utf-8'))
s.update(password.encode('utf8'))

pwd_salt=salt
pwd_sha1=s.hexdigest()

password_string = "{salt}:{password}".format(salt=pwd_salt,password=pwd_sha1)
print(password_string)
