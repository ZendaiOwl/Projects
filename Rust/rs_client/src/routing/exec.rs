use crate::*;
use crate::routing::format::FormatApi;

pub enum Exec<'a> {
    Create(&'a str),
    Start(&'a str),
    Resize(&'a str, &'a str),
    Inspect(&'a str),
}

impl Exec<'_> {
    pub fn to_url(&self) -> URL {
        match self {
            Self::Create(id) => FormatApi::Containers(id).add("exec"),
            Self::Start(id) => FormatApi::Exec(id).add("start"),
            Self::Resize(id, query) => FormatApi::Exec(id).path_query("resize", query),
            Self::Inspect(id) => FormatApi::Exec(id).add("json"),
        }
    }
}
