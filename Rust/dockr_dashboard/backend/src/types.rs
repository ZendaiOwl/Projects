use hyper::{Body};
pub type URL = hyper::Uri;
pub type Req = hyper::Request<Body>;
pub type ReqBody = hyper::body::Body;
pub type Resp = hyper::Response<Body>;
