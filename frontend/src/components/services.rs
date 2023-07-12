use crate::models::image::*;
use crate::models::container::*;
// use futures::{Stream, StreamExt};
use reqwasm::http::Request;
use yew::platform::spawn_local;
use yew::{AttrValue, Callback};

pub fn get_image_list(img_cb: Callback<AttrValue>) {
    // Spawn a background task that will fetch a list of Docker images and send it to the component.
    spawn_local(async move {
        let img_list: Vec<ImageList> = Request::get("http://192.168.178.34:3969/list/images")
            .send()
            .await
            .unwrap()
            .json()
            .await
            .expect("");
        // Emit it to the component
        img_cb.emit(AttrValue::from(img_list));
    });
}
