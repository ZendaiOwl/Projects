#!/usr/bin/env python3

total = 0
digit = 0
all_digits = ""
the_digits = "";

numbers = {
  0: "zero",
  1: "one",
  2: "two",
  3: "three",
  4: "four",
  5: "five",
  6: "six",
  7: "seven",
  8: "eight",
  9: "nine"
}

string_numbers = {
  "zero": 0,
  "one": 1,
  "two": 2,
  "three": 3,
  "four": 4,
  "five": 5,
  "six": 6,
  "seven": 7,
  "eight": 8,
  "nine": 9
}


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
