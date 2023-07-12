use std::collections::HashMap;
use yew::prelude::*;
use yew_router::prelude::*;
use yew_router::history::{AnyHistory, History, MemoryHistory};
use crate::home::Home;
use crate::nav::Nav;

#[derive(Clone, Routable, PartialEq)]
pub enum Route {
    #[at("/")]
    Home,
    #[not_found]
    #[at("/404")]
    NotFound,
}

#[derive(Properties, PartialEq, Eq, Debug)]
pub struct ServerAppProps {
    pub url: AttrValue,
    pub queries: HashMap<String, String>,
}

#[function_component]
pub fn ServerApp(props: &ServerAppProps) -> Html {
    let history = AnyHistory::from(MemoryHistory::new());
    history
        .push_with_query(&*props.url, &props.queries)
        .unwrap();

    html! {
        <Router history={history}>
        <main>
            <Switch<Route> render={switch} />
        </main>
        </Router>
    }
}

pub fn switch(routes: Route) -> Html {
    match routes {
        Route::Home => html! {
            <Home/>
        },
        Route::NotFound => html! {
            <div class="container">
                <p>{"404"}</p>
            </div>
        },
    }
}

#[cfg(test)]
mod tests {
    // use super::*;
}
