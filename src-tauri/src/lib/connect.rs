use crate::*;
use crate::containers::*;
use crate::images::*;
use crate::volumes::*;
use crate::networks::*;
use crate::exec::*;
use crate::system::*;
use crate::format::*;
use hyper::{service::Service, Body, Client};
#[cfg(unix)]
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
    pub async fn verify(&mut self, req_body: Json) -> Json {
        let req = ApiReq::create_request(
            "POST",
            System::Auth.to_url(),
            ApiReq::rbody(req_body.to_string()),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /* Verify authentication information for the configured registry to STDOUT */
    pub async fn verify_to_writer(&mut self, req_body: Json) {
        let req = ApiReq::create_request(
            "POST",
            System::Auth.to_url(),
            ApiReq::rbody(req_body.to_string()),
        );
        let response = self.request_call(req).await;
        ApiReq::into_writer(response, std::io::stdout().lock()).await;
    }

    /* List containers */
    pub async fn list_containers(&self) -> Json {
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
    pub async fn list_processes(&self, id: &str) -> Json {
        let response = self.get_request(Containers::Processes(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn create_container(&mut self, req_body: Json) -> Json {
        let req = ApiReq::create_request(
            "POST",
            Containers::Create.to_url(),
            ApiReq::rbody(req_body.to_string()),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn create_container_with_name(&mut self, name: &str, req_body: Json) -> Json {
        let req = ApiReq::create_request(
            "POST",
            Containers::CreateWithName(name).to_url(),
            ApiReq::rbody(req_body.to_string()),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn inspect_container(&self, id: &str) -> Json {
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
    pub async fn container_changes(&self, id: &str) -> Json {
        let response = self.get_request(Containers::Changes(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn export_container(&self, id: &str) -> Json {
        let response = self.get_request(Containers::Export(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn container_stats(&self, id: &str) -> Json {
        let response = self.get_request(Containers::Stats(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn resize_container_tty(&mut self, id: &str, h: u32, w: u32) -> Json {
        let req =
            ApiReq::create_request("POST", Containers::Resize(id, h, w).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }
    
    /**/
    pub async fn start_container(&mut self, id: &str) -> Json {
        let req = ApiReq::create_request(
            "POST",
            Containers::Start(id).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        match response.status().as_u16() {
            204 => {
                json!({
                    "StatusCode": 204,
                    "Message": "OK",
                    "Action": "Start",
                    "ID": format!("{id}"),
                })
            }
            304 => {
                json!({
                    "StatusCode": 304,
                    "Message": "already started",
                })
            }
            404 => {
                json!({
                    "StatusCode": 404,
                    "Message": "not found",
                })
            }
            500 => {
                json!({
                    "StatusCode": 500,
                    "Message": "server error",
                })
            }
            _ => {
                json!({
                    "StatusCode": "TeaPot",
                    "Message": "I'm a teapot",
                })
            }
        }
    }

    /**/
    pub async fn stop_container(
      &mut self, id: &str, signal: &str, time: u32
    ) -> Json {
        let req = ApiReq::create_request(
          "POST", 
          Containers::Stop(id, signal, time).to_url(),
          Body::empty()
        );
        let response = self.request_call(req).await;
        match response.status().as_u16() {
            204 => {
                json!({
                    "StatusCode": 204,
                    "Message": "OK",
                    "Action": "Stop",
                    "ID": format!("{id}"),
                })
            }
            304 => {
                json!({
                    "StatusCode": 304,
                    "Message": "Container already stopped",
                })
            }
            404 => {
                json!({
                    "StatusCode": 404,
                    "Message": format!("No such container: {id}"),
                })
            }
            500 => {
                json!({
                    "StatusCode": 500,
                    "Message": "Internal server error",
                })
            }
            _ => {
                json!({
                    "StatusCode": "TeaPot",
                    "Message": "I'm a teapot",
                })
            }
        }
    }

    /**/
    pub async fn restart_container(
      &mut self, id: &str, signal: &str, time: u32
    ) -> Json {
        let req = ApiReq::create_request(
          "POST",
          Containers::Restart(id, signal, time).to_url(),
          Body::empty(),
        );
        let response = self.request_call(req).await;
        match response.status().as_u16() {
            204 => {
                json!({
                    "StatusCode": 204,
                    "Message": "OK",
                    "Action": "Restart",
                    "ID": format!("{id}"),
                })
            }
            404 => {
                json!({
                    "StatusCode": 404,
                    "Message": format!("No such container: {id}"),
                })
            }
            500 => {
                json!({
                    "StatusCode": 500,
                    "Message": "Internal server error",
                })
            }
            _ => {
                json!({
                    "StatusCode": "TeaPot",
                    "Message": "I'm a teapot",
                })
            }
        }
    }

    /**/
    pub async fn kill_container(&mut self, id: &str, signal: &str) -> Json {
        let req = ApiReq::create_request(
          "POST",
          Containers::Kill(id, signal).to_url(), 
          Body::empty()
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn update_container(&mut self, id: &str, json: Json) -> Json {
        let req = ApiReq::create_request(
          "POST",
          Containers::Update(id).to_url(),
          ApiReq::json_to_body(json),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn rename_container(&mut self, id: &str, name: &str) -> Json {
        let req = ApiReq::create_request(
          "POST",
          Containers::Rename(id, name).to_url(),
          Body::empty()
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn pause_container(&mut self, id: &str) -> Json {
        let req = ApiReq::create_request(
          "POST",
          Containers::Pause(id).to_url(), 
          Body::empty()
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn unpause_container(&mut self, id: &str) -> Json {
        let req = ApiReq::create_request(
          "POST", 
          Containers::Unpause(id).to_url(), 
          Body::empty()
        );
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
    ) -> Json {
        let req = ApiReq::create_request(
            "POST",
            Containers::Attach(id, logs, stream, stdin, stdout, stderr).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn wait_container(&mut self, container_id: &str) -> Json {
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
    ) -> Json {
        let req = ApiReq::create_request(
            "POST",
            Containers::WaitCondition(container_id, condition).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn remove_container(
      &mut self, id: &str, volumes: bool, force: bool, link: bool
    ) -> Json {
        let req = ApiReq::create_request(
            "DELETE",
            Containers::Remove(id, volumes, force, link).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        match response.status().as_u16() {
            204 => {
                json!({
                    "StatusCode": 204,
                    "Message": "OK",
                })
            }
            400 => {
                json!({
                    "StatusCode": 400,
                    "Message": "Something went wrong",
                })
            }
            404 => {
                json!({
                    "StatusCode": 404,
                    "Message": format!("No such container: {id}"),
                })
            }
            409 => {
                json!({
                    "StatusCode": 409,
                    "Message": format!("You cannot remove a running container: {id}"),
                })
            }
            500 => {
                json!({
                    "StatusCode": 500,
                    "Message": "Something went wrong"
                })
            }
            _ => {
                json!({
                    "StatusCode": "TeaPot",
                    "Message": "I'm a teapot",
                })
            }
        }
    }

    /**/
    pub async fn container_file_info(&mut self, id: &str, path: &str) -> Json {
        let response = self
            .get_request(Containers::FileInfo(id, path).to_url())
            .await;
        ApiReq::base64_to_json(response).await
    }

    /**/
    pub async fn container_extract_archive(&mut self, id: &str, path: &str) -> Json {
        let req = ApiReq::create_request(
            "PUT",
            Containers::Extract(id, path, "1", "0").to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::base64_to_json(response).await
    }

    /**/
    pub async fn run_container(&mut self, ct: Json) -> String {
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
    pub async fn create_run_container(&mut self, req_body: Json) -> String {
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
    pub async fn run_container_to_writer(&mut self, ct: Json) -> Json {
        let s = ct["Id"]
            .as_str()
            .expect("Failed to parse JSON string")
            .to_string();
        let ct_id = String::from(&s[0..11]);
        let rjson_wait = self.wait_container(&ct_id).await;
        let rjson_start = self.start_container(&ct_id).await;
        let mut data = Vec::new();
        self.container_logs_to_writer(&ct_id, &mut data).await;
        let string_output = String::from_utf8(data).unwrap();
        json!({
            "Id": ct_id,
            "ContainerID": s,
            "Response": [
                ct,
                rjson_wait,
                rjson_start,
            ],
            "Output": string_output

        })
    }

    /**/
    pub async fn create_run_container_to_writer(&mut self, req_body: Json) -> Json {
        let ct = self.create_container(req_body).await;
        let s = ct["Id"]
            .as_str()
            .expect("Failed to parse JSON string")
            .to_string();
        let ct_id = String::from(&s[0..11]);
        let rjson_wait = self.wait_container(&ct_id).await;
        let rjson_start = self.start_container(&ct_id).await;
        let mut data = Vec::new();
        self.container_logs_to_writer(&ct_id, &mut data).await;
        let string_output = String::from_utf8(data).unwrap();
        json!({
            "Id": ct_id,
            "ContainerID": s,
            "Response": [
                ct,
                rjson_wait,
                rjson_start,
            ],
            "Output": string_output

        })
    }

    /**/
    pub async fn run_container_detached(&mut self, ct: Json) -> Json {
        let s = ct["Id"].as_str()
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
    pub async fn create_run_container_detached(
      &mut self, req_body: Json
    ) -> Json {
        let ct = self.create_container(req_body).await;
        let s = ct["Id"].as_str()
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
    pub async fn run_container_detached_to_writer(
      &mut self, ct: Json
    ) -> Json {
        let s = ct["Id"]
            .as_str()
            .expect("Failed to parse JSON string")
            .to_string();
        let ct_id = String::from(&s[0..11]);
        let json_response = self.start_container(&ct_id).await;
        let mut data = Vec::new();
        self.container_logs_to_writer(&ct_id, &mut data).await;
        let string_output = String::from_utf8(data).unwrap();
        json!({
            "Id": ct_id,
            "ContainerID": s,
            "Response": [
                ct,
                json_response,
            ],
            "Output": string_output

        })
    }

    /**/
    pub async fn create_run_container_detached_to_writer(
      &mut self, req_body: Json
    ) -> Json {
        let ct = self.create_container(req_body).await;
        let s = ct["Id"]
            .as_str()
            .expect("Failed to parse JSON string")
            .to_string();
        let ct_id = String::from(&s[0..11]);
        let json_response = self.start_container(&ct_id).await;
        let mut data = Vec::new();
        self.container_logs_to_writer(&ct_id, &mut data).await;
        let string_output = String::from_utf8(data).unwrap();
        json!({
            "Id": ct_id,
            "ContainerID": s,
            "Response": [
                ct,
                json_response,
            ],
            "Output": string_output

        })
    }

    /**/
    pub async fn run_container_detached_to_stdout(
      &mut self, ct: Json
    ) -> Json {
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
    pub async fn create_run_container_detached_to_stdout(
      &mut self, req_body: Json
    ) -> Json {
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
    pub async fn prune_containers(&mut self) -> Json {
        let req = ApiReq::create_request("POST", Containers::Prune.to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn prune_containers_with_filters(&mut self, filter: &str) -> Json {
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
    pub async fn list_images(&self) -> Json {
        let response = self.get_request(Images::List("all=false").to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn list_images_to_writer(&self, writer: impl std::io::Write) {
        let response = self.get_request(Images::List("all=false").to_url()).await;
        let json = ApiReq::res_to_json(response).await;
        ApiReq::into_json_writer(json, writer).await;
    }

    /**/
    pub async fn build_image(&mut self, auth_config: Json) -> Json {
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
    pub async fn prune_builder_cache(&mut self, all: bool) -> Json {
        let req = ApiReq::create_request(
          "POST", 
          Images::Prune(all).to_url(), 
          Body::empty()
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn create_image(
      &mut self, query: String
    ) -> String {
        let req = ApiReq::create_image(
            "POST",
            Images::Create(&query).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_string(response).await
    }

    /**/
    pub async fn create_image_with_auth(
      &mut self, query: String, auth_config: Json
    ) -> Json {
        let req = ApiReq::create_image_with_auth(
            "POST",
            Images::Create(&query).to_url(),
            Body::empty(),
            System::base64_encode(&auth_config.to_string()),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn inspect_image(&self, id: &str) -> Json {
        let response = self.get_request(Images::Inspect(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn image_history(&self, id: &str) -> Json {
        let response = self.get_request(Images::History(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn push_image(
      &mut self, id: &str, tag: &str, config: Json
    ) -> Json {
        let req = ApiReq::create_image_with_auth(
          "POST",
          Images::Push(id, tag).to_url(),
          Body::empty(),
          System::base64_encode(&config.to_string()),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn tag_image(
      &mut self, id: &str, repo: &str, tag: &str
    ) -> Json {
        let req = ApiReq::create_request(
          "POST", 
          Images::Tag(id, repo, tag).to_url(), 
          Body::empty()
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn remove_image(
      &mut self, id: &str, force: bool, noprune: bool
    ) -> Json {
        let req = ApiReq::create_request(
            "DELETE",
            Images::Remove(id, force, noprune).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn search_images(&self, term: &str, limit: u32) -> Json {
        let response = self.get_request(
          Images::Search(&format!("term={term}&limit={limit}")).to_url()
        ).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn prune_images(&mut self, dangling: bool) -> Json {
        let req = ApiReq::create_request(
            "POST",
            Images::DeleteUnused(dangling).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn image_from_container(&mut self, query: String, request_body: Json) -> Json {
        let req = ApiReq::image_from_container(
            "POST",
            Images::FromContainer(&query).to_url(),
            ApiReq::json_to_body(request_body),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn image_export(&self, id: &str) -> Json {
        let response = self.get_request(Images::Export(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn export_images(&self, names: String) -> Json {
        let response = self.get_request(Images::Exports(&names).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn import_images(&mut self, quiet: bool, tar: String) -> Json {
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
    pub async fn list_networks(&self) -> Json {
        let response = self.get_request(Networks::List.to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn inspect_network(&self, id: &str) -> Json {
        let response = self.get_request(Networks::Inspect(id).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn inspect_network_query(&self, id: &str, query: &str) -> Json {
        let response = self
            .get_request(Networks::InspectQuery(id, query).to_url())
            .await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn remove_network(&mut self, id: &str) -> Json {
        let req = ApiReq::create_request(
          "DELETE", 
          Networks::Remove(id).to_url(), 
          Body::empty()
        );
        let response = self.request_call(req).await;
        match response.status().as_u16() {
            204 => {
                json!({
                    "StatusCode": 204,
                    "Message": "OK",
                })
            }
            403 => {
                json!({
                    "StatusCode": 403,
                    "Message": "Operation not permitted for pre-defined networks",
                })
            }
            404 => {
                json!({
                    "StatusCode": 404,
                    "Message": format!("No such network: {id}"),
                })
            }
            500 => {
                json!({
                    "StatusCode": 500,
                    "Message": "Server error"
                })
            }
            _ => {
                json!({
                    "StatusCode": "TeaPot",
                    "Message": "I'm a teapot",
                })
            }
        }
    }

    /**/
    pub async fn create_network(&mut self, req_body: Json) -> Json {
        let req = ApiReq::create_request(
            "POST",
            Networks::Create.to_url(),
            ApiReq::json_to_body(req_body),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn connect_container_to_network(&mut self, id: &str, req: Json) -> Json {
        let req = ApiReq::create_request(
            "POST",
            Networks::ConnectCt(id).to_url(),
            ApiReq::json_to_body(req),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn disconnect_container_from_network(&mut self, id: &str, req: Json) -> Json {
        let req = ApiReq::create_request(
            "POST",
            Networks::DisconnectCt(id).to_url(),
            ApiReq::json_to_body(req),
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn prune_networks(&mut self) -> Json {
        let req = ApiReq::create_request("POST", Networks::Prune.to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn prune_networks_query(&mut self, filters: &str) -> Json {
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
    pub async fn list_volumes(&self) -> Json {
        let response = self.get_request(Volumes::List.to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn create_volume(&mut self, json: Json) -> Json {
        let req = ApiReq::create_request(
          "POST", 
          Volumes::Create.to_url(), 
          ApiReq::json_to_body(json)
        );
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn inspect_volume(&mut self, name: &str) -> Json {
        let response = self.get_request(Volumes::Inspect(name).to_url()).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn remove_volume(&mut self, name: &str, force: bool) -> Json {
        let req = ApiReq::create_request(
            "DELETE",
            Volumes::Remove(name, force).to_url(),
            Body::empty(),
        );
        let response = self.request_call(req).await;
        match response.status().as_u16() {
            204 => {
                json!({
                    "StatusCode": 204,
                    "Message": "OK: Volume was removed",
                    "Name": format!("{name}"),
                })
            }
            404 => {
                json!({
                    "StatusCode": 404,
                    "Message": "No such volume/driver",
                    "Name": format!("{name}"),
                })
            }
            409 => {
                json!({
                    "StatusCode": 409,
                    "Message": "Volume is in use and cannot be removed",
                    "Name": format!("{name}"),
                })
            }
            500 => {
                json!({
                    "StatusCode": 500,
                    "Message": "Server error"
                })
            }
            _ => {
                json!({
                    "StatusCode": "TeaPot",
                    "Message": "I'm a teapot",
                })
            }
        }
    }

    /**/
    pub async fn prune_volumes(&mut self) -> Json {
        let req = ApiReq::create_request("POST", Volumes::Prune.to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    /**/
    pub async fn prune_volumes_query(&mut self, filter: &str) -> Json {
        let req =
            ApiReq::create_request("POST", Volumes::PruneQuery(filter).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }
}

/* Exec commands */
impl Connect {
    pub async fn create_exec(&mut self, id: &str, req_body: Json) -> Json {
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

    pub async fn start_exec(
        &mut self, 
        id: &str, 
        req_body: Json
    ) -> Json {
        let req = ApiReq::create_request(
            "POST",
            Exec::Start(id).to_url(),
            ApiReq::rbody(req_body.to_string()),
        );
        let response = self.request_call(req).await;
        match response.status().as_u16() {
            200 => json!({
                "StatusCode": 200,
                "Message": "OK",
                "Id": id,
                "Request": req_body,
            }),
            404 => json!({
                "StatusCode": 404,
                "Message": "Not found",
                "Id": id,
                "Request": req_body,
            }),
            409 => json!({
                "StatusCode": 409,
                "Message": "Stopped or Paused",
                "Id": id,
                "Request": req_body,
            }),
            _ => json!({
                "StatusCode": "TeaPot",
                "Message": "I'm a teapot baby",
                "Id": id,
                "Request": req_body,
            }),
        }
    }

    pub async fn resize_exec(
        &mut self, 
        id: &str, 
        height: &str, 
        width: &str
    ) -> Json {
        let query = format!("height={height}&width={width}");
        let req = ApiReq::create_request("POST", Exec::Resize(id, &query).to_url(), Body::empty());
        let response = self.request_call(req).await;
        let json = ApiReq::res_to_json(response).await;
        match json["StatusCode"].as_u64() {
            Some(200) => json!({
                "StatusCode": 200,
                "Message": "OK",
                "Id": id,
                "Response": json,
            }),
            Some(400) => json!({
                "StatusCode": 400,
                "Message": "Bad parameter",
                "Id": id,
                "Response": json,
            }),
            Some(404) => json!({
                "StatusCode": 404,
                "Message": "Not found",
                "Id": id,
                "Response": json,
            }),
            Some(500) => json!({
                "StatusCode": 500,
                "Message": "Server error",
                "Id": id,
                "Response": json,
            }),
            _ => json!({
                "StatusCode": "TeaPot",
                "Message": "I'm a teapot",
                "Id": id,
                "Response": json,
            }),
        }
    }

    pub async fn inspect_exec(
        &mut self, 
        id: &str
    ) -> Json {
        let req = ApiReq::create_request("POST", Exec::Inspect(id).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::res_to_json(response).await
    }

    pub async fn inspect_exec_to_writer(
        &mut self, 
        id: &str, 
        writer: impl std::io::Write
    ) {
        let req = ApiReq::create_request("POST", Exec::Inspect(id).to_url(), Body::empty());
        let response = self.request_call(req).await;
        ApiReq::into_writer(response, writer).await;
    }
}


/* Sytstem commands */
impl Connect {
    pub async fn system_info(
        &self
    ) -> Json {
        let response = self.get_request(System::Info.to_url()).await;
        ApiReq::res_to_json(response).await
    }
}
