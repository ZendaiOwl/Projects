#!/bin/bash
python3

import aux_funcs, sys, json, time, random
from igramscraper.instagram import Instagram
from LevPasha.InstagramAPI import InstagramAPI # pylint: disable=no-name-in-module

# If account is public you can query Instagram without auth
instagram = Instagram()

# If account is private and you subscribed to it, first login
# instagram.with_credentials('username', 'password', 'cachePath')
# instagram.login()

URL = 'https://www.instagram.com/p/CUFqfZFIAYN/'

media = instagram.get_media_by_url(URL)

print(media)
print(media.owner)

account = instagram.get_account(media.owner)
usrID = account.identifier

# get likes
likes = instagram.get_media_likes_by_code(URL, 74)

# print list to a file

#Encrypt/Decryot


exit
