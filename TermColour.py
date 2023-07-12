#!/usr/bin/env python3
# Victor-ray, S <12261439+ZendaiOwl@users.noreply.github.com>
class TermColour:
  description        = "ANSI Terminal Colours"
  normal             = '\033[0m' # Reset
  bold               = '\033[1m'
  light              = '\033[2m'
  cursive            = '\033[3m'
  underscore         = '\033[4m'
  blink              = '\033[5m'
  blinking           = '\033[6m' # The same as blink
  highlight          = '\033[7m' # Also called "film" in some places/docs/aticles
  blank              = '\033[8m' # Makes the text invisible
  strikethrough      = '\033[9m'
  double_underscore  = '\033[21m'
  black_light        = '\033[30m'
  red_light          = '\033[31m'
  green_light        = '\033[32m'
  yellow_light       = '\033[33m'
  blue_light         = '\033[34m'
  purple_light       = '\033[35m'
  cyan_light         = '\033[36m'
  gray_light         = '\033[2;37m' # Without light(2) code this one is white-ish
  white_light        = '\033[38m'
  black              = '\033[90m'
  red                = '\033[91m'
  green              = '\033[92m'
  yellow             = '\033[93m'
  blue               = '\033[94m'
  purple             = '\033[95m'
  cyan               = '\033[96m'
  gray               = '\033[2;97m' # Without light(2) code this one is white
  white              = '\033[98m'
  
  def __init__(self):
    self = self
    
  def Black(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.black + text + self.normal} {extra}")
    else:
      return print(f"{self.black + text + self.normal}")
    
  def Red(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.red + text + self.normal} {extra}")
    else:
      return print(f"{self.red + text + self.normal}")
    
  def Green(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.green + text + self.normal} {extra}")
    else:
      return print(f"{self.green + text + self.normal}")
    
  def Yellow(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.yellow + text + self.normal} {extra}")
    else:
      return print(f"{self.yellow + text + self.normal}")
    
  def Blue(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.blue + text + self.normal} {extra}")
    else:
      return print(f"{self.blue + text + self.normal}")
    
  def Purple(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.purple + text + self.normal} {extra}")
    else:
      return print(f"{self.purple + text + self.normal}")
    
  def Cyan(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.cyan + text + self.normal} {extra}")
    else:
      return print(f"{self.cyan + text + self.normal}")
    
  def Gray(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.gray_light + text + self.normal} {extra}")
    else:
      return print(f"{self.gray_light + text + self.normal}")
    
  def White(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.white + text + self.normal} {extra}")
    else:
      return print(f"{self.white + text + self.normal}")
    
  def LightBlack(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.black_light + text + self.normal} {extra}")
    else:
      return print(f"{self.black_light + text + self.normal}")
    
  def LightRed(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.red_light + text + self.normal} {extra}")
    else:
      return print(f"{self.red_light + text + self.normal}")
    
  def LightGreen(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.green_light + text + self.normal} {extra}")
    else:
      return print(f"{self.green_light + text + self.normal}")
    
  def LightYellow(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.yellow_light + text + self.normal} {extra}")
    else:
      return print(f"{self.yellow_light + text + self.normal}")
    
  def LightBlue(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.blue_light + text + self.normal} {extra}")
    else:
      return print(f"{self.blue_light + text + self.normal}")
    
  def LightPurple(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.purple_light + text + self.normal} {extra}")
    else:
      return print(f"{self.purple_light + text + self.normal}")
    
  def LightCyan(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.cyan_light + text + self.normal} {extra}")
    else:
      return print(f"{self.cyan_light + text + self.normal}")
    
  def LightGray(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.gray_light + text + self.normal} {extra}")
    else:
      return print(f"{self.gray_light + text + self.normal}")
    
  def LightWhite(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.white_light + text + self.normal} {extra}")
    else:
      return print(f"{self.white_light + text + self.normal}")
    
  def BoldBlack(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.bold + self.black + text + self.normal} {extra}")
    else:
      return print(f"{self.bold + self.black + text + self.normal}")
    
  def BoldRed(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.bold + self.red + text + self.normal} {extra}")
    else:
      return print(f"{self.bold + self.red + text + self.normal}")
    
  def BoldGreen(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.bold + self.green + text + self.normal} {extra}")
    else:
      return print(f"{self.bold + self.green + text + self.normal}")
    
  def BoldYellow(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.bold + self.yellow + text + self.normal} {extra}")
    else:
      return print(f"{self.bold + self.yellow + text + self.normal}")
    
  def BoldBlue(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.bold + self.blue + text + self.normal} {extra}")
    else:
      return print(f"{self.bold + self.blue + text + self.normal}")
    
  def BoldPurple(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.bold + self.purple + text + self.normal} {extra}")
    else:
      return print(f"{self.bold + self.purple + text + self.normal}")
    
  def BoldCyan(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.bold + self.cyan + text + self.normal} {extra}")
    else:
      return print(f"{self.bold + self.cyan + text + self.normal}")
    
  def BoldGray(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.bold + self.gray_light + text + self.normal} {extra}")
    else:
      return print(f"{self.bold + self.gray_light + text + self.normal}")
    
  def BoldWhite(self, text: str, extra=""):
    if extra != "":
      return print(f"{self.bold + self.white + text + self.normal} {extra}")
    else:
      return print(f"{self.bold + self.white + text + self.normal}")

  def debug(self, text: str):
    return self.Gray('DEBUG', text)

  def info(self, text: str):
    return self.Blue('INFO', text)

  def warning(self, text: str):
    return self.Yellow('WARNING', text)

  def error(self, text: str):
    return self.Red('ERROR', text)
