#!/usr/bin/env python3

with open("input.txt") as f:
  for l in f:
    a = l.split(" ")
    b = a[1]
    game = b[:-1]
    print(game)
