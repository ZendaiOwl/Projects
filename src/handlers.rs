/*
 * Functions to fetch data from Docker Engine using Connect client
 */

/* Containers */
pub mod containers_handler {
    use crate::*;
    use std::convert::Infallible;
    pub async fn fetch_containers_list(
        client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.list_containers().await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn create_container_req(
        json: Json,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.create_container(json).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn inspect_container_req(
        id: String,
        client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.inspect_container(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn list_processes_req(
        id: String,
        client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.list_processes(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn container_logs_req(
        id: String,
        client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let res = client.container_logs(&id).await;
        Ok(Box::new(warp::reply::Response::new(ApiReq::rbody(res))))
    }

    pub async fn container_changes_req(
        id: String,
        client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.container_changes(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn export_container_req(
        id: String,
        client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.export_container(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn container_stats_req(
        id: String,
        client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.container_stats(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn resize_container_tty_req(
        id: String,
        height: u32,
        width: u32,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.resize_container_tty(&id, height, width).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn run_container_req(
        json: Json,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.run_container(json).await;
        Ok(Box::new(warp::reply::Response::new(ApiReq::rbody(r))))
    }

    pub async fn start_container_req(
        id: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.start_container(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn stop_container_req(
        id: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.stop_container(&id, "SIGINT", 1).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn restart_container_req(
        id: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.restart_container(&id, "SIGINT", 1).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn kill_container_req(
        id: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.kill_container(&id, "SIGKILL").await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn update_container_req(
        id: String,
        json: Json,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.update_container(&id, json).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn rename_container_req(
        id: String,
        name: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.rename_container(&id, &name).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn pause_container_req(
        id: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.pause_container(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn unpause_container_req(
        id: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.unpause_container(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn attach_container_req(
        id: String,
        logs: bool,
        stream: bool,
        stdin: bool,
        stdout: bool,
        stderr: bool,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client
            .attach_to_container(&id, logs, stream, stdin, stdout, stderr)
            .await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn wait_container_req(
        id: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        // "not-running" "next-exit" "removed"
        let r = client.wait_container(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn wait_container_condition_req(
        id: String,
        condition: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        // "not-running" "next-exit" "removed"
        let r = client.wait_container_condition(&id, condition).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn remove_container_req(
        id: String,
        v: bool,
        force: bool,
        link: bool,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.remove_container(&id, v, force, link).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn container_file_info_req(
        id: String,
        path: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.container_file_info(&id, &path).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn container_extract_path_archive_req(
        id: String,
        path: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.container_extract_archive(&id, &path).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn prune_containers_req(
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.prune_containers().await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn prune_containers_with_filter_req(
        filter: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.prune_containers_with_filters(&filter).await;
        Ok(Box::new(warp::reply::json(&r)))
    }
}

/* Images */
pub mod images_handler {
    use crate::*;
    use std::convert::Infallible;

    pub async fn fetch_images_list(client: Connect) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.list_images().await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn build_image_req(
        json: Json,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let response = client.build_image(json).await;
        Ok(Box::new(warp::reply::json(&response)))
    }

    pub async fn prune_builder_cache_req(
        all: bool,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let response = client.prune_builder_cache(all).await;
        Ok(Box::new(warp::reply::json(&response)))
    }

    pub async fn create_image_req(
        i: String,
        s: String,
        r: String,
        t: String,
        m: String,
        json: Json,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let query = format!("fromImage={i}&fromSrc={s}&repo={r}&tag={t}&message={m}");
        let response = client.create_image(query, json).await;
        Ok(Box::new(warp::reply::json(&response)))
    }

    pub async fn inspect_image_req(
        id: String,
        client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.inspect_image(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn image_history_req(
        id: String,
        client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.image_history(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn push_image_req(
        id: String,
        tag: String,
        auth: Json,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.push_image(&id, &tag, auth).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn tag_image_req(
        id: String,
        repo: String,
        tag: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.tag_image(&id, &repo, &tag).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn remove_image_req(
        id: String,
        force: bool,
        noprune: bool,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.remove_image(&id, force, noprune).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn search_images_req(
        search_term: String,
        limit: u32,
        client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.search_images(&search_term, limit).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn prune_images_req(
        dangling: bool,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.prune_images(dangling).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn image_from_container_req(
        id: String,
        repo: String,
        tag: String,
        comment: String,
        author: String,
        json: Json,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let query =
            format!("container={id}&repo={repo}&tag={tag}&comment={comment}&author={author}");
        let r = client.image_from_container(query, json).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn image_export_req(
        id: String,
        client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.image_export(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn export_images_req(
        names: String,
        client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.export_images(names).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn import_images_req(
        quiet: bool,
        tar_binary: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.import_images(quiet, tar_binary).await;
        Ok(Box::new(warp::reply::json(&r)))
    }
}

/* Networks */
pub mod networks_handler {
    use crate::*;
    use std::convert::Infallible;

    pub async fn fetch_networks_list(client: Connect) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.list_networks().await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn inspect_network_req(
        id: String,
        client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.inspect_network(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn remove_network_req(
        id: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.remove_network(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn create_network_req(
        json: Json,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.create_network(json).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn connect_container_to_network_req(
        id: String,
        json: Json,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.connect_container_to_network(&id, json).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn disconnect_container_from_network_req(
        id: String,
        json: Json,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.disconnect_container_from_network(&id, json).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn prune_networks_req(
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.prune_networks().await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn prune_networks_query_req(
        filters: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.prune_networks_query(&filters).await;
        Ok(Box::new(warp::reply::json(&r)))
    }
}

/* Volumes */
pub mod volumes_handler {
    use crate::*;
    use std::convert::Infallible;

    pub async fn fetch_volumes_list(client: Connect) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.list_volumes().await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn create_volume_req(
        json: Json,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.create_volume(json).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn inspect_volume_req(
        id: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.inspect_volume(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn remove_volume_req(
        id: String,
        force: bool,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.remove_volume(&id, force).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn prune_volumes_req(
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.prune_volumes().await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn prune_volumes_query_req(
        filters: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.prune_volumes_query(&filters).await;
        Ok(Box::new(warp::reply::json(&r)))
    }
}

/* Exec */
pub mod exec_handler {
    use crate::*;
    use std::convert::Infallible;

    pub async fn create_exec_req(
        id: String,
        req: Json,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.create_exec(&id, req).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn start_exec_req(
        id: String,
        req: Json,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.create_exec(&id, req).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn resize_exec_req(
        id: String,
        height: String,
        width: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.resize_exec(&id, &height, &width).await;
        Ok(Box::new(warp::reply::json(&r)))
    }

    pub async fn inspect_exec_req(
        id: String,
        mut client: Connect,
    ) -> Result<Box<dyn warp::Reply>, Infallible> {
        let r = client.inspect_exec(&id).await;
        Ok(Box::new(warp::reply::json(&r)))
    }
}
