#!/usr/bin/env -S deno run -A
/* § Victor-ray, S. <owl@zendai.net.eu.org> */

import * as net from "node:net";

const ports = [80,443]
const address = Deno.args[0];

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
