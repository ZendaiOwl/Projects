#![recursion_limit = "256"]
use hyper::{body::HttpBody, Body, Request, Response, StatusCode};
use std::os::unix::net::UnixStream;
use std::io::{Read, Write};
use serde_json::json;

use crate::requests::*;
use crate::routes::*;
use crate::types::*;
use crate::connect::*;

pub mod types;
pub mod routes;
pub mod requests;
pub mod handlers;
pub mod connect;
    
#[allow(dead_code)]
fn read_from_stream(unix_stream: &mut UnixStream) -> Result<(), std::io::Error> {
    let mut response = String::new();
    unix_stream
        .read_to_string(&mut response)
        .expect("Failed at reading the unix stream");
    println!("{}", response);
    Ok(())
}

#[allow(dead_code)]
fn write_request_and_shutdown(unix_stream: &mut UnixStream) -> Result<(), std::io::Error> {
    let json = json!({
            "Image": "debian:bullseye",
            "Cmd": [
                "echo",
                "hello world"
            ]
    });
    unix_stream
        .write_all(&serde_json::to_vec(&json).expect("Failed to parse json"))
        .expect("Failed at writing onto the unix stream");
    println!("We sent a request");
    println!("Shutting down writing on the stream, waiting for response...");
    unix_stream
        .shutdown(std::net::Shutdown::Write)
        .expect("Could not shutdown writing on the stream");
    Ok(())
}
