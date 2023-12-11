// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

//use libdockr::*;
use libapp::connect::Connect;
use libapp::types::*;
use serde_json::json;

#[tauri::command]
async fn test() -> Json {
    json!({
      "message": "OK",
      "code": 200,
    })
}

#[tauri::command]
async fn test_json_argument(arg: Json) -> Json {
    json!({
      "message": "OK",
      "received": arg,
      "code": 200,
    })
}

#[tauri::command]
async fn test_string_argument(arg: String) -> Json {
    json!({
      "message": "OK",
      "received": arg,
      "code": 200,
    })
}

#[tauri::command]
async fn fetch_containers() -> Json {
    let client = Connect::new();
    let response_data = client.list_containers().await;
    response_data
}

#[tauri::command]
async fn container_create(request: Json) -> Json {
    let mut client = Connect::new();
    let response_data = client.create_container(request).await;
    response_data
}

#[tauri::command]
async fn container_create_with_name(name: String, request: Json) -> Json {
    let mut client = Connect::new();
    let response_data = client.create_container_with_name(&name, request).await;
    response_data
}

#[tauri::command]
async fn container_remove(
  id: String, volumes: bool, force: bool, link: bool
) -> Json {
    let mut client = Connect::new();
    let response_data = client.remove_container(&id, volumes, force, link).await;
    response_data
}

#[tauri::command]
async fn container_start(
  id: String
) -> Json {
    let mut client = Connect::new();
    let response_data = client.start_container(&id).await;
    response_data
}

#[tauri::command]
async fn container_stop(
  id: String, signal: String, time: u32
) -> Json {
    let mut client = Connect::new();
    let response_data = client.stop_container(&id, &signal, time).await;
    response_data
}

#[tauri::command]
async fn container_restart(
  id: String, signal: String, time: u32
) -> Json {
    let mut client = Connect::new();
    let response_data = client.restart_container(&id, &signal, time).await;
    response_data
}

#[tauri::command]
async fn fetch_images() -> Json {
    let client = Connect::new();
    let response_data = client.list_images().await;
    response_data
}

#[tauri::command]
async fn pull_image(
  query: String
) -> String {
    let mut client = Connect::new();
    let response_data = client.create_image(query).await;
    response_data
}

#[tauri::command]
async fn remove_image(
  id: String, force: bool, noprune: bool
) -> Json {
    let mut client = Connect::new();
    let response_data = client.remove_image(&id, force, noprune).await;
    response_data
}

#[tauri::command]
async fn fetch_system_info() -> Json {
    let client = Connect::new();
    let response_data = client.system_info().await;
    response_data
}

#[tauri::command]
async fn fetch_volumes() -> Json {
    let client = Connect::new();
    let response_data = client.list_volumes().await;
    response_data
}

#[tauri::command]
async fn volume_remove(name: String, force: bool) -> Json {
    let mut client = Connect::new();
    let response_data = client.remove_volume(&name, force).await;
    response_data
}

#[tauri::command]
async fn volume_create(request: Json) -> Json {
    let mut client = Connect::new();
    let response_data = client.create_volume(request).await;
    response_data
}

#[tauri::command]
async fn fetch_networks() -> Json {
    let client = Connect::new();
    let response_data = client.list_networks().await;
    response_data
}

#[tauri::command(rename_all = "snake_case")]
async fn network_remove(id: String) -> Json {
    let mut client = Connect::new();
    let response_data = client.remove_network(&id).await;
    response_data
}

#[tauri::command]
async fn network_create(request: Json) -> Json {
    let mut client = Connect::new();
    let response_data = client.create_network(request).await;
    response_data
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
          test, test_json_argument, test_string_argument,
          fetch_containers, fetch_images, fetch_volumes, 
          fetch_networks, fetch_system_info,
          container_create, container_remove, container_start, 
          container_stop, container_restart, container_create_with_name,
          pull_image, remove_image,
          network_remove, network_create,
          volume_remove, volume_create
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
