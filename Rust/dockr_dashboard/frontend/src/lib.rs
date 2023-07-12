pub mod app;
pub mod router;
pub mod pages;
pub mod components;
use pages::*;
use router::*;
use components::*;
// use wasm_bindgen::prelude::*;
// use wasm_bindgen_futures::JsFuture;
// use web_sys::{Request, RequestInit, RequestMode, Response};
// use yew::{function_component, html, Html, Properties, Callback, Children};

/*
#[wasm_bindgen]
pub async fn start() -> Result<JsValue, JsValue> {
    let mut opts = RequestInit::new();
    opts.method("GET");
    opts.mode(RequestMode::Cors);

    let url = format!("http://localhost:3969/list/images");

    let request = Request::new_with_str_and_init(&url, &opts)?;

    request
        .headers()
        .set("Accept", "application/json")?;

    let window = web_sys::window().unwrap();
    let resp_value = JsFuture::from(window.fetch_with_request(&request)).await?;

    // `resp_value` is a `Response` object.
    assert!(resp_value.is_instance_of::<Response>());
    let resp: Response = resp_value.dyn_into().unwrap();

    // Convert this other `Promise` into a rust `Future`.
    let json = JsFuture::from(resp.json()?).await?;

    // Send the JSON response back to JS.
    Ok(json)
}
*/

/*
#[wasm_bindgen]
pub fn run_app() {
    yew::Renderer::<App>::new().render();
} 
fn main() {
    yew::Renderer::<App>::new().render();
}
 */

#[cfg(test)]
mod tests {
    // use super::*;
}
