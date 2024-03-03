#!/usr/bin/env node
/* § Victor-ray, S. <owl@zendai.net.eu.org> */
const args = process.argv
const nodePath = args.shift()
const scriptName = args.shift()
const success = '\x1b[32mSUCCESS\x1b[0m:'
const space = " "
if (args != 0) {
  logText = ""
  args.forEach(txt => {
    logText += txt + space
  })
  console.log(success, logText)
} else {
  console.log("No arguments")
}
