#![recursion_limit = "256"]
use dockr_dashboard::connect::Connect;
use dockr_dashboard::routes::route::get_routes;

#[tokio::main]
async fn main() {
    let client = Connect::new();
    warp::serve(get_routes(client)).run(([0, 0, 0, 0], 8080)).await;
}
