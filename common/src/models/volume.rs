use crate::*;
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize, Clone, PartialEq)]
#[serde(rename_all = "PascalCase")]
pub struct Volume {
    pub created_at: String,
    pub driver: String,
    pub labels: Option<Json>,
    pub mountpoint: String,
    pub name: String,
    pub options: Option<Json>,
    pub scope: String,
}

#[derive(Debug, Deserialize, Serialize, Clone, PartialEq)]
#[serde(rename_all = "PascalCase")]
pub struct VolumeList {
    volumes: Vec<Volume>,
}

