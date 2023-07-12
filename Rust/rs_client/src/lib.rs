#[allow(unused_imports)]
use std::{
    os::unix::net::UnixStream,
    io::{Read, Write},
    net::{Ipv4Addr, Ipv6Addr, SocketAddr},
    task::{Context, Poll},
    pin::{Pin},
};

#[allow(unused_imports)]
use hyper::{
    body::{HttpBody},
    server::{
        accept::{Accept},
        conn::{AddrIncoming},
    },
};

#[allow(unused_imports)]
use axum::{
    body::{Body},
    http::{HeaderValue, Method, StatusCode, Request},
    response::{Html, Response, IntoResponse},
    routing::{get, post, put, delete, head, MethodRouter},
    Json, Router,
};

#[allow(unused_imports)]
use tower_http::{
    cors::{CorsLayer},
};

#[allow(unused_imports)]
use tower::{
    Service,
};

#[allow(unused_imports)]
use futures_executor::{
    block_on,
};

#[allow(unused_imports)]
use serde::{
    Deserialize,
    Serialize,
};

#[allow(unused_imports)]
use serde_json::{
    Value,
    json,
};

use crate::requests::*;
use crate::routing::*;
use crate::connect::*;
use crate::models::*;

pub mod routing;
pub mod requests;
pub mod handlers;
pub mod connect;
pub mod models;

pub type URL = hyper::Uri;
pub type Req = axum::http::Request<Body>;
pub type ReqBody = axum::body::Body;
pub type Resp = axum::response::Response<Body>;
pub type JSON = serde_json::Value;
// pub type HTML = axum::response::Html;
