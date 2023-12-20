<script>
    import { invoke } from "@tauri-apps/api/tauri";
    import { onMount } from "svelte";
    import { writable } from 'svelte/store';
    import { strip_name,
            Unix_timestamp,
            print_ports,
            extract_system_time,
            format_bytes,
            strip_container_name,
            strip_container_tag,
            uppercase_first_letter
            } from './functions.svelte';
    import RefreshIcon from '$lib/assets/refresh.svg';
    import TrashIcon   from '$lib/assets/trash.svg';
    import PlayIcon    from '$lib/assets/player-play-filled.svg';
    import StopIcon    from '$lib/assets/square-filled.svg';
    
    let regex = new RegExp('/?[a-zA-Z0-9][a-zA-Z0-9_.-]+$');
    let resultValidation = null;
    
    let invalid = false;
    
    let images_list = "";
    let network_list = "";
    
    let container_port_value;
    let host_port_value;
    let image;
    let network;
    let privileged;
    let container_name;
    let dialog;
    let dialog_data;
    
    let ct = [];
    
    function doCheck() {
        resultValidation = regex.test(container_name);
        if (resultValidation == false && container_name != '') {
            invalid = true;
        } else {
            invalid = false;
        };
    }
    
    async function update_networks_list() {
        await invoke('fetch_networks').then((result) => {
            network_list = result.networks;
        }).catch((error) => {
            dialog_data = error;
            dialog.showModal();
        });
    };
    
    async function update_containers_list() {
        await invoke('fetch_containers').then((result) => {
            ct = result.containers;
        }).catch((error) => {
            dialog_data = error;
            dialog.showModal();
        });
    };
    
    async function update_image_list() {
        await invoke("fetch_images").then((result) => {
            images_list = result.images;
        }).catch((error) => {
            dialog_data = error;
            dialog.showModal();
        });
    };
    
    onMount(async function () {
        document.getElementById("host_port_input").addEventListener("invalid",
            function(event) {
                event.preventDefault();
        });
        document.getElementById("container_port_input").addEventListener("invalid",
            function(event) {
                event.preventDefault();
        });
        document.getElementById("image_select").addEventListener("invalid",
            function(event) {
                event.preventDefault();
        });
        
        dialog = document.getElementById('a_dialog');
        
        try {
            update_containers_list();
            update_image_list();
            update_networks_list();
        } catch (error) {
            dialog_data = error;
            dialog.showModal();
        };
    });
    
    async function container_remove(ID, FORCE, VOLUME, LINK) {
        await invoke('container_remove', {
            id: ID.Id, force: FORCE, volume: VOLUME, l: LINK
        }).then((result) => {
            update_containers_list();
        }).catch((error) => {
            dialog_data = error;
            dialog.showModal();
        });
    };
    
    async function start_container(ID) {
        await invoke('container_start', {
            id: ID.Id
        }).then((result) => {
            update_containers_list();
        }).catch((error) => {
            dialog_data = error;
            dialog.showModal();
        });
    };
    
    async function stop_container(ID) {
        await invoke('container_stop', {
            id: ID.Id, time: 15
        }).then((result) => {
            update_containers_list();
        }).catch((error) => {
            dialog_data = error;
            dialog.showModal();
        });
    };
    
    async function restart_container(ID) {
        await invoke('container_restart', {
            id: ID.Id, time: 15
        }).then((result) => {
            update_containers_list();
        }).catch((error) => {
            dialog_data = error;
            dialog.showModal();
        });
    };
    
    function reset_variables() {
        container_port_value = null;
        host_port_value = null;
        image = "";
    };
    
    async function handle_creation(event) {
        let obj = {};
        const formData = new FormData(event.target);
        const data = Object.fromEntries(formData.entries());
        let port_binding_host = host_port_value + "/tcp";
        
        if (data.Name != "") {
            let res = doCheck(data.Name);
            if (res == false) {
                invalid = true;
            };
        };
        
        if (host_port_value != undefined) {
            obj.HostPort = host_port_value;
        } else {
            obj.HostPort = "none";
        };
        
        if (container_port_value != undefined) {
            obj.ContainerPort = container_port_value;
        } else {
            obj.ContainerPort = "none";
        };
        
        if (data.User != "") {
            obj.User = data.User;
        } else {
            obj.User = "none"
        };
        
        if (data.Hostname != "") {
            obj.Hostname = data.Hostname;
        } else {
            obj.Hostname = "none";
        };
        
        if (data.Domainname != "") {
            obj.Domainname = data.Domainname;
        } else {
            obj.Domainname = "none";
        };
        
        if (data.Entrypoint != "") {
            obj.Entrypoint = data.Entrypoint.split(' ');
        } else {
            obj.Entrypoint = "none";
        };
        
        if (data.Cmd != "") {
            obj.Cmd = data.Cmd.split(' ');
        } else {
            obj.Cmd = "none";
        };
        
        if (data.Env != "") {
            obj.Env = data.Env.split(',');
        } else {
            obj.Env = "none";
        };

        obj.AttachStdin = false;
        obj.AttachStdout = true;
        obj.AttachStderr = true;
        obj.Tty = false;
        obj.OpenStdin = false;
        obj.StdinOnce = false;
            
        obj.Image = image;
        
        //obj.Labels = {};
        obj.Volumes = {
            "/volumes/data": {}
        };
        
        obj.NetworkDisabled = false;
        
        obj.HostConfig = {};
        
        if (data.Network != "") {
            obj.HostConfig.NetworkMode = network;
        } else {
            obj.HostConfig.NetworkMode = "none";
        };
        
        obj.HostConfig.PublishAllPorts = false;
        
        if (data.Privileged == "on") {
            obj.HostConfig.Privileged = true;
        } else {
            obj.HostConfig.Privileged = false;
        };
        
        if (invalid == false) {
            await invoke('container_create', {
                i: image, name: data.Name, 
                data: obj
            }).then((resp) => {
                update_containers_list();
                console.log(resp);
            }).catch((error) => {
                dialog_data = error;
                dialog.showModal();
            });
        };
    };
</script>

<style>
    input:invalid {
        background-color: ivory;
        border: none;
        outline: 1px solid red;
        border-radius: 5px;
    }
    select:invalid {
        background-color: ivory;
        border: none;
        outline: 1px solid red;
        border-radius: 5px;
    }
    td {
        vertical-align: middle;
    }
</style>

<dialog id="a_dialog">
    <div class="container content">
        <p>{dialog_data}</p>
            <form method="dialog" align="center">
                <button align="center">OK</button>
            </form>
    </div>
</dialog>

<div class="container box block ml-6 mr-6">

    <p class="subtitle" align="center">Create container</p>
    <form method="POST" on:submit|preventDefault={handle_creation}>
    
    <div class="field is-horizontal">
        <div class="field-body">
        
        <div class="field">
            <label class="label">Image
            <div class="control is-expanded">
                <div class="select">
                <select name="Image" bind:value={image} id="image_select" required>
                    <option value="">Select image</option>
                    {#each images_list as { RepoTags } }
                        <option>{strip_name(RepoTags)}</option>
                    {/each}
                </select>
                </div>
            </div>
            </label>
            {#if image == ""}
                <p class="help is-danger">Required</p>
            {/if}
        </div>
        
        <div class="field">
            <label class="label">Network
            <div class="control is-expanded">
                <div class="select">
                <select name="Network" bind:value={network} id="network_select">
                    <option value="">Select network</option>
                    {#each network_list as { Name } }
                    <option>{Name}</option>
                    {/each}
                </select>
                </div>
            </div>
            </label>
        </div>
        
        <div class="field">
            <label class="label">Host Port
            <p class="control is-expanded">
                <input class="input" 
                        type="number" 
                        placeholder="Port number" 
                        name="HostPort"
                        bind:value={host_port_value}
                        id="host_port_input"
                        min="1" max="65535"
                        style="width: 125px;">
            </p>
            </label>
            {#if host_port_value == null}
                <p style="hidden"></p>
            {:else if host_port_value < 1}
                <p class="help is-danger">Invalid port number</p>
            {:else if host_port_value > 65535}
                <p class="help is-danger">Invalid port number</p>
            {/if}
        </div>
        
        <div class="field">
            <label class="label">Container Port
            <p class="control is-expanded">
                <input class="input" 
                        type="number" 
                        placeholder="Port number" 
                        name="ContainerPort"
                        bind:value={container_port_value}
                        id="container_port_input"
                        min="1" max="65535"
                        style="width: 125px;">
            </p>
            </label>
            {#if container_port_value == null}
                <p style="hidden"></p>
            {:else if container_port_value < 1}
                <p class="help is-danger">Invalid port number</p>
            {:else if container_port_value > 65535}
                <p class="help is-danger">Invalid port number</p>
            {/if}
        </div>
        
        </div>
    </div>
    
    <div class="field is-horizontal">
        <div class="field-body">
        
        <div class="field">
            <p class="control is-expanded">
            <label class="label">Name
                <input class="input" 
                        type="text" 
                        placeholder="Image name" 
                        name="Name"
                        bind:value={container_name}
                        on:input={doCheck}>
            </label>
            {#if invalid == true}
                <p class="help is-danger">Invalid name</p>
            {/if}
            </p>
        </div>
        
        <div class="field">
            <div class="control">
            <label class="label">User
                <input class="input is-normal" 
                        type="username" 
                        placeholder="Username" 
                        name="User">
                </label>
            </div>
        </div>
        
        <div class="field">
            <p class="control is-expanded">
            <label class="label">Hostname
                <input class="input" 
                        type="text" 
                        placeholder="Hostname" 
                        name="Hostname">
            </label>
            </p>
        </div>
        
        <div class="field">
            <div class="control">
            <label class="label">Domain name
                <input class="input is-normal" 
                        type="text" 
                        placeholder="Domain name" 
                        name="Domainname">
                </label>
            </div>
        </div>
        
        </div>
    </div>
    
    <div class="field is-horizontal">
        <div class="field-body">
        
        <div class="field">
            <div class="control">
            <label class="label">Entrypoint
                <input class="input is-normal" 
                        type="text" 
                        placeholder="Entrypoint" 
                        name="Entrypoint">
                </label>
            </div>
        </div>
        
        <div class="field">
            <p class="control is-expanded">
            <label class="label">Command
                <input class="input" 
                        type="text" 
                        placeholder="CMD" 
                        name="Cmd">
            </label>
            </p>
        </div>
        
        <div class="field">
            <div class="control">
            <label class="label">Environment variables
                <input class="input is-normal" 
                        type="text" 
                        placeholder="FOO=bar,BAZ=quuz" 
                        name="Env">
                </label>
            </div>
        </div>
        
        </div>
    </div>
    
    <div class="field is-horizontal">
        <div class="field-body">
        
    <label class="checkbox">
        <input type="checkbox" name="Privileged">
        Privileged
    </label>
    
        </div>
    </div>
    
    <div class="field is-grouped">
        <div class="control">
        <button class="button is-link" type="submit">
            Create
        </button>
        </div>
        <div class="control">
        <button class="button is-link is-light" type="reset" on:click={reset_variables}>Clear</button>
        </div>
    </div>
    
    </form>

</div>

<div class="container block ml-6 mr-6">
    <div class="columns">
        <div class="column is-full">
            <div class="box">
            <p class="subtitle" align="center">
                Containers
            </p>
            <div class="table-container">
                <table class="table is-narrow is-striped is-hoverable" s
                        tyle="margin: auto;" align="center">
                <thead>
                    <tr>
                        <th class="has-text-centered">
                            <button align="center" 
                                    class="button is-small has-tooltip-right" 
                                    on:click={update_containers_list}
                                    data-tooltip="Refresh list">
                            <span class="icon is-small">
                                <img src={RefreshIcon} alt="Refresh icon">
                            </span>
                            </button>
                        </th>
                        <th class="has-text-centered">Image</th>
                        <th class="has-text-centered">Tag</th>
                        <th class="has-text-centered">Name</th>
                        <th class="has-text-centered">ID</th>
                        <th class="has-text-centered">State</th>
                        <th class="has-text-centered">Command</th>
                        <th class="has-text-centered">Created</th>
                        <th class="has-text-centered">Ports</th>
                    </tr>
                </thead>
                <tbody>
                    {#each ct as { Names, Id, Image, Command, Created, State, Ports } }
                    <tr>
                        <td class="has-text-centered">
                            <div class="field is-horizontal">
                            <div class="field-body">
                                <button on:click={() => container_remove({Id}, false, false, false)} 
                                        class="button is-small has-tooltip-right"
                                        data-tooltip="Delete container">
                                <span class="icon is-small">
                                    <img src={TrashIcon} alt="Trash icon">
                                </span>
                                </button>
                                <button on:click={() => stop_container({Id})}
                                        class="button is-small has-tooltip-right"
                                        data-tooltip="Stop container">
                                <span class="icon is-small">
                                    <img src={StopIcon} alt="Stop icon">
                                </span>
                                </button>
                                <button on:click={() => start_container({Id})}
                                        class="button is-small has-tooltip-right"
                                        data-tooltip="Start container">
                                <span class="icon is-small">
                                    <img src={PlayIcon} alt="Play icon">
                                </span>
                                </button>
                                <button on:click={() => restart_container({Id})}
                                        class="button is-small has-tooltip-right"
                                        data-tooltip="Restart container">
                                <span class="icon is-small">
                                    <img src={RefreshIcon} alt="Restart icon">
                                </span>
                                </button>
                            </div>
                            </div>
                        </td>
                        <td class="has-text-centered">{strip_container_name(Image)}</td>
                        <td class="has-text-centered">{strip_container_tag(Image)}</td>
                        <td class="has-text-centered">{strip_name(Names)}</td>
                        <td class="has-text-centered">{Id.substring(0,11)}</td>
                        <td class="has-text-centered">
                            <div class="content" 
                                 style="width: 100px;">
                                    {uppercase_first_letter(State)}
                            </div>
                        </td>
                        <td class="has-text-centered">{Command}</td>
                        <td class="has-text-centered">{Unix_timestamp(Created)}</td>
                        <td class="has-text-centered">{print_ports(Ports)}</td>
                    </tr>
                    {/each}
                </tbody>
                </table>
            </div>
            </div>
        </div>
    </div>
</div>
