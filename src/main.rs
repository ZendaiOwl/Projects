#[allow(unused_imports)]
use std::{
    net::{Ipv4Addr, Ipv6Addr, SocketAddr},
    task::{Context, Poll},
    pin::{Pin},
};

#[allow(unused_imports)]
use hyper::server::{
    accept::{Accept},
    conn::{AddrIncoming},
};

#[allow(unused_imports)]
use axum::{
    http::{HeaderValue, Method, StatusCode, Request},
    response::{Html, Response, IntoResponse},
    routing::{get},
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
};

#[allow(unused_imports)]
use rs_client::{
    routing::routes::{Backend, Frontend},
};

#[tokio::main]
async fn main() {
    let backend = async {
        let app = Backend::get_routes();
        serve(app, 3969).await;
    };

    let frontend = async {
        let app = Frontend::get_routes();
        serve(app, 3000).await;
    };

    tokio::join!(backend, frontend);
}

async fn serve(app: Router, port: u16) {
    let addr = SocketAddr::from(([127, 0, 0, 1], port));
    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .expect("Failed to start axum server");
}
