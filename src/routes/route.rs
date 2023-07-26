use crate::*;
use crate::handlers::*;
use warp::*;
use warp::{Filter};

pub fn get_routes(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    index()
        .or(ct_routes(client.clone()))
        .or(img_routes(client.clone()))
        .or(net_routes(client.clone()))
        .or(vol_routes(client.clone()))
        .or(exec_routes(client))
}

fn ct_routes(client: Connect) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    /* Containers */
    list_containers(client.clone())
        .or(create_container(client.clone()))
        .or(inspect_container(client.clone()))
        .or(list_processes(client.clone()))
        .or(container_logs(client.clone()))
        .or(container_changes(client.clone()))
        .or(export_container(client.clone()))
        .or(container_stats(client.clone()))
        .or(resize_container_tty(client.clone()))
        .or(run_container(client.clone()))
        .or(start_container(client.clone()))
        .or(stop_container(client.clone()))
        .or(restart_container(client.clone()))
        .or(kill_container(client.clone()))
        .or(update_container(client.clone()))
        .or(rename_container(client.clone()))
        .or(pause_container(client.clone()))
        .or(unpause_container(client.clone()))
        .or(attach_container(client.clone()))
        .or(wait_container(client.clone()))
        .or(wait_container_condition(client.clone()))
        .or(remove_container(client.clone()))
        .or(file_info_container(client.clone()))
        .or(container_extract_path_archive(client.clone()))
        .or(prune_containers(client.clone()))
        .or(prune_containers_with_filter(client))
}

fn img_routes(client: Connect) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    /* Images */
    list_images(client.clone())
        .or(build_image(client.clone()))
        .or(prune_builder_cache(client.clone()))
        .or(create_image(client.clone()))
        .or(inspect_image(client.clone()))
        .or(image_history(client.clone()))
        .or(push_image(client.clone()))
        .or(tag_image(client.clone()))
        .or(remove_image(client.clone()))
        .or(search_images(client.clone()))
        .or(delete_unused_images(client.clone()))
        .or(image_from_container(client.clone()))
        .or(image_export(client.clone()))
        .or(export_images(client.clone()))
        .or(import_image(client))
}

fn net_routes(client: Connect) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    /* Networks */
    list_networks(client.clone())
        .or(create_network(client.clone()))
        .or(inspect_network(client.clone()))
        .or(remove_network(client.clone()))
        .or(connect_container_to_network(client.clone()))
        .or(disconnect_container_from_network(client.clone()))
        .or(prune_networks(client.clone()))
        .or(prune_networks_query(client))
}

fn vol_routes(client: Connect) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    /* Volumes */
    list_volumes(client.clone())
        .or(create_volume(client.clone()))
        .or(inspect_volume(client.clone()))
        .or(remove_volume(client.clone()))
        .or(prune_volumes(client.clone()))
        .or(prune_volumes_query(client))
}

fn exec_routes(client: Connect) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    /* Exec */
    create_exec(client.clone())
        .or(start_exec(client.clone()))
        .or(resize_exec(client.clone()))
        .or(inspect_exec(client))
}

/* Helper function to pass the Connect client along to the async function calls */
fn with_connect(
    c: Connect,
) -> impl Filter<Extract = (Connect,), Error = std::convert::Infallible> + Clone {
    warp::any().map(move || c.clone())
}

/* CORS headers */

const MAX_AGE: u32 = 30;

fn get_cors(
    credentials: bool,
    headers: Vec<&str>,
    methods: Vec<&str>,
    age: u32,
) -> warp::filters::cors::Cors {
    warp::cors()
        .allow_credentials(credentials)
        .allow_headers(headers)
        .allow_methods(methods)
        .max_age(age)
        .build()
}

fn cors_get() -> warp::filters::cors::Cors {
    get_cors(
        true,
        vec!["X-Docker-Container-Path-Stat"],
        vec![
            "GET",
        ],
        MAX_AGE,
    )
}

fn cors_post() -> warp::filters::cors::Cors {
    get_cors(
        true,
        vec!["X-Docker-Container-Path-Stat"],
        vec![
            "POST",
        ],
        MAX_AGE,
    )
}

fn cors_put() -> warp::filters::cors::Cors {
    get_cors(
        true,
        vec!["X-Docker-Container-Path-Stat"],
        vec![
            "PUT",
        ],
        MAX_AGE,
    )
}

fn cors_delete() -> warp::filters::cors::Cors {
    get_cors(
        true,
        vec!["X-Docker-Container-Path-Stat"],
        vec![
            "DELETE",
        ],
        MAX_AGE,
    )
}

fn cors_head() -> warp::filters::cors::Cors {
    get_cors(
        true,
        vec!["X-Docker-Container-Path-Stat"],
        vec![
            "HEAD",
        ],
        MAX_AGE,
    )
}

/*
 * Warp Routes/Endpoints
 */
 
fn index(
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    let err_msg_404: &str = "<!DOCTYPE html><head></head><body><h1>Error 404</h1></body></html>";
    warp::path::end().map(move || {
            match std::fs::read_to_string("/home/owl/Code/local/Rust/dockr_dashboard/dashboard/index.html") {
                Ok(body) => {
                    warp::reply::html(body)
                },
                Err(_) => {
                    warp::reply::html(err_msg_404.to_string())
                },
            }
        })
        .with(cors_get())
}

/* Containers */
fn list_containers(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("list" / "containers")
        .and(warp::get())
        .and(with_connect(client))
        .and_then(containers_handler::fetch_containers_list)
        .with(cors_get())
}

fn create_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("create" / "container")
        .and(warp::post())
        .and(warp::body::json())
        .and(with_connect(client))
        .and_then(containers_handler::create_container_req)
        .with(cors_post())
}

fn inspect_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "inspect")
        .and(warp::get())
        .and(with_connect(client))
        .and_then(containers_handler::inspect_container_req)
        .with(cors_get())
}

fn list_processes(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "top")
        .and(warp::get())
        .and(with_connect(client))
        .and_then(containers_handler::list_processes_req)
        .with(cors_get())
}

fn container_logs(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "logs")
        .and(warp::get())
        .and(with_connect(client))
        .and_then(containers_handler::container_logs_req)
        .with(cors_get())
}

fn container_changes(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "changes")
        .and(warp::get())
        .and(with_connect(client))
        .and_then(containers_handler::container_changes_req)
        .with(cors_get())
}

fn export_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "export")
        .and(warp::get())
        .and(with_connect(client))
        .and_then(containers_handler::export_container_req)
        .with(cors_get())
}

fn container_stats(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "stats")
        .and(warp::get())
        .and(with_connect(client))
        .and_then(containers_handler::container_stats_req)
        .with(cors_get())
}

fn resize_container_tty(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "resize" / u32 / u32)
        .and(warp::post())
        .and(with_connect(client))
        .and_then(containers_handler::resize_container_tty_req)
        .with(cors_post())
}

fn run_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / "start")
        .and(warp::post())
        .and(warp::body::json())
        .and(with_connect(client))
        .and_then(containers_handler::run_container_req)
        .with(cors_post())
}

fn start_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "start")
        .and(warp::post())
        .and(with_connect(client))
        .and_then(containers_handler::start_container_req)
        .with(cors_post())
}

fn stop_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "stop")
        .and(warp::post())
        .and(with_connect(client))
        .and_then(containers_handler::stop_container_req)
        .with(cors_post())
}

fn restart_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "restart")
        .and(warp::post())
        .and(with_connect(client))
        .and_then(containers_handler::restart_container_req)
        .with(cors_post())
}

fn kill_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "kill")
        .and(warp::post())
        .and(with_connect(client))
        .and_then(containers_handler::kill_container_req)
        .with(cors_post())
}

fn update_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "update")
        .and(warp::post())
        .and(warp::body::json())
        .and(with_connect(client))
        .and_then(containers_handler::update_container_req)
        .with(cors_post())
}

fn rename_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "rename" / String)
        .and(warp::post())
        .and(with_connect(client))
        .and_then(containers_handler::rename_container_req)
        .with(cors_post())
}

fn pause_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "pause")
        .and(warp::post())
        .and(with_connect(client))
        .and_then(containers_handler::pause_container_req)
        .with(cors_post())
}

fn unpause_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "unpause")
        .and(warp::post())
        .and(with_connect(client))
        .and_then(containers_handler::unpause_container_req)
        .with(cors_post())
}

fn attach_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "attach" / bool / bool / bool / bool / bool)
        .and(warp::post())
        .and(with_connect(client))
        .and_then(containers_handler::attach_container_req)
        .with(cors_post())
}

fn wait_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "wait")
        .and(warp::post())
        .and(with_connect(client))
        .and_then(containers_handler::wait_container_req)
        .with(cors_post())
}

fn wait_container_condition(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "wait" / String)
        .and(warp::post())
        .and(with_connect(client))
        .and_then(containers_handler::wait_container_condition_req)
        .with(cors_post())
}

fn remove_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "remove" / bool / bool / bool)
        .and(warp::post())
        .and(with_connect(client))
        .and_then(containers_handler::remove_container_req)
        .with(cors_post())
}

fn file_info_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "pathinfo" / String)
        .and(warp::head())
        .and(with_connect(client))
        .and_then(containers_handler::container_file_info_req)
        .with(cors_head())
}

fn container_extract_path_archive(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / String / "extract" / String)
        .and(warp::put())
        .and(with_connect(client))
        .and_then(containers_handler::container_extract_path_archive_req)
        .with(cors_put())
}

fn prune_containers(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / "prune")
        .and(warp::post())
        .and(with_connect(client))
        .and_then(containers_handler::prune_containers_req)
        .with(cors_post())
}

fn prune_containers_with_filter(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / "prune" / String)
        .and(warp::post())
        .and(with_connect(client))
        .and_then(containers_handler::prune_containers_with_filter_req)
        .with(cors_post())
}

/* Images */
fn list_images(client: Connect) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("list" / "images")
        .and(warp::get())
        .and(with_connect(client))
        .and_then(images_handler::fetch_images_list)
        .with(cors_get())
}

fn build_image(client: Connect) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("build" / "image")
        .and(warp::post())
        .and(warp::body::json())
        .and(with_connect(client))
        .and_then(images_handler::build_image_req)
        .with(cors_post())
}

fn prune_builder_cache(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("prune" / "build" / "cache" / bool)
        .and(warp::post())
        .and(with_connect(client))
        .and_then(images_handler::prune_builder_cache_req)
        .with(cors_post())
}

fn create_image(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("create" / "image" / String / String / String / String / String)
        .and(warp::post())
        .and(warp::body::json())
        .and(with_connect(client))
        .and_then(images_handler::create_image_req)
        .with(cors_post())
}

fn inspect_image(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("inspect" / "image" / String)
        .and(warp::get())
        .and(with_connect(client))
        .and_then(images_handler::inspect_image_req)
        .with(cors_get())
}

fn image_history(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("history" / "image" / String)
        .and(warp::get())
        .and(with_connect(client))
        .and_then(images_handler::image_history_req)
        .with(cors_get())
}

fn push_image(client: Connect) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("push" / "image" / String / String)
        .and(warp::post())
        .and(warp::body::json())
        .and(with_connect(client))
        .and_then(images_handler::push_image_req)
        .with(cors_post())
}

fn tag_image(client: Connect) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("tag" / "image" / String / String / String)
        .and(warp::post())
        .and(with_connect(client))
        .and_then(images_handler::tag_image_req)
        .with(cors_post())
}

fn remove_image(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("delete" / "image" / String / bool / bool)
        .and(warp::delete())
        .and(with_connect(client))
        .and_then(images_handler::remove_image_req)
        .with(cors_delete())
}

fn search_images(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("search" / "images" / String / u32)
        .and(warp::get())
        .and(with_connect(client))
        .and_then(images_handler::search_images_req)
        .with(cors_get())
}

fn delete_unused_images(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("delete" / "images" / bool)
        .and(warp::post())
        .and(with_connect(client))
        .and_then(images_handler::prune_images_req)
        .with(cors_post())
}

fn image_from_container(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("container" / "to" / "image" / String / String / String / String / String)
        .and(warp::post())
        .and(warp::body::json())
        .and(with_connect(client))
        .and_then(images_handler::image_from_container_req)
        .with(cors_post())
}

fn image_export(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("export" / "image" / String)
        .and(warp::get())
        .and(with_connect(client))
        .and_then(images_handler::image_export_req)
        .with(cors_get())
}

fn export_images(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("export" / "images" / String)
        .and(warp::get())
        .and(with_connect(client))
        .and_then(images_handler::export_images_req)
        .with(cors_get())
}

fn import_image(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("import" / "image" / bool / String)
        .and(warp::post())
        .and(with_connect(client))
        .and_then(images_handler::import_images_req)
        .with(cors_post())
}

/* Networks */
fn list_networks(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("list" / "networks")
        .and(warp::get())
        .and(with_connect(client))
        .and_then(networks_handler::fetch_networks_list)
        .with(cors_get())
}

fn inspect_network(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("inspect" / "network" / String)
        .and(warp::get())
        .and(with_connect(client))
        .and_then(networks_handler::inspect_network_req)
        .with(cors_get())
}

fn remove_network(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("remove" / "network" / String)
        .and(warp::get())
        .and(with_connect(client))
        .and_then(networks_handler::remove_network_req)
        .with(cors_get())
}

fn create_network(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("create" / "network")
        .and(warp::post())
        .and(warp::body::json())
        .and(with_connect(client))
        .and_then(networks_handler::create_network_req)
        .with(cors_post())
}

fn connect_container_to_network(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("network" / "connect" / String)
        .and(warp::post())
        .and(warp::body::json())
        .and(with_connect(client))
        .and_then(networks_handler::connect_container_to_network_req)
        .with(cors_post())
}

fn disconnect_container_from_network(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("network" / "disconnect" / String)
        .and(warp::post())
        .and(warp::body::json())
        .and(with_connect(client))
        .and_then(networks_handler::disconnect_container_from_network_req)
        .with(cors_post())
}

fn prune_networks(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("prune" / "networks")
        .and(warp::post())
        .and(with_connect(client))
        .and_then(networks_handler::prune_networks_req)
        .with(cors_post())
}

fn prune_networks_query(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("prune" / "networks" / String)
        .and(warp::post())
        .and(with_connect(client))
        .and_then(networks_handler::prune_networks_query_req)
        .with(cors_post())
}

/* Volumes */
fn list_volumes(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("list" / "volumes")
        .and(warp::get())
        .and(with_connect(client))
        .and_then(volumes_handler::fetch_volumes_list)
        .with(cors_get())
}

fn create_volume(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("create" / "volume")
        .and(warp::post())
        .and(warp::body::json())
        .and(with_connect(client))
        .and_then(volumes_handler::create_volume_req)
        .with(cors_post())
}

fn inspect_volume(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("inspect" / "volume" / String)
        .and(warp::get())
        .and(with_connect(client))
        .and_then(volumes_handler::inspect_volume_req)
        .with(cors_get())
}

fn remove_volume(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("delete" / "volume" / String / bool)
        .and(warp::delete())
        .and(with_connect(client))
        .and_then(volumes_handler::remove_volume_req)
        .with(cors_delete())
}

fn prune_volumes(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("prune" / "volumes")
        .and(warp::post())
        .and(with_connect(client))
        .and_then(volumes_handler::prune_volumes_req)
        .with(cors_post())
}

fn prune_volumes_query(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("prune" / "volumes" / String)
        .and(warp::post())
        .and(with_connect(client))
        .and_then(volumes_handler::prune_volumes_query_req)
        .with(cors_post())
}

/* Exec */
fn create_exec(client: Connect) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("create" / "exec" / String)
        .and(warp::post())
        .and(warp::body::json())
        .and(with_connect(client))
        .and_then(exec_handler::create_exec_req)
        .with(cors_post())
}

fn start_exec(client: Connect) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("start" / "exec" / String)
        .and(warp::post())
        .and(warp::body::json())
        .and(with_connect(client))
        .and_then(exec_handler::start_exec_req)
        .with(cors_post())
}

fn resize_exec(client: Connect) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("resize" / "exec" / String / String / String)
        .and(warp::post())
        .and(with_connect(client))
        .and_then(exec_handler::resize_exec_req)
        .with(cors_post())
}

fn inspect_exec(
    client: Connect,
) -> impl Filter<Extract = (impl Reply,), Error = Rejection> + Clone {
    warp::path!("inspect" / "exec" / String)
        .and(warp::get())
        .and(with_connect(client))
        .and_then(exec_handler::inspect_exec_req)
        .with(cors_get())
}
