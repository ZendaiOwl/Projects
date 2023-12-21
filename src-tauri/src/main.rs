// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use serde_json::*;

type JSON = serde_json::Value;

use bollard::Docker;
use bollard::image::*;
use bollard::container::*;
use bollard::container::{CreateContainerOptions, Config};
use bollard::models::*;
use bollard::network::*;
use bollard::volume::*;
use bollard::volume::CreateVolumeOptions;

use std::collections::HashMap;
use std::default::Default;

use futures_util::stream::StreamExt;

#[tauri::command]
async fn test() -> JSON {
    json!({
      "message": "OK",
      "code": 200,
    })
}

#[tauri::command]
async fn test_json_argument(arg: JSON) -> JSON {
    json!({
      "message": "OK",
      "received": arg,
      "code": 200,
    })
}

#[tauri::command]
async fn test_string_argument(arg: String) -> JSON {
    json!({
      "message": "OK",
      "received": arg,
      "code": 200,
    })
}


#[tauri::command]
async fn fetch_system_info() -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();
    let info = &docker.info().await;
    match info {
        Ok(i) => json!(i),
        Err(e) => json!({"error": e.to_string()}),
    }
}

#[tauri::command]
async fn fetch_images() -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();
    let images = &docker.list_images(Some(ListImagesOptions::<String> {
        all: true,
        ..Default::default()
    })).await;
    match images {
        Ok(img) => json!({"images": img}),
        Err(e) => json!({"error": e.to_string()}),
    }
}

#[tauri::command]
async fn pull_image(query: String) -> Vec<CreateImageInfo> {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();
    let options = Some(CreateImageOptions {
        from_image: query,
        ..Default::default()
    });
    
    let mut data: Vec<CreateImageInfo> = Vec::new();
    let mut r_stream = docker.create_image(options, None, None);
    while let Some(msg) = r_stream.next().await {
        data.push(msg.unwrap());
    }
    data
}

#[tauri::command]
async fn delete_image(id: String, force: bool, noprune: bool) -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();

    let remove_options = Some(RemoveImageOptions {
        force: force,
        noprune: noprune,
        ..Default::default()
    });
    
    let r = docker.remove_image(&id, remove_options, None).await;
    match r {
        Ok(r) => json!(r),
        Err(e) => json!({"error": e.to_string()}),
    }
}

#[tauri::command]
async fn fetch_networks() -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();
    let mut list_networks_filters = HashMap::new();
    list_networks_filters.insert("driver", vec!["local"]);
    let config = ListNetworksOptions::<&str> {
        ..Default::default()
    };
    let networks = &docker.list_networks(Some(config)).await;
    match networks {
        Ok(n) => json!({"networks": n}),
        Err(e) => json!({"error": e.to_string() }),
    }
}

#[tauri::command]
async fn network_create(name: String, request: JSON) -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();
    
    let mut config = CreateNetworkOptions {
        name: name,
        driver: "bridge".to_string(),
        ..Default::default()
    };
    
    if request["CheckDuplicate"] == "true" {
        config.check_duplicate = true;
    } else {
        config.check_duplicate = false;
    };
    
    if request["EnableIPv6"] == "true" {
        config.enable_ipv6 = true;
    } else {
        config.enable_ipv6 = false;
    };
    
    if request["Internal"] == "true" {
        config.internal = true;
    } else {
        config.internal = false;
    };
    
    if request["Attachable"] == "true" {
        config.attachable = true;
    } else {
        config.attachable = false;
    };
    
    if request["Ingress"] == "true" {
        config.ingress = true;
    } else {
        config.ingress = false;
    };
    
    if request["Options"] != "none" {
        let mut opts: HashMap<String, String> = HashMap::new();
        for (key, value) in request["Options"].as_object().unwrap().iter() {
            opts.insert(key.to_string(), value.to_string());
        };
        config.options = opts;
    };
    
    let r = docker.create_network(config).await;
    match r {
        Ok(r) => json!(r),
        Err(e) => json!({"error": e.to_string()}),
    }
}

#[tauri::command]
async fn network_remove(id: String) -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();
    let r = docker.remove_network(&id).await;
    match r {
        Ok(r) => json!(r),
        Err(e) => json!({"error": e.to_string()}),
    }
}

#[tauri::command]
async fn fetch_volumes() -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();
    
    let options = ListVolumesOptions::<String> {
        ..Default::default()
    };
    let volumes = &docker.list_volumes(Some(options)).await;
    match volumes {
        Ok(v) => json!(v),
        Err(e) => json!({"error": e.to_string()}),
    }
}

#[tauri::command]
async fn volume_remove(name: String, force: bool) -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();

    let options = RemoveVolumeOptions {
        force: force,
    };
    
    let r = &docker.remove_volume(&name, Some(options)).await;
    match r {
        Ok(r) => json!(r),
        Err(e) => json!({"error": e.to_string()}),
    }
}

#[tauri::command]
async fn volume_create(request: JSON) -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();

    let mut config = CreateVolumeOptions {
        name: "",
        ..Default::default()
    };
    
    if request["Name"] != "none" {
        config.name = request["Name"].as_str().unwrap();
    };
    
    if request["Labels"] != "none" {
        let mut labels: HashMap<&str, &str> = HashMap::new();
        for (key, value) in request["Labels"].as_object().unwrap().iter() {
            labels.insert(key.as_str(), value.as_str().unwrap());
        };
        config.labels = labels;
    };
    
    let r = &docker.create_volume(config).await;
    match r {
        Ok(r) => json!(r),
        Err(e) => json!({"error": e.to_string()}),
    }
}

#[tauri::command]
async fn fetch_containers() -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();
    let containers = &docker.list_containers(Some(ListContainersOptions::<String> {
        all: true,
        ..Default::default()
    })).await;
    match containers {
        Ok(c) => json!({"containers": c}),
        Err(e) => json!({"error": e.to_string()}),
    }
}

#[tauri::command(rename_all = "snake_case")]
async fn container_create(
    i: String, name: String, network: String, data: JSON
) -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();
    let options = Some(CreateContainerOptions::<String>{
        name: name.to_string(),
        platform: None,
    });
    
    let mut config = Config::<String> {
        image: Some(i),
        ..Default::default()
    };
    
    if data["Hostname"] != "none" {
        config.hostname = Some(data["Hostname"].to_string());
    };
    
    if data["Domainname"] != "none" {
        config.domainname = Some(data["Domainname"].to_string());
    };
    
    if data["User"] != "none" {
        config.user = Some(data["User"].to_string());
    };
    
    if data["Entrypoint"] != "none" {
        config.entrypoint = Some(vec![data["Entrypoint"].to_string()]);
    };
    
    if data["Env"] != "none" {
        config.env = Some(vec![data["Env"].to_string()]);
    };
    
    let mut port_host = PortBinding {
        ..Default::default()
    };
    
    let mut ports = HashMap::new();
    
    let mut host_configuration = HostConfig {
        ..Default::default()
    };
    
    if data["HostConfig"]["Privileged"] == "true" {
        host_configuration.privileged = Some(true);
    } else {
        host_configuration.privileged = Some(false);
    };
    
    if network != "none" {
        host_configuration.network_mode = Some(network);
    };
    
    if data["HostPort"] != "none" 
    && data["ContainerPort"] != "none" {
        port_host.host_port = Some(data["HostPort"].to_string());
        ports.insert(
            String::from(data["ContainerPort"].to_string() + "/tcp"), 
            vec![port_host].into()
        );
        host_configuration.port_bindings = Some(ports);
    };
    
    config.host_config = Some(host_configuration);
    
    if data["Cmd"] != "none" {
        config.cmd = Some(vec![data["Cmd"].to_string()]);
    };
    
    let created = &docker.create_container(options, config).await;
    match created {
        Ok(result) => json!(result),
        Err(error) => json!({"error": error.to_string()}), 
    }
}

#[tauri::command]
async fn container_start(id: String) -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();
    let r = &docker.start_container(
        &id, None::<StartContainerOptions<String>>
    ).await;
    match r {
        Ok(response) => json!({"message": "OK", "output": response}),
        Err(e) => json!({"error": e.to_string()}),
    }
}

#[tauri::command]
async fn container_restart(id: String, time: isize) -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();
    let options = Some(RestartContainerOptions{
        t: time,
    });
    let response = &docker.restart_container(&id, options).await;
    match response {
        Ok(r) => json!(r),
        Err(e) => json!({"error": e.to_string()}),
    }
}

#[tauri::command]
async fn container_stop(id: String, time: i64) -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();
    let options = Some(StopContainerOptions{
        t: time,
    });
    let response = &docker.stop_container(&id, options).await;
    match response {
        Ok(r) => json!(r),
        Err(e) => json!({"error": e.to_string()}),
    }
}

#[tauri::command]
async fn container_remove(
    id: String, force: bool, volume: bool, l: bool
) -> JSON {
    let docker: Docker = Docker::connect_with_local_defaults().unwrap();
    let options = Some(RemoveContainerOptions{
        v: volume,
        force: force,
        link: l,
    });
    let removed = &docker.remove_container(&id, options).await;
    match removed {
        Ok(data) => json!(data),
        Err(error) => json!({"error": error.to_string()})
    }
}



fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
          test, test_json_argument, test_string_argument,
          fetch_system_info, fetch_images, pull_image, delete_image,
          fetch_networks, network_create, network_remove,
          fetch_volumes, volume_remove, volume_create,
          fetch_containers, container_create, container_remove, 
          container_stop, container_restart, container_start
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
