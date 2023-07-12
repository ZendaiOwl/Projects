# Notes

Works without auth for public repo's

`https://auth.docker.io/token`

With basic auth 

`https://<username>:<password>@auth.docker.io/token?service=registry.docker.io&scope=repository:<repo>:pull`

Get one-time access token for Docker Hub API
`curl -s -X POST \
-H "Content-Type: application/json" \
-d '{"username": "'"$USR"'", "password": "docker hub access-token"}' \
https://hub.docker.com/v2/users/login/ | jq -r '.token'`

Get list of repos for that user account
`curl -s -H "Authorization: JWT ${TOKEN}" \
https://hub.docker.com/v2/repositories/$USR/?page_size=10000 \
| jq -r '.results|.[]|.name'`

`curl --unix-socket /var/run/docker.sock \
-H "Content-Type: application/json" \
http://localhost/v1.42/images/json | jq '.'`


### CORS

Headers syntax

```
Access-Control-Allow-Origin: <allowed_origin> | *
Access-Control-Allow-Methods: <method> | [<method>]
Access-Control-Allow-Headers: <header> | [<header>]
Access-Control-Max-Age: <delta-seconds>
```

```
use yew::prelude::*;

#[function_component]
fn App() -> Html {
    let counter = use_state(|| 0);
    let onclick = {
        let counter = counter.clone();
        move |_| {
            let value = *counter + 1;
            counter.set(value);
        }
    };

    html! {
        <div>
            <button {onclick}>{ "+1" }</button>
            <p>{ *counter }</p>
        </div>
    }
}

fn main() {
    yew::Renderer::<App>::new().render();
}
```

```
use yew::prelude::*;

pub type Anchor = RouterAnchor<AppRoute>;

struct FullStackApp {}

pub enum Msg {}

#[derive(Switch, Clone, Debug)]
pub enum AppRoute {
    #[to = "/app/list"]
    CreateOwner,
    #[to = "/app/create-pet/{id}"]
    CreatePet(i32),
    #[to = "/app/{id}"]
    Detail(i32),
    #[to = "/"]
    Home,
}
```


