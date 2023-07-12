use crate::*;
use crate::routing::format::FormatApi;
use base64::{engine::general_purpose, Engine as _};

#[allow(dead_code)]
pub enum System {
    Auth,
    Info,
    Version,
    Ping,
    Events,
    DataUsage,
}

impl System {
    pub fn to_url(&self) -> URL {
        match self {
            Self::Auth => FormatApi::Uri("/auth").to_url(),
            Self::Info => FormatApi::Uri("/info").to_url(),
            Self::Version => FormatApi::Uri("/version").to_url(),
            Self::Ping => FormatApi::Uri("/_ping").to_url(),
            Self::Events => FormatApi::Uri("/events").to_url(),
            Self::DataUsage => FormatApi::Uri("/system").add("df"),
        }
    }
    
    pub fn base64_encode(s: &str) -> String {
        general_purpose::URL_SAFE_NO_PAD.encode(s)
    }

    pub fn base64_encode_vec(s: &Vec<u8>) -> String {
        general_purpose::URL_SAFE_NO_PAD.encode(s)
    }

    pub fn base64_decode(s: &str) -> Vec<u8> {
        general_purpose::URL_SAFE_NO_PAD
            .decode(s)
            .expect("Failed to decode base64")
    }

    pub fn base64_decode_header(s: &hyper::header::HeaderValue) -> Vec<u8> {
        general_purpose::URL_SAFE_NO_PAD
            .decode(s)
            .expect("Failed to decode base64")
    }
}
