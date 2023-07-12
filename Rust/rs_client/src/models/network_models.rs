use crate::*;
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize, Clone, PartialEq)]
#[serde(rename_all = "PascalCase")]
pub struct Network {
    pub attachable: bool,
    pub config_from: Option<JSON>,
    pub config_only: bool,
    pub containers: Option<JSON>,
    pub created: String,
    pub driver: String,
    #[serde(alias = "EnableIPv6")]
    pub enable_ipv6: bool,
    #[serde(alias = "IPAM")]
    pub ipam: Option<JSON>,
    pub id: String,
    pub ingress: bool,
    pub internal: bool,
    pub labels: Option<JSON>,
    pub name: String,
    pub options: Option<JSON>,
    pub scope: String,
}

#[derive(Debug, Deserialize, Serialize, Clone, PartialEq)]
#[serde(rename_all = "PascalCase")]
pub struct NetworkList {
    networks: Vec<Network>,
}
