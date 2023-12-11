<script>
  import { invoke } from "@tauri-apps/api/tauri";
  import { onMount } from "svelte";
  import { strip_name,
           Unix_timestamp,
           format_bytes,
           strip_container_name,
           strip_container_tag,
           uppercase_first_letter
          } from './functions.svelte';
  import TrashIcon from '$lib/assets/trash.svg';
  import RefreshIcon from '$lib/assets/refresh.svg';
  import { writable } from 'svelte/store';
  
  let images_list = [];
  let image_name;
  let tag_name;
  let dialog;
  let dialog_data;

  let sortBy = {col: "Containers", ascending: true};

	$: sort = (column) => {
		if (sortBy.col == column) {
			sortBy.ascending = !sortBy.ascending
		} else {
			sortBy.col = column
			sortBy.ascending = true
		}
		
		// Modifier to sorting function for ascending or descending
		let sortModifier = (sortBy.ascending) ? 1 : -1;
		
		let sort = (a, b) => 
			(a[column] < b[column]) 
			? -1 * sortModifier 
			: (a[column] > b[column]) 
			? 1 * sortModifier 
			: 0;
		
		images_list = images_list.sort(sort);
	}
  
  async function update_image_list() {
    await invoke("fetch_images").then((result) => {
      images_list = result;
    }).catch((error) => {
      dialog_data = error;
      dialog.showModal();
    });
  };
  
  async function fetch_image() {
    let image_to_pull;
    if (tag_name != null) {
      image_to_pull = "fromImage=" + image_name.toLowerCase() + ":" + tag_name.toLowerCase();
    } else {
      image_to_pull = "fromImage=" + image_name.toLowerCase();
    };
    
    await invoke('pull_image', {query: image_to_pull}).then((result) => {
      if (result.includes("errorDetail")) {
        dialog_data = "Repository does not exist or access is denied";
        dialog.showModal();
      }
      update_image_list();
    }).catch((error) => {
      dialog_data = error;
      dialog.showModal();
    });
  };
  
  async function delete_image(ID) {
    await invoke('remove_image', { id: ID.Id.substring(7,18), force: false, noprune: false}).then((result) => {
      if (result.response == 409) {
        dialog_data = uppercase_first_letter(result.cause);
        dialog.showModal();
      }
      update_image_list();
    }).catch((error) => {
      dialog_data = error;
      dialog.showModal();
    });
  };
  
  onMount(async function () {
    dialog = document.getElementById('a_dialog');
    document.getElementById( "Image_name" ).addEventListener( "invalid",
        function( event ) {
            event.preventDefault();
    });
    update_image_list();
  });
  
</script>


<style>
  input:invalid {
    background-color: ivory;
    border: none;
    outline: 0.5px solid red;
    border-radius: 24px;
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

<div class="container block ml-6 mr-6">
  <div class="columns">
    <div class="column is-full">
      <div class="box">
        <div class="container">
          <p class="subtitle" align="center">Fetch image</p>
          
            <form method="POST" on:submit|preventDefault={fetch_image}>
            
              <div class="field is-horizontal">
                <div class="field-body">
                  
                  <div class="field">
                    <div class="control">
                      <label class="label">Image
                        <input class="input is-normal" 
                              type="text" 
                              placeholder="Image name" 
                              name="Imagename"
                              id="Image_name"
                              bind:value={image_name}
                              required>
                        </label>
                      </div>
                  </div>
        
                  <div class="field">
                    <div class="control">
                      <label class="label">Tag
                        <input class="input is-normal" 
                              type="text" 
                              placeholder="Tag name" 
                              name="Tagname"
                              bind:value={tag_name}>
                        </label>
                      </div>
                  </div>
        
                </div>
              </div>
              
                
              <div class="field is-grouped">
                <div class="control">
                  <button class="button is-link" type="submit">
                    Fetch image
                  </button>
                </div>
                <div class="control">
                  <button class="button is-link is-light" type="reset">Clear</button>
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
        <div class="table-container">
          <p class="subtitle" align="center">Images</p>
          <table class="table is-narrow is-striped is-hoverable sortable" 
                 style="margin: auto;" align="center"
                 id="myTable2"
                 sortable>
            <thead>
              <tr>
                <th>
                  <button align="center" 
                          class="button is-small has-tooltip-right" 
                          on:click={update_image_list}
                          data-tooltip="Refresh">
                    <span class="icon is-small">
                      <img src={RefreshIcon} alt="Refresh icon">
                    </span>
                  </button>
                </th>
                <th on:click={() => sort("Containers")}>Containers</th>
                <th on:click={() => sort('Image')}>Image</th>
                <th on:click={() => sort('Tag')}>Tag</th>
                <th on:click={() => sort("Created")}>Created</th>
                <th on:click={() => sort("Size")}>Size</th>
                <th on:click={() => sort("Id")}>Id</th>
              </tr>
            </thead>
            <tbody>
              {#each images_list as { Containers, Names, Created, Size, Id } }
              <tr>
                <td>
                  <button on:click={() => delete_image({Id})} 
                          class="button is-small has-tooltip-right"
                          data-tooltip="Delete image">
                    <span class="icon is-small">
                      <img src={TrashIcon} alt="Trash icon">
                    </span>
                  </button>
                </td>
                <td style="text-align: center;">{Containers}</td>
                <td>{strip_container_name(Names)}</td>
                <td>{strip_container_tag(Names)}</td>
                <td>{Unix_timestamp(Created)}</td>
                <td>{format_bytes(Size)}</td>
                <td>{Id.substring(7,18)}</td>
              </tr>
              {/each}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
