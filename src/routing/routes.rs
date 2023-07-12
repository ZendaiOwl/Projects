use crate::*;
#[allow(unused_imports)]
use crate::handlers::*;
#[allow(unused_imports)]
use crate::handlers::images_handler;
#[allow(unused_imports)]
use crate::image_models::ImageList;
#[allow(unused_imports)]
use crate::image_models::ListImages;
#[allow(unused_imports)]
use axum::{
    handler::{Handler},
    http::{HeaderValue, Method, StatusCode, Request, header::CONTENT_TYPE},
    response::{Html, Response, Json},
    routing::{get, post, put, delete, head, MethodRouter},
    Router,
};

#[allow(unused_imports)]
use tower_http::{
    cors::{CorsLayer},
};

#[allow(unused_imports)]
use tower_service::{
    Service,
};

pub struct Backend {}

impl Backend {
    pub fn get_routes() -> axum::Router {
        Router::new()
            .route("/json", get(Self::json)).layer(
                // see https://docs.rs/tower-http/latest/tower_http/cors/index.html
                // for more details
                //
                // pay attention that for some request types like posting content-type: application/json
                // it is required to add ".allow_headers([http::header::CONTENT_TYPE])"
                // or see this issue https://github.com/tokio-rs/axum/issues/849
                CorsLayer::new()
                    .allow_origin("http://localhost:3000".parse::<HeaderValue>().unwrap())
                    .allow_methods([Method::GET]),
            )
            .route("/list", get(Self::ls_img)).layer(
                CorsLayer::new()
                    .allow_origin("http://localhost:3000".parse::<HeaderValue>().unwrap())
                    .allow_methods([Method::GET])
                    .allow_headers([CONTENT_TYPE]),
            )
    }
    
    async fn ls_img() -> Json<JSON> {
        axum::Json(Connect::new().list_images().await)
    }

    pub async fn json() -> impl IntoResponse {
        Json(vec!["one", "two", "three"])
    }
}

pub struct Frontend {}

impl Default for Frontend {
    fn default() -> Self {
        Self {}
    }
}

impl Frontend {
    pub fn get_routes() -> axum::Router {
        Router::new()
            .route("/", get(Self::html))
            .route("/index", get(Self::index))
            .route("/index_response", get(Self::index_response))
    }
    
    pub async fn index() -> Html<&'static str> {
        Html(
            "<!DOCTYPE html>
            <head></head>
            <header></header>
            <body>
                <h1>Hello there!</h1>
            </body>
            <footer></footer>
            </html>"
        )
    }
    
    pub async fn index_response() -> impl IntoResponse {
        Html(r#"
            <!DOCTYPE html>
            <head></head>
            <header></header>
            <body>
                <h1>Hello there!</h1>
            </body>
            <footer></footer>
            </html>
            "#,
        )
    }
    
    pub async fn html() -> impl IntoResponse {
        Html(r#"
            <!DOCTYPE html>
            <head></head>
            <header></header>
            <body><p>Hello</p></body>
            <footer></footer>
            <script>
                fetch('http://localhost:3969/json')
                .then(response => response.json())
                .then(data => console.log(data));
            </script>
            </html>
            "#,
        )
    }
}
