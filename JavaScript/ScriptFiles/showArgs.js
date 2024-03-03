#!/usr/bin/env node
/* § Victor-ray, S. <owl@zendai.net.eu.org> */
const args = process.argv;
const nodePath = args.shift()
const scriptName = args.shift()
function showArgs() {
  console.log('Number of arguments: ' + args.length)
  args.forEach((val, index) => {
    console.log(`${index}: ${val}`)
  });
}
showArgs();
