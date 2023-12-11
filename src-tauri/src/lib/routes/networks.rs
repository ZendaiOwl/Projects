use crate::*;
use crate::routes::format::FormatApi;

pub enum Networks<'a> {
    List,
    Inspect(&'a str),
    InspectQuery(&'a str, &'a str),
    Remove(&'a str),
    Create,
    ConnectCt(&'a str),
    DisconnectCt(&'a str),
    Prune,
    PruneQuery(&'a str),
}

impl Networks<'_> {
    pub fn to_url(&self) -> URL {
        match self {
            Self::List => FormatApi::Networks("").to_one(),
            Self::Inspect(id) => FormatApi::Networks(id).to_url(),
            Self::InspectQuery(id, query) => FormatApi::Networks(id).query(query),
            Self::Remove(id) => FormatApi::Networks(id).to_url(),
            Self::Create => FormatApi::Networks("create").to_url(),
            Self::ConnectCt(id) => FormatApi::Networks(id).add("connect"),
            Self::DisconnectCt(id) => FormatApi::Networks(id).add("disconnect"),
            Self::Prune => FormatApi::Networks("prune").to_url(),
            Self::PruneQuery(query) => FormatApi::Networks("prune").query(query),
        }
    }
}
