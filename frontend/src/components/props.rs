use common::models::image::ImageList;
use yew::prelude::*;
use yew_router::prelude::*;
use yew::{props, function_component, html, Html, Properties};
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize, Clone)]
#[derive(Properties, PartialEq)]
pub struct ImageListProps {
    pub images: Vec<ImageList>,
}

#[function_component(ListImages)]
fn list_images(props: &ImageListProps) -> Html {
    html! {
        <div class="box">{ props.images.clone() }</div>
    }
}
