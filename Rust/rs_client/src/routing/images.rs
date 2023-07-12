use crate::*;
use crate::routing::format::FormatApi;

pub enum Images<'a> {
    List(&'a str),
    Build(&'a str),
    Prune(bool),
    Create(&'a str),
    Inspect(&'a str),
    History(&'a str),
    Push(&'a str, &'a str),
    Tag(&'a str, &'a str, &'a str),
    Remove(&'a str, bool, bool),
    Search(&'a str),
    DeleteUnused(bool),
    FromContainer(&'a str),
    Export(&'a str),
    Exports(&'a str),
    Import(&'a str),
}

impl Images<'_> {
    pub fn to_url(&self) -> URL {
        match self {
            Self::List(q) => FormatApi::Images("json").query(q),
            Self::Build(d) => FormatApi::Uri("/build").query(&format!("dockerfile={d}")),
            Self::Prune(a) => FormatApi::Build("prune").query(&format!("all={a}")),
            Self::Create(q) => FormatApi::Images("create").query(q),
            Self::Inspect(i) => FormatApi::Images(i).add("json"),
            Self::History(i) => FormatApi::Images(i).add("history"),
            Self::Push(i, t) => FormatApi::Images(i).add(&format!("push?tag={t}")),
            Self::Tag(i, r, t) => FormatApi::Images(i).add(&format!("tag?repo={r}&tag={t}")),
            Self::Remove(i, f, n) => FormatApi::Images(i).query(&format!("force={f}&noprune={n}")),
            Self::Search(q) => FormatApi::Images("search").query(q),
            Self::DeleteUnused(d) => FormatApi::Images("prune").query(&format!("dangling={d}")),
            Self::FromContainer(q) => FormatApi::Images("commit").query(q),
            Self::Export(n) => FormatApi::Images(n).add("get"),
            Self::Exports(q) => FormatApi::Images("get").query(q),
            Self::Import(q) => FormatApi::Images("load").query(q),
        }
    }
}
