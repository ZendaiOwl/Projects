#!/usr/bin/env node
/* § Victor-ray, S. <owl@zendai.net.eu.org> */
const http = require('http')
const net = require('net')
const ports = [80,443]
const args = process.argv
const nodePath = args.shift()
const scriptName = args.shift()
const address = args.shift()
async function checkPort(address, port) {
  return new Promise(resolve => {
    let socket = net.createConnection({host: address, port: port, timeout: 100})
    socket.on("error", () => {
      socket.end()
      resolve("Closed")
    });
    socket.on("connect", () => {
        socket.end()
        resolve("Open")
    });
  });
}
if (address == null) {
  console.log("Error: No address supplied to check for open 80 & 443 ports")
} else {
  console.log(`Host: ${address}`)
  ports.forEach(port => {
    checkPort(address, port).then(result => {
      console.log(`Port ${port}: ${result}`)
    });
  })
}
