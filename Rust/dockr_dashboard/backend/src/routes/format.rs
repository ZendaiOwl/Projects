use crate::*;
use hyperlocal::Uri;

const DEFAULT_VERSION: &str = "v1.42";
const DEFAULT_SOCKET: &str = "/var/run/docker.sock";
const CT: &str = "/containers";
const IMG: &str = "/images";
const NET: &str = "/networks";
const VOL: &str = "/volumes";
const BUILD: &str = "/build";
const EXEC: &str = "/exec";

enum Api<'a> {
    Url(&'a str),
}

impl Api<'_> {
    pub fn make(&self) -> URL {
        match self {
            Self::Url(x) => Self::url_from_string(Self::base_path(x)),
        }
    }
    
    pub fn add(&self, s: &str) -> URL {
        match self {
            Self::Url(x) => Self::url_from_string(Self::base_path_string(Self::combine(x, s))),
        }
    }

    pub fn as_one(&self, s: &str) -> URL {
        match self {
            Self::Url(x) => Self::url_from_string(Self::base_path_string(Self::to_one(x, s))),
        }
    }

    pub fn query(&self, q: &str) -> URL {
        match self {
            Self::Url(x) => Self::url_from_string(Self::base_path_string(Self::to_query(x, q))),
        }
    }

    fn url_from_string(path: String) -> URL {
        Uri::new(DEFAULT_SOCKET, &path).into()
    }

    fn base_path(append_path: &str) -> String {
        format!("/{DEFAULT_VERSION}{append_path}")
    }

    fn base_path_string(append_path: String) -> String {
        format!("/{DEFAULT_VERSION}{append_path}")
    }

    fn combine(one: &str, two: &str) -> String {
        format!("{one}/{two}")
    }

    fn to_one(one: &str, two: &str) -> String {
        format!("{one}{two}")
    }

    fn to_query(one: &str, two: &str) -> String {
        format!("{one}?{two}")
    }
}

pub enum FormatApi<'a> {
    Uri(&'a str),
    Containers(&'a str),
    Images(&'a str),
    Networks(&'a str),
    Volumes(&'a str),
    Build(&'a str),
    Exec(&'a str),
}

impl FormatApi<'_> {
    pub fn make(&self) -> URL {
        match self {
            Self::Uri(s) => Api::Url(s).make(),
            Self::Containers(_) => Api::Url(CT).make(),
            Self::Images(_) => Api::Url(IMG).make(),
            Self::Networks(_) => Api::Url(NET).make(),
            Self::Volumes(_) => Api::Url(VOL).make(),
            Self::Build(_) => Api::Url(BUILD).make(),
            Self::Exec(_) => Api::Url(EXEC).make(),
        }
    }

    pub fn to_url(&self) -> URL {
        match self {
            Self::Uri(s) => Api::Url(s).make(),
            Self::Containers(x) => Api::Url(CT).add(x),
            Self::Images(x) => Api::Url(IMG).add(x),
            Self::Networks(x) => Api::Url(NET).add(x),
            Self::Volumes(x) => Api::Url(VOL).add(x),
            Self::Build(x) => Api::Url(BUILD).add(x),
            Self::Exec(x) => Api::Url(EXEC).add(x),
        }
    }

    pub fn to_one(&self) -> URL {
        match self {
            Self::Uri(s) => Api::Url(s).make(),
            Self::Containers(x) => Api::Url(CT).as_one(x),
            Self::Images(x) => Api::Url(IMG).as_one(x),
            Self::Networks(x) => Api::Url(NET).as_one(x),
            Self::Volumes(x) => Api::Url(VOL).as_one(x),
            Self::Build(x) => Api::Url(BUILD).as_one(x),
            Self::Exec(x) => Api::Url(EXEC).as_one(x),
        }
    }

    pub fn add(&self, p: &str) -> URL {
        match self {
            Self::Uri(s) => Api::Url(s).add(p),
            Self::Containers(x) => Api::Url(CT).add(&Api::combine(x, p)),
            Self::Images(x) => Api::Url(IMG).add(&Api::combine(x, p)),
            Self::Networks(x) => Api::Url(NET).add(&Api::combine(x, p)),
            Self::Volumes(x) => Api::Url(NET).add(&Api::combine(x, p)),
            Self::Build(x) => Api::Url(BUILD).add(&Api::combine(x, p)),
            Self::Exec(x) => Api::Url(EXEC).add(&Api::combine(x, p)),
        }
    }

    pub fn path_query(&self, p: &str, q: &str) -> URL {
        match self {
            Self::Uri(s) => Api::Url(s).add(&Api::to_query(p, q)),
            Self::Containers(x) => Api::Url(CT).add(&Api::to_query(&Api::combine(x, p), q)),
            Self::Images(x) => Api::Url(IMG).add(&Api::to_query(&Api::combine(x, p), q)),
            Self::Networks(x) => Api::Url(NET).add(&Api::to_query(&Api::combine(x, p), q)),
            Self::Volumes(x) => Api::Url(VOL).add(&Api::to_query(&Api::combine(x, p), q)),
            Self::Build(x) => Api::Url(BUILD).add(&Api::to_query(&Api::combine(x, p), q)),
            Self::Exec(x) => Api::Url(EXEC).add(&Api::to_query(&Api::combine(x, p), q)),
        }
    }

    pub fn query(&self, q: &str) -> URL {
        match self {
            Self::Uri(s) => Api::Url(s).query(q),
            Self::Containers(x) => Api::Url(CT).add(&Api::to_query(x, q)),
            Self::Images(x) => Api::Url(IMG).add(&Api::to_query(x, q)),
            Self::Networks(x) => Api::Url(NET).add(&Api::to_query(x, q)),
            Self::Volumes(x) => Api::Url(VOL).add(&Api::to_query(x, q)),
            Self::Build(x) => Api::Url(BUILD).add(&Api::to_query(x, q)),
            Self::Exec(x) => Api::Url(EXEC).add(&Api::to_query(x, q)),
        }
    }
}
