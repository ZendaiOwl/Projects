use crate::*;
use crate::routing::format::FormatApi;

pub enum Volumes<'a> {
    List,
    Create,
    Inspect(&'a str),
    UpdateSwarmVolume(&'a str, &'a str),
    Remove(&'a str, bool),
    Prune,
    PruneQuery(&'a str),
}

impl Volumes<'_> {
    pub fn to_url(&self) -> URL {
        match self {
            Self::List => FormatApi::Volumes("").make(),
            Self::Create => FormatApi::Volumes("create").to_url(),
            Self::Inspect(id) => FormatApi::Volumes(id).to_url(),
            Self::UpdateSwarmVolume(id, version) => FormatApi::Volumes(id).query(version),
            Self::Remove(id, force) => FormatApi::Volumes(id).query(&force.to_string()),
            Self::Prune => FormatApi::Volumes("prune").to_url(),
            Self::PruneQuery(query) => FormatApi::Volumes("prune").query(query),
        }
    }
}
