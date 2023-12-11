use crate::*;
use serde_json::json;
use crate::format::FormatApi;
use crate::system::System;

pub struct ApiReq<'a> {
    method: &'a str,
    url: &'a str,
    req_body: Json,
}

impl ApiReq<'_> {
    pub fn new<'a>(m: &'a str, u: &'a str, r: Json) -> ApiReq<'a> {
        ApiReq {
            method: m,
            url: u,
            req_body: r,
        }
    }

    pub fn get_method(&self) -> &str {
        self.method
    }

    pub fn string_body(&self) -> String {
        self.req_body.to_string()
    }

    pub fn json_body(&self) -> Json {
        serde_json::from_str(&self.req_body.to_string())
            .expect("Failed to parse JSON from req_body")
    }

    pub fn get_body(&self) -> ReqBody {
        Body::from(self.req_body.to_string())
    }

    pub fn get_url(&self) -> URL {
        FormatApi::Uri(self.url).to_url()
    }

    pub fn request(&self) -> Req {
        Request::builder()
            .method(self.method)
            .uri(self.get_url())
            .header("Content-Type", "application/json")
            .body(self.get_body())
            .expect("Failed to create request")
    }

    pub fn create_request(
      method: &str, url: URL, req_body: ReqBody
    ) -> Req {
        Request::builder()
            .method(method)
            .uri(url)
            .header("Content-Type", "application/json")
            .body(req_body)
            .expect("Failed to create request")
    }

    pub fn create_respone(
      content: &str, status: u16, body: ReqBody
    ) -> Resp {
        Response::builder()
            .header("Content-Type", content.to_string())
            .status(status)
            .body(body)
            .expect("Failed to create response")
    }

    pub fn create_request_with_header(
        header: [&str; 2],
        method: &str,
        url: URL,
        req_body: ReqBody,
    ) -> Req {
        Request::builder()
            .method(method)
            .uri(url)
            .header(header[0], header[1])
            .body(req_body)
            .expect("Failed to create request")
    }

    pub fn create_image(
      method: &str, url: URL, req_body: ReqBody
    ) -> Req {
        Request::builder()
            .method(method)
            .uri(url)
            .header("Content-Type", "application/json")
            .body(req_body)
            .expect("Failed to create request")
    }

    pub fn create_image_with_auth(
      method: &str, url: URL, req_body: ReqBody, base64_json: String
    ) -> Req {
        Request::builder()
            .method(method)
            .uri(url)
            .header("X-Registry-Auth", base64_json)
            .body(req_body)
            .expect("Failed to create request")
    }

    pub fn image_from_container(
      method: &str, url: URL, req_body: ReqBody
    ) -> Req {
        Request::builder()
            .method(method)
            .uri(url)
            .header("Content-Type", "application/json")
            .body(req_body)
            .expect("Failed to create request")
    }

    pub fn build_request(
      method: &str, url: URL, req_body: ReqBody, base64_json: String
    ) -> Req {
        Request::builder()
            .method(method)
            .uri(url)
            .header("Content-Type", "application/x-tar")
            .header("X-Registry-Config", base64_json)
            .body(req_body)
            .expect("Failed to create request")
    }

    pub fn json_to_response(
      jsbody: Json, code: StatusCode
    ) -> Resp {
        let body = Self::json_to_body(jsbody);
        let res = match Response::builder()
            .header("Content-Type", "application/json")
            .status(code)
            .body(body) {
                Ok(r) => r,
                Err(_) => {
                    Self::json_to_response(json!({
                        "msg": "error creating response",
                    }), hyper::StatusCode::from_u16(300).unwrap())
                },
        };
        res
    }

    pub fn json_to_body(
      jsbody: Json
    ) -> ReqBody {
        Body::from(jsbody.to_string())
    }

    pub fn rbody(
      r: String
    ) -> ReqBody {
        Body::from(r)
    }
    
    pub async fn res_to_string(
      mut r: Resp
    ) -> String {
        let mut response_data = Vec::new();
        while let Some(next) = r.data().await {
            let chunk = next.expect("Unable to parse response data");
            response_data.extend_from_slice(&chunk);
        }
        String::from_utf8(response_data).expect("Failed to parse String from slice")
    }

    pub async fn res_to_json(
      mut r: Resp
    ) -> Json {
        let mut response_data = Vec::new();
        while let Some(next) = r.data().await {
            let chunk = next.expect("Unable to parse response data");
            response_data.extend_from_slice(&chunk);
        }
        serde_json::from_slice(&response_data).expect("Failed to parse JSON from slice")
    }

    pub async fn base64_to_json(
      r: Resp
    ) -> Json {
        let header = r
            .headers()
            .get("X-Docker-Container-Path-Stat")
            .expect("No such header");
        let b64 = System::base64_decode_header(header);
        serde_json::from_slice(&b64).expect("Failed to parse JSON from slice")
    }

    pub async fn into_writer(
      mut r: Resp, mut writer: impl std::io::Write
    ) {
        while let Some(next) = r.data().await {
            let chunk = next.expect("Unable to parse response data");
            writer
                .write_all(&chunk)
                .expect("Failed writing response data");
        }
    }

    pub async fn into_json_writer(
      json: Json, writer: impl std::io::Write
    ) {
        serde_json::to_writer_pretty(writer, &json).expect("Failed to parse JSON to io::Writer");
        println!();
    }
}
