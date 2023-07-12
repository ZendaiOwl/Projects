use yew::prelude::*;
use yew_router::prelude::*;
use crate::*;
use crate::nav::Nav;
use crate::aside::Aside;
use crate::Route;

#[global_allocator]
static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;

pub enum Msg {}

struct FullStackApp {}

impl Component for FullStackApp {
    type Message = Msg;
    type Properties = ();
    fn create(_ctx: &Context<Self>) -> Self {
        Self {}
    }

    fn update(&mut self, _ctx: &Context<Self>, _msg: Self::Message) -> bool {
        true
    }

    fn changed(&mut self, _ctx: &Context<Self>, _props: &Self::Properties) -> bool {
        true
    }

    fn view(&self, _ctx: &Context<Self>) -> Html {
        html! {
            <BrowserRouter>
                <div class={classes!("app")}>
                <Nav />
                <div class="columns">
                <div class="column is-one-fifth is-narrow" style="position: fixed; max-width: 12em;">
                <div class="container" style="padding-left: 0.5em;">
                <Aside />
                </div>
                </div>
                <div class="column">
                    <Switch<Route> render={switch} />
                </div>
                </div>
                </div>
                <footer class="footer">
                    <div class="content has-text-centered">
                        { "Powered by " }
                        <a href="https://yew.rs">{ "Yew" }</a>
                        { " using " }
                        <a href="https://bulma.io">{ "Bulma" }</a>
                    </div>
                    <div class="content has-text-centered">
                        { "Made by " }
                        <a href="https://github.com/ZendaiOwl">{ "ZendaiOwl" }</a>
                    </div>
                </footer>
            </BrowserRouter>
        }
    }
}

#[function_component(App)]
pub fn app() -> Html {
    html! {
        <FullStackApp/>
    // <BrowserRouter>
    //     <Nav />
    // 
    //     <main>
    //         <Switch<Route> render={switch} />
    //     </main>
    //     <footer class="footer">
    //         <div class="content has-text-centered">
    //             { "Powered by " }
    //             <a href="https://yew.rs">{ "Yew" }</a>
    //             { " using " }
    //             <a href="https://bulma.io">{ "Bulma" }</a>
    //             { " and images from " }
    //             <a href="https://unsplash.com">{ "Unsplash" }</a>
    //         </div>
    //         <div class="content has-text-centered">
    //             { "Made by " }
    //             <a href="https://github.com/ZendaiOwl">{ "ZendaiOwl" }</a>
    //         </div>
    //     </footer>
    // </BrowserRouter>
    }
}


// #[function_component(App)]
// pub fn app() -> Html {
//     // let containers = use_state(|| vec![]);
//     // {
//     //     let containers = containers.clone();
//     //     use_effect_with_deps(move |_| {
//     //         let containers = containers.clone();
//     //         wasm_bindgen_futures::spawn_local(async move {
//     //            let fetched_containers: Vec<ContainerList> = Request::get("http://localhost:3969/list/containers")
//     //                 .send()
//     //                 .await
//     //                 .unwrap()
//     //                 .json()
//     //                 .await
//     //                 .unwrap();
//     //             containers.set(fetched_containers);
//     //         });
//     //         || ()
//     //     }, ());
//     // }
//     // let images = use_state(|| vec![]);
//     // {
//     //     let images = images.clone();
//     //     use_effect_with_deps(move |_| {
//     //         let images = images.clone();
//     //         wasm_bindgen_futures::spawn_local(async move {
//     //            let fetched_images: Vec<ImageList> = Request::get("http://localhost:3969/list/images")
//     //                 .send()
//     //                 .await
//     //                 .unwrap()
//     //                 .json()
//     //                 .await
//     //                 .unwrap();
//     //             images.set(fetched_images);
//     //         });
//     //         || ()
//     //     }, ());
//     // }
//     // html! {
//     //     <>
//     //         <h1 class="title has-text-centered">{"Docker Stuffz"}</h1>
//     //         <div>
//     //             <h3 class="subtitle has-text-centered">{"Docker Containers"}</h3>
//     //             <ContainersList containers={(*containers).clone()} />
//     //             <h3 class="subtitle has-text-centered">{"Docker Images"}</h3>
//     //             <ImagesList images={(*images).clone()} />
//     //         </div>
//     //     </>
//     // }
//     html! {
//         <BrowserRouter>
//             <Nav />
// 
//             <main>
//                 <Switch<Route> render={switch} />
//             </main>
//             <footer class="footer">
//                 <div class="content has-text-centered">
//                     { "Powered by " }
//                     <a href="https://yew.rs">{ "Yew" }</a>
//                     { " using " }
//                     <a href="https://bulma.io">{ "Bulma" }</a>
//                     { " and images from " }
//                     <a href="https://unsplash.com">{ "Unsplash" }</a>
//                 </div>
//             </footer>
//         </BrowserRouter>
//     }
// }

#[cfg(test)]
mod tests {
    // use super::*;
}
