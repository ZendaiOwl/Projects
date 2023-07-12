use crate::*;
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize, Clone, PartialEq)]
#[serde(rename_all = "PascalCase")]
pub struct ContainerList {
    pub command: String,
    pub created: i64,
    pub host_config: Option<JSON>,
    pub id: String,
    pub image: String,
    #[serde(alias = "ImageID")]
    pub image_id: String,
    pub labels: Option<JSON>,
    pub mounts: Option<Vec<String>>,
    pub names: Option<Vec<String>>,
    pub network_settings: Option<JSON>,
    pub ports: Option<Vec<String>>,
    pub state: String,
    pub status: String,
}

impl ContainerList {
    pub fn get_host_config(&self) -> JSON {
        match &self.host_config {
            Some(json) => {
                json.clone()
            },
            None => {
                serde_json::Value::Null
            },
        }
    }
    
    pub fn get_labels(&self) -> JSON {
        match &self.labels {
            Some(json) => {
                json.clone()
            },
            None => {
                serde_json::Value::Null
            },
        }
    }

    pub fn get_mounts(&self) -> String {
        match &self.mounts {
            Some(v) => {
                let mut new = String::new();
                for s in v {
                    new += &format!("{}\n", s);
                }
                new
            },
            None => {
                String::from("[]")
            },
        }
    }

    pub fn get_names(&self) -> String {
        match &self.names {
            Some(v) => {
                let mut new = String::new();
                for s in v {
                    new += &format!("{}\n", s);
                }
                new
            },
            None => {
                String::from("[]")
            },
        }
    }

    pub fn get_network_settings(&self) -> JSON {
        match &self.network_settings {
            Some(json) => {
                json.clone()
            },
            None => {
                serde_json::Value::Null
            },
        }
    }

    pub fn get_ports(&self) -> String {
        match &self.ports {
            Some(v) => {
                let mut new = String::new();
                for s in v {
                    new += &format!("{}\n", s);
                }
                new
            },
            None => {
                String::from("[]")
            },
        }
    }

    // pub fn get_html(&self) -> Html {
    //     html! {
    //         <>
    //             <div class="box">
    //                 <p key={"Command"}>{format!("Command: {}", self.command)}</p>
    //                 <p key={"Created"}>{format!("Created: {}", self.created)}</p>
    //                 <p key={"HostConfig"}>{format!("HostConfig: {}", self.get_host_config())}</p>
    //                 <p key={"Id"}>{format!("Id: {}", self.id)}</p>
    //                 <p key={"Image"}>{format!("Image: {}", self.image)}</p>
    //                 <p key={"ImageID"}>{format!("ImageID: {}", self.image_id)}</p>
    //                 <p key={"Labels"}>{format!("Labels: {}", self.get_labels())}</p>
    //                 <p key={"Mounts"}>{format!("Mounts: {}", self.get_mounts())}</p>
    //                 <p key={"Names"}>{format!("Names: {}", self.get_names())}</p>
    //                 <p key={"NetworkSettings"}>{format!("NetworkSettings: {}", self.get_network_settings())}</p>
    //                 <p key={"Ports"}>{format!("Ports: {}", self.get_ports())}</p>
    //                 <p key={"State"}>{format!("State: {}", self.state)}</p>
    //                 <p key={"Status"}>{format!("Status: {}", self.status)}</p>
    //             </div>
    //         </>
    //     }
    // }
}
