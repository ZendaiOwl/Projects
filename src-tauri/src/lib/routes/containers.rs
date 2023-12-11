use crate::*;
use crate::routes::format::FormatApi;

pub enum Containers<'a> {
    List,
    Create,
    CreateWithName(&'a str),
    Wait(&'a str),
    WaitCondition(&'a str, String),
    Start(&'a str),
    Remove(&'a str, bool, bool, bool),
    Logs(&'a str, u8, u8),
    Inspect(&'a str),
    Processes(&'a str),
    Changes(&'a str),
    Export(&'a str),
    Stats(&'a str),
    Resize(&'a str, u32, u32),
    Stop(&'a str, &'a str, u32),
    Restart(&'a str, &'a str, u32),
    Kill(&'a str, &'a str),
    Update(&'a str),
    Rename(&'a str, &'a str),
    Pause(&'a str),
    Unpause(&'a str),
    Attach(&'a str, bool, bool, bool, bool, bool),
    WebSocket(&'a str, u8, u8, u8, u8, u8),
    FileInfo(&'a str, &'a str), // Returns X-Docker-Container-Path-Stat header
    Archive(&'a str, &'a str),
    Extract(&'a str, &'a str, &'a str, &'a str),
    Prune,
    PruneFilter(&'a str),
}

impl Containers<'_> {
    pub fn to_url(&self) -> URL {
        match self {
            Self::List => FormatApi::Containers("json").query("all=true"),
            Self::Create => FormatApi::Containers("create").to_url(),
            Self::CreateWithName(container_name) => FormatApi::Containers("create").query(&format!("name={container_name}")),
            Self::Wait(id) => FormatApi::Containers(id).add("wait"),
            Self::WaitCondition(id, condition) => {
                FormatApi::Containers(id).path_query("wait", condition)
            }
            Self::Start(id) => FormatApi::Containers(id).add("start"),
            Self::Remove(id, v, f, l) => {
                FormatApi::Containers(id).query(&format!("v={v}&force={f}&link={l}"))
            }
            Self::Logs(id, o, e) => {
                FormatApi::Containers(id).add(&format!("logs?stdout={o}&stderr={e}"))
            }
            Self::Inspect(id) => FormatApi::Containers(id).add("json"),
            Self::Processes(id) => FormatApi::Containers(id).add("top"),
            Self::Changes(id) => FormatApi::Containers(id).add("changes"),
            Self::Export(id) => FormatApi::Containers(id).add("export"),
            Self::Stats(id) => FormatApi::Containers(id).add("stats?stream=false"),
            Self::Resize(id, h, w) => FormatApi::Containers(id).add(&format!("resize?h={h}&w={w}")),
            Self::Stop(id, s, t) => {
                FormatApi::Containers(id).add(&format!("stop?signal={s}&t={t}"))
            }
            Self::Restart(id, s, t) => {
                FormatApi::Containers(id).add(&format!("restart?signal={s}&t={t}"))
            }
            Self::Kill(id, s) => FormatApi::Containers(id).add(&format!("kill?signal={s}")),
            Self::Update(id) => FormatApi::Containers(id).add("update"),
            Self::Rename(id, n) => FormatApi::Containers(id).add(&format!("rename?name={n}")),
            Self::Pause(id) => FormatApi::Containers(id).add("pause"),
            Self::Unpause(id) => FormatApi::Containers(id).add("unpause"),
            Self::Attach(id, l, s, i, o, e) => FormatApi::Containers(id).add(&format!(
                "attach?logs={l}&stream={s}&stdin={i}&stdout={o}&stderr={e}"
            )),
            Self::WebSocket(id, l, s, i, o, e) => FormatApi::Containers(id).add(&format!(
                "ws?logs={l}&stream={s}&stdin={i}&stdout={o}&stderr={e}"
            )),
            Self::FileInfo(id, p) => FormatApi::Containers(id).add(&format!("archive?path={p}")),
            Self::Archive(id, p) => FormatApi::Containers(id).add(&format!("archive?path={p}")),
            Self::Extract(id, p, n, c) => FormatApi::Containers(id).add(&format!(
                "archive?path={p}&noOverwriteDirNonDir={n}&copyUIDGID={c}"
            )),
            Self::Prune => FormatApi::Containers("prune").to_url(),
            Self::PruneFilter(f) => FormatApi::Containers("prune").query(&format!("filters={f}")),
        }
    }
}
