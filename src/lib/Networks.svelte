<script>
  import { invoke } from "@tauri-apps/api/tauri";
  import { onMount } from "svelte";
  import { strip_name, 
           Unix_timestamp, 
           print_ports,
           extract_time,
           test_name,
           valid_ip,
           uppercase_first_letter,
           string_12
          } from './functions.svelte';
  import RefreshIcon from '$lib/assets/refresh.svg';
  import TrashIcon from '$lib/assets/trash.svg';
  
  let networks = [];
  let network_name;
  let bridge_name;
  let host_binding_ipv4;
  let ip_validation;
  let name_validation;
  let dialog;
  let dialog_data;
  
  async function update_networks_list() {
     await invoke('fetch_networks').then((result) => {
      networks = result.networks;
     }).catch((error) => {
      dialog_data = error;
      dialog.showModal();
     });
  };
  
  function print_containers(data) {
    let keys = Object.keys(data);
    return keys.length;
  };
  
  function get_gateway(data) {
  var output = "";
    for (var i = 0; i < data.IPAM.Config.length; i++) {
      output += data.IPAM.Config[i].Gateway + "\n";
    }
    return output;
  };
  
  function get_subnet(data) {
  var output = "";
    for (var i = 0; i < data.IPAM.Config.length; i++) {
      output += data.IPAM.Config[i].Subnet + "\n";
    }
    return output;
  };
  
  async function delete_network(name) {
    await invoke('network_remove', { id: name }).then((result) => {
      update_networks_list();
    }).catch((error) => {
      console.log(error);
    });
  };
  
  async function create_network(event) {
    let formData = new FormData(event.target);
    let data = Object.fromEntries(formData.entries());
    let obj = {};
    
    obj.Name = network_name;
    
    if (data.check_duplicate == "on") {
      obj.CheckDuplicate = "true";
    } else {
      obj.CheckDuplicate = "false";
    }
    
    obj.Driver = 'bridge';
    
    if (data.enable_ipv6 == "on") {
      obj.EnableIPv6 = "true";
    } else {
      obj.EnableIPv6 = "false";
    }
    
    obj.IPAM = {};
    obj.IPAM.Driver = "default";
    
    // obj.IPAM.Config = [];
    // {
    //   "Subnet": "172.20.0.0/16",
    //   "IPRange": "172.20.10.0/24",
    //   "Gateway": "172.20.10.11"
    // },
    // {
    //   "Subnet": "2001:db8:abcd::/64",
    //   "Gateway": "2001:db8:abcd::1011"
    // }
    
    // obj.IPAM.Options = {};
    
    if (data.internal == "on") {
      obj.Internal = "true";
    } else {
      obj.Internal = "false";
    }
    
    if (data.attachable == "on") {
      obj.Attachable = "true";
    } else {
      obj.Attachable = "false";
    }
    
    if (data.ingress == "on") {
      obj.Ingress = "true";
    } else {
      obj.Ingress = "false";
    }
    
    if (bridge_name) {
      obj.Options = {
        "com.docker.network.bridge.name": bridge_name
      };
    } else {
        obj.Options = "none";
    };
    
    await invoke('network_create', {
        name: network_name, request: obj
    }).then((result) => {
        console.log(result);
        if (result.response == 500) {
            dialog_data = uppercase_first_letter(result.message);
            dialog.showModal();
        }
        update_networks_list();
    }).catch((error) => {
        dialog_data = error;
        dialog.showModal();
    });
    
  };
  
  function check_name() {
    if (test_name(network_name)) {
      name_validation = true;
    } else {
      name_validation = false;
    }
    if (network_name == '') {
      name_validation = null;
    }
  };
  
  function checkIP() {
    if (valid_ip(host_binding_ipv4)) {
      ip_validation = true;
    } else {
      ip_validation = false;
    }
    if (host_binding_ipv4 == '') {
      ip_validation = null;
    }
  };
  
  function return_delete_button() {
    return '<button on:click={() => delete_network(net.Name)} class="button is-small has-tooltip-right" data-tooltip="Delete network"><span class="icon is-small"><img src={TrashIcon} alt="Trash icon"></span></button>'
  };
  
  onMount(async function () {
    dialog = document.getElementById('a_dialog');
    document.getElementById("Network_name").addEventListener("invalid",
        function(event) {
            event.preventDefault();
    });
    update_networks_list();
  });
  
</script>

<style>
  td {
    vertical-align: middle;
  }
  input:invalid {
    background-color: ivory;
    border: none;
    outline: 1px solid red;
    border-radius: 5px;
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

<div class="container block ml-6 mr-6">
  <div class="columns">
    <div class="column is-full">
      <div class="box">
        <div class="container">
          <p class="subtitle" align="center">Create network</p>
          
            <form method="POST" on:submit|preventDefault={create_network}>
            
              <div class="field is-horizontal">
                <div class="field-body">
                  
                  <div class="field">
                    <div class="control">
                      <label class="label">Network
                        <input class="input is-normal" 
                              type="text" 
                              placeholder="Network name" 
                              name="Networkname"
                              id="Network_name"
                              bind:value={network_name}
                              on:input={check_name}
                              required>
                        </label>
                        {#if name_validation == false}
                          <p class="help is-danger">Invalid name</p>
                        {:else if name_validation == null}
                          <p class="help is-danger">Required</p>
                        {/if}
                      </div>
                  </div>
                  
                  <div class="field">
                    <div class="control">
                      <label class="label">Host-binding IPv4
                        <input class="input is-normal" 
                               type="text" 
                               placeholder="0.0.0.0" 
                               name="host_binding_ipv4"
                               id="host_binding"
                               bind:value={host_binding_ipv4}
                               on:input={checkIP}>
                        </label>
                        {#if ip_validation == false}
                          <p class="help is-danger">Invalid IP</p>
                        {:else if ip_validation == null}
                          <p style="hidden"></p>
                        {/if}
                      </div>
                  </div>
                  
                  <div class="field">
                    <div class="control">
                      <label class="label">Bridge name
                        <input class="input is-normal" 
                              type="text" 
                              placeholder="docker0" 
                              name="bridge_name"
                              id="bridge_name"
                              bind:value={bridge_name}>
                        </label>
                      </div>
                  </div>
                  
                </div>
              </div>
              
              <div class="field is-horizontal">
                <div class="field-body">
                  
                  <div class="field">
                    <div class="control">
                        <label class="checkbox">
                          <input type="checkbox"
                                 name="default_bridge">
                          Default bridge
                        </label>
                      </div>
                  </div>
                  
                  <div class="field">
                    <div class="control">
                        <label class="checkbox">
                          <input type="checkbox"
                                 name="enable_ipv6"
                                 checked>
                          Enable IPv6
                        </label>
                      </div>
                  </div>
                  
                  <div class="field">
                    <div class="control">
                        <label class="checkbox">
                          <input type="checkbox"
                                 name="internal">
                          Internal
                        </label>
                      </div>
                  </div>
                  
                  <div class="field">
                    <div class="control">
                        <label class="checkbox">
                          <input type="checkbox"
                                 name="attachable">
                          Attachable
                        </label>
                      </div>
                  </div>
                      
                  <div class="field">
                    <div class="control">
                        <label class="checkbox">
                          <input type="checkbox"
                                 name="ingress">
                          Ingress
                        </label>
                      </div>
                  </div>
              
                  <div class="field">
                    <div class="control">
                        <label class="checkbox">
                          <input type="checkbox"
                                 name="check_duplicate">
                          Check duplicate
                        </label>
                      </div>
                  </div>
                  
                </div>
              </div>
              
              <div class="field is-grouped">
                <div class="control">
                  <button class="button is-link" 
                          type="submit">
                    Create network
                  </button>
                </div>
                <div class="control">
                  <button class="button is-link is-light" type="reset">
                    Clear fields
                  </button>
                </div>
              </div>
            
            </form>
            
        </div>
      </div>
    </div>
  </div>
</div>

<div class="container block ml-6 mr-6">
  <div class="columns">
    <div class="column is-full">
      <div class="box">
        <p class="subtitle" align="center">Networks</p>
        <div class="table-container">
          <table class="table is-narrow is-striped is-hoverable" style="margin: auto;" align="center">
            <thead>
              <tr>
                <th align="center">
                  <button align="center" 
                          class="button is-small has-tooltip-right" 
                          on:click={update_networks_list}
                          data-tooltip="Refresh">
                    <span class="icon is-small">
                      <img src={RefreshIcon} alt="Refresh icon">
                    </span>
                  </button>
                </th>
                <th>Name</th>
                <th>Created</th>
                <th>Containers</th>
                <th>Scope</th>
                <th>Driver</th>
                <th>Gateway</th>
                <th>Subnet</th>
                <th>EnableIPv6</th>
                <th>Internal</th>
                <th>Attachable</th>
                <th>Ingress</th>
              </tr>
            </thead>
            <tbody>
              {#each networks as net }
              <tr align="center">
                <td>
                  {#if net.Name != "bridge"}
                    <button on:click={() => delete_network(net.Name)} 
                            class="button is-small has-tooltip-right"
                            data-tooltip="Delete network">
                      <span class="icon is-small">
                        <img src={TrashIcon} alt="Trash icon">
                      </span>
                    </button>
                  {/if}
                </td>
                <td>{net.Name}</td>
                <td>{extract_time(net.Created)}</td>
                <td>{print_containers(net.Containers)}</td>
                <td>{net.Scope}</td>
                <td>{net.Driver}</td>
                <td>{get_gateway(net)}</td>
                <td>{get_subnet(net)}</td>
                <td>{net.EnableIPv6}</td>
                <td>{net.Internal}</td>
                <td>{net.Attachable}</td>
                <td>{net.Ingress}</td>
              </tr>
              {/each}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
