use crate::*;
use yew::Properties;
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize, Clone, PartialEq, Properties)]
#[serde(rename_all = "PascalCase")]
pub struct ImageList {
    pub containers: i64,
    pub created: i64,
    pub id: String,
    pub labels: Option<Json>, // Fails to parse when the value is null ..
    pub parent_id: String,
    pub repo_digests: Option<Vec<String>>,
    pub repo_tags: Option<Vec<String>>,
    pub shared_size: i64,
    pub size: i64,
    pub virtual_size: i64,
}

impl ImageList {
    pub fn get_labels(&self) -> Json {
        match &self.labels {
            Some(json) => {
                json.clone()
            },
            None => {
                serde_json::Value::Null
            },
        }
    }
    
    pub fn get_repo_digests(&self) -> String {
        match &self.repo_digests {
            Some(vec) => {
                let mut new = String::new();
                for s in vec {
                    new += &format!("{}\n", s);
                }
                new
            },
            None => {
                String::from("")
            },
        }
    }

    pub fn get_repo_tags(&self) -> String {
        match &self.repo_tags {
            Some(vec) => {
                let mut new = String::new();
                for s in vec {
                    new += &s;
                }
                new
            },
            None => {
                String::from("")
            },
        }
    }

    pub fn get_html(&self) -> Html {
        html! {
            <>
                <div class="box">
                    <p key={"Containers"}>{format!("Containers: {}", self.containers)}</p>
                    <p key={"created"}>{format!("Created: {}", self.created)}</p>
                    <p key={"id"}>{format!("Id: {}", self.id)}</p>
                    <p key={"labels"}>{format!("Labels: {}", self.get_labels())}</p>
                    <p key={"parent_id"}>{format!("ParentId: {}", self.parent_id)}</p>
                    <p key={"repo_digests"}>{format!("RepoDigests: {}", self.get_repo_digests())}</p>
                    <p key={"repo_tags"}>{format!("RepoTags: {}", self.get_repo_tags())}</p>
                    <p key={"shared_size"}>{format!("SharedSize: {}", self.shared_size)}</p>
                    <p key={"size"}>{format!("Size: {}", self.size)}</p>
                    <p key={"virtual_size"}>{format!("VirtualSize: {}", self.virtual_size)}</p>
                </div>
            </>
        }
    }
}

impl fmt::Display for ImageList {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{}\n{}\n{}\n{}\n{}\n{}\n{}\n{}\n{}\n{}\n",
            self.containers,
            self.created,
            self.id,
            self.get_labels(),
            self.parent_id,
            self.get_repo_digests(),
            self.get_repo_tags(),
            self.shared_size,
            self.size,
            self.virtual_size,
        )
    }
}

#[derive(Debug, Deserialize, Serialize, Clone, PartialEq)]
#[serde(rename_all = "PascalCase")]
pub struct ImageInspect {
    pub id: String,
    pub repo_tags: Option<Vec<String>>,
    pub repo_digests: Option<Vec<String>>,
    pub parent: String,
    pub comment: String,
    pub created: String,
    pub container: String,
    pub container_config: Option<Json>, // TODO Create struct
    pub docker_version: String,
    pub author: String,
    pub config: Option<Json>, // TODO Create struct
    pub architecture: String,
    pub variant: String,
    pub os: String,
    pub os_version: String,
    pub size: i64,
    pub virtual_size: i64,
    pub graph_driver: Option<Json>, // TODO Create struct
    pub root_fs: Option<Json>, // TODO Create struct
    pub metadata: Option<Json>, // TODO Create struct
}


#[derive(Debug, Deserialize, Serialize, Clone, PartialEq)]
#[serde(rename_all = "PascalCase")]
pub struct ImageHistory {
    pub id: String,
    pub created: i64,
    pub created_by: String,
    pub tags: Option<Vec<String>>,
    pub size: i64,
    pub comment: String,
}

impl ImageHistory {
    pub fn get_tags(&self) -> String {
        match &self.tags {
            Some(vec) => {
                let mut new = String::new();
                for s in vec {
                    new += &s;
                }
                new
            },
            None => {
                String::from("")
            },
        }
    }

    pub fn get_html(&self) -> Html {
        html! {
            <>
                <div class="box">
                    <p key={"id"}>{format!("ID: {}", self.id)}</p>
                    <p key={"created"}>{format!("Created: {}", self.created)}</p>
                    <p key={"created_by"}>{format!("Created by: {}", self.created_by)}</p>
                    <p key={"tags"}>{format!("Tags: {}", self.get_tags())}</p>
                    <p key={"size"}>{format!("Size: {}", self.size)}</p>
                    <p key={"comment"}>{format!("Comment: {}", self.comment)}</p>
                </div>
            </>
        }
    }
}
