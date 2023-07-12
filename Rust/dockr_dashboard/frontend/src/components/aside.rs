use yew::prelude::*;
use yew_router::prelude::*;

use crate::router::Route;

#[function_component]
pub fn Aside() -> Html {
    html! {
        <aside class="aside is-placed-left is-expanded">
            <div class="aside-tools">
            <div class="aside-tools-label">
                <span>{"Admin"}</span>
            </div>
            </div>
            <div class="menu is-menu-main">
            <p class="menu-label">{"General"}</p>
            <ul class="menu-list">
                <li>
                <a href="index.html" class="is-active router-link-active">
                    <span class="menu-item-label">{"Dashboard"}</span>
                </a>
                </li>
            </ul>
            <p class="menu-label">{"Examples"}</p>
            <ul class="menu-list">
                <li>
                <a href="tables.html">
                    <span class="menu-item-label">{"Tables"}</span>
                </a>
                </li>
                <li>
                <a href="forms.html">
                    <span class="menu-item-label">{"Forms"}</span>
                </a>
                </li>
                <li>
                <a href="profile.html">
                    <span class="menu-item-label">{"Profile"}</span>
                </a>
                </li>
                <li>
                <a>
                    <span class="menu-item-label">{"Submenus"}</span>
                </a>
                <ul class="is-hidden">
                    <li>
                    <a href="#void">
                        <span>{"Sub-item One"}</span>
                    </a>
                    </li>
                    <li>
                    <a href="#void">
                        <span>{"Sub-item Two"}</span>
                    </a>
                    </li>
                </ul>
                </li>
            </ul>
            <p class="menu-label">{"About"}</p>
            <ul class="menu-list">
                <li>
                <a href="https://github.com/ZendaiOwl"
                    target="_blank">
                    <span class="menu-item-label">{"GitHub"}</span>
                </a>
                </li>
                <li>
                <a href="#void">
                    <span class="menu-item-label">{"About"}</span>
                </a>
                </li>
            </ul>
            </div>
        </aside>
    }
}
