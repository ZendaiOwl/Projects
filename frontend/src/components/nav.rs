use yew::prelude::*;
use yew_router::prelude::*;

use crate::router::Route;

#[function_component]
pub fn Nav() -> Html {
    let navbar_active = use_state_eq(|| false);

    let toggle_navbar = {
        let navbar_active = navbar_active.clone();

        Callback::from(move |_| {
            navbar_active.set(!*navbar_active);
        })
    };

    let active_class = if !*navbar_active { "is-active" } else { "" };

    html! {
        <nav id="navbar-main" class="navbar is-fixed-top" role="navigation" aria-label="main navigation">
            <div class="navbar-brand">
                <a class="navbar-item is-hidden-desktop jb-aside-mobile-toggle">
                    <span class="icon"><i class="mdi mdi-forwardburger mdi-24px"></i></span>
                </a>
            </div>
            <div class="navbar-brand is-right">
                <a class="navbar-item is-hidden-desktop jb-navbar-menu-toggle" data-target="navbar-menu">
                    <span class="icon"><i class="mdi mdi-dots-vertical"></i></span>
                </a>
            </div>
                <div class="navbar-item has-control">
                    <div class="control"><input placeholder="Search everywhere..." class="input"/></div>
                </div>
            <button class={classes!("navbar-burger", "burger", active_class)}
                aria-label="menu" aria-expanded="false"
                onclick={toggle_navbar}>
                <span aria-hidden="true"></span>
                <span aria-hidden="true"></span>
                <span aria-hidden="true"></span>
            </button>
            <div class={classes!("navbar-menu", "fadeIn", "animated", "faster", active_class)}>
                <div class="navbar-start">
                    <Link<Route> classes={classes!("navbar-item")} to={Route::Home}>
                        { "Home" }
                    </Link<Route>>

                    <div class="navbar-item has-dropdown is-hoverable">
                        <div class="navbar-link">
                            { "More" }
                        </div>
                        <div class="navbar-dropdown">
                            <hr class="navbar-divider"/>
                            <Link<Route> classes={classes!("navbar-item")} to={Route::Home}>
                                { "Something else" }
                            </Link<Route>>
                        </div>
                    </div>
                </div>
            </div>
        </nav>
    }
}
