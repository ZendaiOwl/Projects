#!/usr/bin/env node
const req = "http://localhost:3969/list/images";
const ul = document.querySelector('section');
const txt = document.createElement('p');

function fetch_request_json(request) {
    fetch(request)
        .then((res) => {
            return res.json();
        }).then((data) => {
            show_json(data);
        }).catch((err) => {
            console.log(err);
        });
}
function show_json(json) {
    console.log(JSON.stringify(json));
}
function fetch_images() {
    fetch(req)
        .then((response) => {
            return response.json();
        }).then((data) => {
            show_images(data);
        }).catch((error) => {
            console.log(error);
        });
}
function show_images(images) {
    for (var i = 0; i < images.length; i++) {
        txt.innerHTML += "Containers: " + images[i]["Containers"] + "<br>";
        txt.innerHTML += "Created: " + images[i]["Created"] + "<br>";
        txt.innerHTML += "Id: " + images[i]["Id"] + "<br>";
        txt.innerHTML += "Labels: " + images[i]["Labels"] + "<br>";
        txt.innerHTML += "ParentId: " + images[i]["ParentId"] + "<br>";
        txt.innerHTML += "RepoDigests: " + images[i]["RepoDigests"] + "<br>";
        txt.innerHTML += "RepoTags: " + images[i]["RepoTags"] + "<br>";
        txt.innerHTML += "SharedSize: " + images[i]["SharedSize"] + "<br>";
        txt.innerHTML += "Size: " + images[i]["Size"] + "<br>";
        txt.innerHTML += "VirtualSize: " + images[i]["VirtualSize"] + "<br>";
        txt.innerHTML += "<br>";
        ul.appendChild(txt);
    }
};

