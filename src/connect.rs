use crate::*;
#[allow(unused_imports)]
use crate::models::image_models::ImageList;
#[allow(unused_imports)]
use crate::models::image_models::ListImages;
use crate::routing::containers::*;
use crate::routing::images::*;
use crate::routing::volumes::*;
use crate::routing::networks::*;
use crate::routing::exec::*;
use crate::routing::system::*;
use crate::routing::format::*;
use hyper::{service::Service, Body, Client};
use hyperlocal::{UnixClientExt, UnixConnector};
use serde_json::json;

#[derive(Clone)]
pub struct Connect {
    client: Client<UnixConnector, Body>,
}

impl Default for Connect {
    fn default() -> Self {
        Self::new()
    }
}

/* Creation of Connect object and helper functions */
impl Connect {
    /* New Connect object */
    pub fn new() -> Connect {
        Connect {
            client: Client::unix(),
        }
    }
    
    /* Attempts a GET request on the given endpoint and writes the response to the given writer */
    pub async fn try_response(&self, endpoint: &str, writer: impl std::io::Write) {
        let response = self
            .client
            .get(FormatApi::Uri(endpoint).to_url())
            .await
            .expect("Failed to get response");
        ApiReq::into_writer(response, writer).await;
    }

    /* GET request on the given URL (hyper::Uri) */
    pub async fn get_request(&self, url: URL) -> Resp {
        self.client.get(url).await.expect("GET Request call failed")
    }

    /* Sends the given request */
    pub async fn request_call(&mut self, req: Req) -> Resp {
        self.client.call(req).await.expect("Request call failed")
    }
}

/* Container commands */
impl Connect {
    /* Verify authentication information for the configured registry */
    pub async fn verify(&mut self, req_body: JSON) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            System::Auth.to_url(),
            ApiReq::rbody(req_body.to_string()),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn verify_to_writer(&mut self, req_body: JSON) {
        let req = ApiReq::create_request(
            "POST",
            System::Auth.to_url(),
            ApiReq::rbody(req_body.to_string()),
        );
        let response = self.request_call(req).await;
        ApiReq::into_writer(response, std::io::stdout().lock()).await;
    }

    /**/
    pub async fn list_containers(&self) -> JSON {
        let response = self.get_request(Containers::List.to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn list_containers_to_writer(&self, writer: impl std::io::Write) {
        let response = self.get_request(Containers::List.to_url()).await;
        let json = ApiReq::res_to_json(response).await;
        ApiReq::into_json_writer(json, writer).await;
    }

    /**/
    pub async fn list_processes(&self, id: &str) -> JSON {
        let response = self.get_request(Containers::Processes(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn create_container(&mut self, req_body: JSON) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Containers::Create.to_url(),
            ApiReq::rbody(req_body.to_string()),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn inspect_container(&self, id: &str) -> JSON {
        let response = self.get_request(Containers::Inspect(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn inspect_container_to_writer(&self, id: &str, writer: impl std::io::Write) {
        let response = self.get_request(Containers::Inspect(id).to_url()).await;
        let json = ApiReq::res_to_json(response).await;
        ApiReq::into_json_writer(json, writer).await;
    }

    /**/
    pub async fn container_logs(&self, id: &str) -> String {
        let response = self
            .get_request(Containers::Logs(id, true as u8, false as u8).to_url())
            .await;
        ApiReq::res_to_string(response).await
    }

    /**/
    pub async fn container_logs_to_writer(&self, id: &str, writer: impl std::io::Write) {
        let response = self
            .get_request(Containers::Logs(id, true as u8, false as u8).to_url())
            .await;
        ApiReq::into_writer(response, writer).await;
    }

    /**/
    pub async fn container_changes(&self, id: &str) -> JSON {
        let response = self.get_request(Containers::Changes(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn export_container(&self, id: &str) -> JSON {
        let response = self.get_request(Containers::Export(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn container_stats(&self, id: &str) -> JSON {
        let response = self.get_request(Containers::Stats(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn resize_container_tty(&mut self, id: &str, h: u32, w: u32) -> JSON {
        let req =
            ApiReq::create_request("POST", Containers::Resize(id, h, w).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }
    
    /**/
    pub async fn start_container(&mut self, container_id: &str) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Containers::Start(container_id).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        match response.status().as_u16() {
            204 => {
                json!({
                    "StatusCode": 204,
                    "Msg": "OK",
                })
            }
            304 => {
                json!({
                    "StatusCode": 304,
                    "Msg": "already started",
                })
            }
            404 => {
                json!({
                    "StatusCode": 404,
                    "Msg": "not found",
                })
            }
            500 => {
                json!({
                    "StatusCode": 500,
                    "Msg": "server error",
                })
            }
            _ => {
                json!({
                    "StatusCode": "TeaPot",
                    "Msg": "I'm a teapot",
                })
            }
        }
    }

    /**/
    pub async fn stop_container(&mut self, id: &str, s: &str, t: u32) -> JSON {
        let req =
            ApiReq::create_request("POST", Containers::Stop(id, s, t).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn restart_container(&mut self, id: &str, s: &str, t: u32) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Containers::Restart(id, s, t).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn kill_container(&mut self, id: &str, signal: &str) -> JSON {
        let req =
            ApiReq::create_request("POST", Containers::Kill(id, signal).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn update_container(&mut self, id: &str, json: JSON) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Containers::Update(id).to_url(),
            ApiReq::json_to_body(json),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn rename_container(&mut self, id: &str, name: &str) -> JSON {
        let req =
            ApiReq::create_request("POST", Containers::Rename(id, name).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn pause_container(&mut self, id: &str) -> JSON {
        let req = ApiReq::create_request("POST", Containers::Pause(id).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn unpause_container(&mut self, id: &str) -> JSON {
        let req = ApiReq::create_request("POST", Containers::Unpause(id).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn attach_to_container(
        &mut self,
        id: &str,
        logs: bool,
        stream: bool,
        stdin: bool,
        stdout: bool,
        stderr: bool,
    ) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Containers::Attach(id, logs, stream, stdin, stdout, stderr).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn wait_container(&mut self, container_id: &str) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Containers::Wait(container_id).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn wait_container_condition(
        &mut self,
        container_id: &str,
        condition: String,
    ) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Containers::WaitCondition(container_id, condition).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn remove_container(&mut self, id: &str, v: bool, f: bool, l: bool) -> JSON {
        let req = ApiReq::create_request(
            "DELETE",
            Containers::Remove(id, v, f, l).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn container_file_info(&mut self, id: &str, path: &str) -> JSON {
        let response = self
            .get_request(Containers::FileInfo(id, path).to_url())
            .await;
        ApiReq::base64_to_json(response).await
    }

    /**/
    pub async fn container_extract_archive(&mut self, id: &str, path: &str) -> JSON {
        let req = ApiReq::create_request(
            "PUT",
            Containers::Extract(id, path, "1", "0").to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::base64_to_json(response).await
    }

    /**/
    pub async fn run_container(&mut self, req_body: JSON) -> String {
        let ct = self.create_container(req_body).await;
        let s = ct["Id"]
            .as_str()
            .expect("Failed to parse JSON string")
            .to_string();
        let ct_id = String::from(&s[0..11]);
        self.wait_container(&ct_id).await;
        self.start_container(&ct_id).await;
        self.container_logs(&ct_id).await
    }

    /**/
    pub async fn run_container_to_writer(&mut self, req_body: JSON) -> JSON {
        let ct = self.create_container(req_body).await;
        let s = ct["Id"]
            .as_str()
            .expect("Failed to parse JSON string")
            .to_string();
        let ct_id = String::from(&s[0..11]);
        let rjson_wait = self.wait_container(&ct_id).await;
        let rjson_start = self.start_container(&ct_id).await;
        self.container_logs_to_writer(&ct_id, std::io::stdout().lock())
            .await;
        json!({
            "Id": ct_id,
            "ContainerID": s,
            "Response": [
                ct,
                rjson_wait,
                rjson_start,
            ]

        })
    }

    /**/
    pub async fn run_container_detached(&mut self, req_body: JSON) -> JSON {
        let ct = self.create_container(req_body).await;
        let s = ct["Id"]
            .as_str()
            .expect("Failed to parse JSON string")
            .to_string();
        let ct_id = String::from(&s[0..11]);
        let json_response = self.start_container(&ct_id).await;
        self.container_logs(&ct_id).await;
        json!({
            "Id": ct_id,
            "ContainerID": s,
            "Response": [
                ct,
                json_response,
            ]

        })
    }

    /**/
    pub async fn run_container_detached_to_writer(&mut self, req_body: JSON) -> JSON {
        let ct = self.create_container(req_body).await;
        let s = ct["Id"]
            .as_str()
            .expect("Failed to parse JSON string")
            .to_string();
        let ct_id = String::from(&s[0..11]);
        let json_response = self.start_container(&ct_id).await;
        self.container_logs_to_writer(&ct_id, std::io::stdout().lock())
            .await;
        json!({
            "Id": ct_id,
            "ContainerID": s,
            "Response": [
                ct,
                json_response,
            ]

        })
    }

    /**/
    pub async fn prune_containers(&mut self) -> JSON {
        let req = ApiReq::create_request("POST", Containers::Prune.to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn prune_containers_with_filters(&mut self, filter: &str) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Containers::PruneFilter(filter).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }
}

/* Images commands */
impl Connect {
    /**/
    pub async fn list_images(&self) -> JSON {
        let response = self.get_request(Images::List("all=false").to_url()).await;
        ApiReq::res_to_json(response).await
    }
    
    /**/
    pub async fn ls_images(&self) -> ListImages {
        let response = self.get_request(Images::List("all=false").to_url()).await;
        let msg: ListImages = ApiReq::res_to_img_list(response).await;
        msg
    }

    /**/
    pub async fn list_images_to_writer(&self, writer: impl std::io::Write) {
        let response = self.get_request(Images::List("all=false").to_url()).await;
        let json = ApiReq::res_to_json(response).await;
        ApiReq::into_json_writer(json, writer).await;
    }

    /**/
    pub async fn build_image(&mut self, auth_config: JSON) -> JSON {
        let req = ApiReq::build_request(
            "POST",
            Images::Build(&auth_config["dockerfile"].to_string()).to_url(),
            Body::empty(),
            System::base64_encode(&auth_config.to_string()),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn prune_builder_cache(&mut self, all: bool) -> JSON {
        let req = ApiReq::create_request("POST", Images::Prune(all).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn create_image(&mut self, query: String, auth_config: JSON) -> JSON {
        let req = ApiReq::create_image(
            "POST",
            Images::Create(&query).to_url(),
            Body::empty(),
            System::base64_encode(&auth_config.to_string()),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn inspect_image(&self, id: &str) -> JSON {
        let response = self.get_request(Images::Inspect(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn image_history(&self, id: &str) -> JSON {
        let response = self.get_request(Images::History(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn push_image(&mut self, id: &str, tag: &str, config: JSON) -> JSON {
        let req = ApiReq::create_image(
            "POST",
            Images::Push(id, tag).to_url(),
            Body::empty(),
            System::base64_encode(&config.to_string()),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn tag_image(&mut self, id: &str, repo: &str, tag: &str) -> JSON {
        let req =
            ApiReq::create_request("POST", Images::Tag(id, repo, tag).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn remove_image(&mut self, id: &str, force: bool, noprune: bool) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Images::Remove(id, force, noprune).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn search_images(&self, term: &str, limit: u32) -> JSON {
        let response = self
            .get_request(Images::Search(&format!("term={term}&limit={limit}")).to_url())
            .await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn prune_images(&mut self, dangling: bool) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Images::DeleteUnused(dangling).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn image_from_container(&mut self, query: String, request_body: JSON) -> JSON {
        let req = ApiReq::image_from_container(
            "POST",
            Images::FromContainer(&query).to_url(),
            ApiReq::json_to_body(request_body),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn image_export(&self, id: &str) -> JSON {
        let response = self.get_request(Images::Export(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn export_images(&self, names: String) -> JSON {
        let response = self.get_request(Images::Exports(&names).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn import_images(&mut self, quiet: bool, tar: String) -> JSON {
        // application/x-tar
        // tar: String binary
        let query = format!("quiet={quiet}");
        let req = ApiReq::image_from_container(
            "POST",
            Images::Import(&query).to_url(),
            ApiReq::rbody(tar),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }
}

/* Networks commands */
impl Connect {
    /**/
    pub async fn list_networks(&self) -> JSON {
        let response = self.get_request(Networks::List.to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn inspect_network(&self, id: &str) -> JSON {
        let response = self.get_request(Networks::Inspect(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn inspect_network_query(&self, id: &str, query: &str) -> JSON {
        let response = self
            .get_request(Networks::InspectQuery(id, query).to_url())
            .await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn remove_network(&mut self, id: &str) -> JSON {
        let req = ApiReq::create_request("DELETE", Networks::Remove(id).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn create_network(&mut self, req_body: JSON) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Networks::Create.to_url(),
            ApiReq::json_to_body(req_body),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn connect_container_to_network(&mut self, id: &str, req: JSON) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Networks::ConnectCt(id).to_url(),
            ApiReq::json_to_body(req),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn disconnect_container_from_network(&mut self, id: &str, req: JSON) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Networks::DisconnectCt(id).to_url(),
            ApiReq::json_to_body(req),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn prune_networks(&mut self) -> JSON {
        let req = ApiReq::create_request("POST", Networks::Prune.to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn prune_networks_query(&mut self, filters: &str) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Networks::PruneQuery(filters).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }
}

/* Volumes commands */
impl Connect {
    /**/
    pub async fn list_volumes(&self) -> JSON {
        let response = self.get_request(Volumes::List.to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn create_volume(&mut self, json: JSON) -> JSON {
        let req =
            ApiReq::create_request("POST", Volumes::Create.to_url(), ApiReq::json_to_body(json));
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn inspect_volume(&mut self, name: &str) -> JSON {
        let response = self.get_request(Volumes::Inspect(name).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn remove_volume(&mut self, name: &str, force: bool) -> JSON {
        let req = ApiReq::create_request(
            "DELETE",
            Volumes::Remove(name, force).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn prune_volumes(&mut self) -> JSON {
        let req = ApiReq::create_request("POST", Volumes::Prune.to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn prune_volumes_query(&mut self, filter: &str) -> JSON {
        let req =
            ApiReq::create_request("POST", Volumes::PruneQuery(filter).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }
}

/* Exec commands */
impl Connect {
    pub async fn create_exec(&mut self, id: &str, req_body: JSON) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Exec::Create(id).to_url(),
            ApiReq::json_to_body(req_body),
        );
        let response = self.request_call(req).await;
        let json = ApiReq::res_to_json(response).await;
        let ct_id = json["Id"]
            .as_str()
            .expect("Failed to parse JSON string")
            .to_string();
        json!({
            "Id": String::from(&ct_id[0..11]),
            "ContainerID": ct_id,
            "Response": json,
        })
    }

    pub async fn start_exec(&mut self, id: &str, req_body: JSON) -> JSON {
        let req = ApiReq::create_request(
            "POST",
            Exec::Start(id).to_url(),
            ApiReq::rbody(req_body.to_string()),
        );
        let response = self.request_call(req).await;
        match response.status().as_u16() {
            200 => json!({
                "StatusCode": 200,
                "Msg": "OK",
                "Id": id,
                "Request": req_body,
            }),
            404 => json!({
                "StatusCode": 404,
                "Msg": "Not found",
                "Id": id,
                "Request": req_body,
            }),
            409 => json!({
                "StatusCode": 409,
                "Msg": "Stopped or Paused",
                "Id": id,
                "Request": req_body,
            }),
            _ => json!({
                "StatusCode": "TeaPot",
                "Msg": "I'm a teapot baby",
                "Id": id,
                "Request": req_body,
            }),
        }
    }

    pub async fn resize_exec(&mut self, id: &str, height: &str, width: &str) -> JSON {
        let query = format!("height={height}&width={width}");
        let req = ApiReq::create_request("POST", Exec::Resize(id, &query).to_url(), Body::empty());
        let response = self.request_call(req).await;
        let json = ApiReq::res_to_json(response).await;
        match json["StatusCode"].as_u64() {
            Some(200) => json!({
                "StatusCode": 200,
                "Msg": "OK",
                "Id": id,
                "Response": json,
            }),
            Some(400) => json!({
                "StatusCode": 400,
                "Msg": "Bad parameter",
                "Id": id,
                "Response": json,
            }),
            Some(404) => json!({
                "StatusCode": 404,
                "Msg": "Not found",
                "Id": id,
                "Response": json,
            }),
            Some(500) => json!({
                "StatusCode": 500,
                "Msg": "Server error",
                "Id": id,
                "Response": json,
            }),
            _ => json!({
                "StatusCode": "TeaPot",
                "Msg": "I'm a teapot",
                "Id": id,
                "Response": json,
            }),
        }
    }

    pub async fn inspect_exec(&mut self, id: &str) -> JSON {
        let req = ApiReq::create_request("POST", Exec::Inspect(id).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    pub async fn inspect_exec_to_writer(&mut self, id: &str, writer: impl std::io::Write) {
        let req = ApiReq::create_request("POST", Exec::Inspect(id).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::into_writer(response, writer).await;
    }
}
