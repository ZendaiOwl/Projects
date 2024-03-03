#!/usr/bin/env -S deno run -A
/* § Victor-ray, S. <owl@zendai.net.eu.org> */

import express from "npm:express@4.18.2";

const app = express();

app.get("/", (_req, res) => {
    res.send("Welcome to the Dinosaur API!");
});

app.listen(3000);