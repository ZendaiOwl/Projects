use hyper::{body::HttpBody, Body, Request, Response, StatusCode};
use std::os::unix::net::UnixStream;
use std::io::{Read, Write};
use serde_json::json;

use crate::requests::*;
use crate::routes::*;
use crate::types::*;
use common::types::Json;
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

/*
 * Authentication
 * Endpoint Registry: /auth
 * Authentication for registries is handled client side.
 * The client has to send authentication details to various endpoints
 * that need to communicate with registries, such as POST /images/(name)/push.
 * These are sent as X-Registry-Auth header as a base64url encoded (JSON) string with the following structure:
 *
 * Headers
 * X-Registry-Auth: authentication details
 * ↑ base64url encoded (JSON) string
 * Content-Type: application/json
 *
 * Structure:
 * {
 *  "username": "string",
 *  "password": "string",
 *  "email": "string",
 *  "serveraddress": "string"
 * }
 *
 * The serveraddress is a domain/IP without a protocol.
 * Throughout this structure, double quotes are required.
 *
 * If you have already got an identity token from the /auth endpoint,
 * you can just pass this instead of credentials:
 * {
 *  "identitytoken": "9cbaf023786cd7..."
 * }
 *
 * Examples.
 *
 * Request.
 * Content-Type: application/json
 * {
 *  "username": "hannibal",
 *  "password": "xxxx",
 *  "serveraddress": "https://index.docker.io/v1/"
 * }
 *
 * Response.
 * Content-Type: application/json
 * {
 *  "Status": "Login Succeeded",
 *  "IdentityToken": "9cbaf023786cd7..."
 * }
 */
