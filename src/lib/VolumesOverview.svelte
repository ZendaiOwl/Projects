<script>
  import { invoke } from "@tauri-apps/api/tauri";
  import { onMount } from "svelte";
  import { strip_name, 
           Unix_timestamp, 
           print_ports,
           extract_volume_mountpoint,
           extract_system_time,
           extract_time,
           test_name,
           string_12
          } from './functions.svelte';
  import RefreshIcon from '$lib/assets/refresh.svg';
  import TrashIcon from '$lib/assets/trash.svg';
  
  let volumes_list = [];
  let vol = "";
  
  
  let volume_name;
  let dialog;
  let dialog_data;
  
  function get_label_key(labels) {
    let output = "";
    for (var i in labels) {
      output += i + "\n";
    }
    return output;
  };
  
  function get_label_value(labels) {
    let output = "";
    for (var i in labels) {
      output += labels[i] + "\n";
    }
    return output;
  };
  
  async function update_volumes_list() {
    await invoke('fetch_volumes').then((result) => {
      volumes_list = result.Volumes;
    }).catch((error) => {
      dialog_data = error;
      dialog.showModal();
    });
  };
  
  async function remove_volume(NAME) {
    await invoke('volume_remove', {
      name: NAME.Name, force: false
    }).then((result) => {
      update_volumes_list();
      if (result.StatusCode != 204) {
        dialog_data = result.Message;
        dialog.showModal();
      }
    }).catch((error) => {
      dialog_data = error;
      dialog.showModal();
    });
  };
  
  async function create_volume(event) {
    let formData = new FormData(event.target);
    let data = Object.fromEntries(formData.entries());
    let obj = {};
    
    if (volume_name) {
      obj.Name = volume_name;
    };
    
    obj.Driver = "local";
    obj.DriverOpts = {};
    
    obj.Labels = {};
    
    let label_input = document.getElementsByName('label[]');
    let value_input = document.getElementsByName('value[]');
    
    
    for (var i = 0; i < label_input.length; i++) {
      if (label_input[i].value != "") {
        obj.Labels[label_input[i].value] = value_input[i].value;
      }
    }
    
    
    await invoke('volume_create', { request: obj }).then((result) => {
      update_volumes_list();
    }).catch((error) => {
      dialog_data = error;
      dialog.showModal();
    });
  };
  
  function add_row() {
    let table = document.getElementById("volumes_labels");
    let row = table.insertRow(-1);
    let cell1 = row.insertCell(0);
    let cell2 = row.insertCell(1);
    
    cell1.innerHTML = '<input class="input is-normal" type="text" name="label[]">';
    cell2.innerHTML = '<input class="input is-normal" type="text" name="value[]">';
    
  };
  
  function delete_last_row() {
    if (document.getElementById("volumes_labels").rows.length > 1) {
      document.getElementById("volumes_labels").deleteRow(-1);
    }
  };
  
  onMount(async function () {
     update_volumes_list();
     dialog = document.getElementById('a_dialog');
  });
  
</script>

<style>
  td,th {
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


<div class="container block ml-6 mr-6">
  <div class="columns">
    <div class="column is-full">
      <div class="box">
        <div class="container">
          <p class="subtitle" align="center">Create volume</p>
      
            <form method="POST" 
                  on:submit|preventDefault={create_volume}>
            
              <div class="field is-horizontal">
                <div class="field-body">
                  
                  <div class="field">
                    <div class="control">
                      <label class="label">Volume name
                        <input class="input is-normal" 
                              type="text" 
                              placeholder="Volume name" 
                              name="Volumename"
                              id="Volume_name"
                              bind:value={volume_name}>
                        </label>
                      </div>
                  </div>
                  
                </div>
              </div>
              
              <div class="field is-horizontal">
                <div class="field-body">
                  <button on:click|preventDefault={add_row} type="button">Add label</button>
                  <button on:click|preventDefault={delete_last_row} 
                          type="button">Remove label</button>
                </div>
              </div>
              
              <div class="field is-horizontal">
                <div class="field-body">
                  
                  <table id="volumes_labels">
                    <thead>
                      <th>Label</th>
                      <th>Value</th>
                    </thead>
                    <tbody>
                      <tr>
                        <td>
                          <input class="input is-normal" type="text" name="label[]">
                        </td>
                        <td>
                          <input class="input is-normal" type="text" name="value[]">
                        </td>
                      </tr>
                    </tbody>
                  </table>
                  
                </div>
              </div>
              
              <div class="field is-grouped">
                <div class="control">
                  <button class="button is-link" 
                          type="submit">
                    Create volume
                  </button>
                </div>
                <div class="control">
                  <button class="button is-link is-light" type="reset">
                    Clear
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
        <p class="subtitle" align="center">Volumes</p>
        <div class="table-container">
          <table class="table is-narrow is-striped is-hoverable" 
                 style="margin: auto;" 
                 align="center">
            <thead>
              <tr>
                <th align="center">
                  <button align="center" 
                          class="button is-small has-tooltip-right" 
                          on:click={update_volumes_list}
                          data-tooltip="Refresh">
                    <span class="icon is-small">
                      <img src={RefreshIcon} alt="Refresh icon">
                    </span>
                  </button>
                </th>
                <th align="center">Created</th>
                <th align="center">Driver</th>
                <th align="center">Scope</th>
                <th>Name</th>
                <th>Label key</th>
                <th>Label value</th>
              </tr>
            </thead>
            <tbody>
              {#each volumes_list as { CreatedAt, Driver, Labels, Name, Options, Scope } }
              <tr align="center">
                <td>
                  <button on:click={() => remove_volume({Name})} 
                          class="button is-small has-tooltip-right"
                          data-tooltip="Delete volume">
                    <span class="icon is-small">
                      <img src={TrashIcon} alt="Trash icon">
                    </span>
                  </button>
                </td>
                <td>{extract_time(CreatedAt)}</td>
                <td>{Driver}</td>
                <td>{Scope}</td>
                <td align="left">{Name}</td>
                <td>{get_label_key(Labels)}</td>
                <td>{get_label_value(Labels)}</td>
              </tr>
              {/each}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
