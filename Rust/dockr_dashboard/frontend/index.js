#!/usr/bin/env node

const rust = import { './pkg' };

rust.log("Hello from index.js").await;
