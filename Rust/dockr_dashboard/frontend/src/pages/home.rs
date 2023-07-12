// use common::types::Json;
// use serde_json::json;
// use serde_json::Value;
// use common::models::image::ImageList;
// use yew::prelude::*;
// use reqwasm::http::{Request};
// use web_sys::console;
// use wasm_bindgen_futures::spawn_local;
// use web_sys::{RequestInit, RequestMode, Response};
use yew::{html, Component, Context, Html};

// async fn fetch_image_list() -> Vec<ImageList> {
//     Request::get("http://localhost:3969/list/images")
//         .send()
//         .await
//         .unwrap()
//         .json()
//         .await
//         .expect("Unable to fetch image list")
// }

pub struct Home;

impl Component for Home {
    type Message = ();
    type Properties = ();

    fn create(_ctx: &Context<Self>) -> Self {
        Self
    }

    fn view(&self, _ctx: &Context<Self>) -> Html {
        // let mut images = use_state(|| vec![]);
        // spawn_local(async {
        //     let image_list: Vec<ImageList> = fetch_image_list().await;
        //     images.set(image_list);
        // });
        html! {
            <div class="tile is-ancestor is-vertical">
                <div class="tile is-child hero">
                    <div class="hero-body container pb-0">
                        <h1 class="title is-1">{ "Welcome..." }</h1>
                        <h2 class="subtitle">{ "...to something being built" }</h2>
                    </div>
                </div>
            
                <div class="tile is-parent container">
                    <button class="button" onClick={"fetch_images();"}>{"Button"}</button>
                </div>
                <div class="tile is-parent container">
                    { self.view_info_tiles() }
                </div>
                <div class="tile is-parent container">
                    { self.view_containers() }
                </div>
                <div class="tile is-parent container">
                    { self.view_images() }
                </div>
            </div>
        }
    }
    
    fn update(&mut self, _ctx: &Context<Self>, _msg: Self::Message) -> bool {
        true
    }
}

impl Home {
    fn view_containers(&self) -> Html {
        html! {
            <>
                <div class="tile is-parent">
                    <div class="tile is-child box">
                        <p class="title">{ "Docker Stuffz in progress" }</p>
                        <p class="subtitle">{ "List of Docker containers" }</p>
                        <div class="content" name="content_containers_list">
                            <div class="section" name="output_containers"></div>
                        </div>
                    </div>
                </div>
            </>
        }
    }
    
    fn view_images(&self) -> Html {
        html! {
            <>
                <div class="tile is-parent">
                    <div class="tile is-child is-clipped box">
                        <p class="title">{ "Docker Stuffz in progress" }</p>
                        <p class="subtitle">{ "List of Docker images" }</p>
                        <button class="button"
                                onClick="fetch_images()">{"List images"}</button>
                        <div class="container" name="content_images_list">
                            <div class="section" name="output_images"></div>
                        </div>
                        <script>{r#"
                            function fetch_images() {
                                fetch("http://localhost:3969/list/images")
                                    .then((response) => {
                                        return response.json();
                                    }).then((data) => {
                                        console.log(JSON.stringify(data));
                                        show_images(data);
                                    }).catch((error) => {
                                        console.log(error);
                                    });
                            }
                            function stringifi(j) {
                                return JSON.stringify(j);
                            }
                            function show_images(images) {
                                let o = document.getElementsByName('output_images');
                                let txt = document.createElement('p');
                                for (var i = 0; i < images.length; i++) {
                                    txt.innerHTML += 'Containers: ' + images[i]['Containers'] + '<br>';
                                    txt.innerHTML += 'Created: ' + images[i]['Created'] + '<br>';
                                    txt.innerHTML += 'Id: ' + images[i]['Id'] + '<br>';
                                    txt.innerHTML += 'Labels: ' + stringifi(images[i]['Labels']) + '<br>';
                                    txt.innerHTML += 'ParentId: ' + images[i]['ParentId'] + '<br>';
                                    txt.innerHTML += 'RepoDigests: ' + stringifi(images[i]['RepoDigests']) + '<br>';
                                    txt.innerHTML += 'RepoTags: ' + stringifi(images[i]['RepoTags']) + '<br>';
                                    txt.innerHTML += 'SharedSize: ' + images[i]['SharedSize'] + '<br>';
                                    txt.innerHTML += 'Size: ' + images[i]['Size'] + '<br>';
                                    txt.innerHTML += 'VirtualSize: ' + images[i]['VirtualSize'] + '<br>';
                                    txt.innerHTML += '<br>';
                                    o[0].appendChild(txt);
                                }
                            };"#}</script>
                    </div>
                </div>
            </>
        }
    }
    
    fn view_info_tiles(&self) -> Html {
        html! {
            <>
                <div class="tile is-parent">
                    <div class="tile is-child box">
                        <p class="title">{ "Docker Stuffz in progress" }</p>
                        <p class="subtitle">{ "Whoopedi-doooh!" }</p>
                        <div class="content">
                            {r#"
                                Tralalalala
                            "#}
                        </div>
                    </div>
                </div>
                
                <div class="tile is-parent">
                    <div class="tile is-child box">
                        <p class="title">{ "Who are we?" }</p>

                        <div class="content">
                            { "I'm a teapot!" }
                            <br />
                            { "A sophisticated teapot." }
                            <br />
                            {r#"
                                Hue hue hue 
                            "#}
                        </div>
                    </div>
                </div>
            </>
        }
    }
}
