#!/usr/bin/env -S deno run -A
/* § Victor-ray, S. <owl@zendai.net.eu.org> */

import * as http from "node:http";
import * as net from "node:net";

Deno.serve((_request: Request) => {
    return new Response("Hello, world!");
});
