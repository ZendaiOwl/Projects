#!/usr/bin/env python3

total = 0
digit = 0
all_digits = ""
the_digits = "";

with open("input.txt") as f:
  for line in f:
    i = 0
    while i < len(line):
      c = line[i].strip()
      i += 1
      if c.isdigit():
        all_digits += c
    digit = int(all_digits[0] + all_digits[len(all_digits)-1])
    print(digit)
    total += digit
    all_digits = ""

print(total)
