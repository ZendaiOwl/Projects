// use crate::*;
use yew::prelude::*;

pub struct Content {}

impl Component for Content {
    type Message = ();
    type Properties = ();

    fn create(_ctx: &Context<Self>) -> Self {
        Content {}
    }

    fn update(&mut self, _ctx: &Context<Self>, _: Self::Properties) -> bool {
        false
    }

    fn changed(&mut self, _ctx: &Context<Self>, _: &Self::Properties) -> bool {
        false
    }

    fn view(&self, _ctx: &Context<Self>) -> Html {
        html! {
            <main class="container">
                <div class="starter-template">
                    <h1>{"Bootstrap starter template"}</h1>
                    <p class="lead">
                        {"Use this document as a way to quickly start any new project."}
                        <br/>
                        {"All you get is this text and a mostly barebones HTML document."}
                    </p>
                </div>
            </main>
        }
    }
}
