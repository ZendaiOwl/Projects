<script>
  import { invoke } from "@tauri-apps/api/tauri";
  import { onMount } from "svelte";
  import { writable } from 'svelte/store';
  import { strip_name,
           Unix_timestamp,
           print_ports
          } from './functions.svelte';
  import RefreshIcon from '$lib/assets/refresh.svg';
  import TrashIcon from '$lib/assets/trash.svg';
  import PlayIcon from '$lib/assets/player-play-filled.svg';
  import StopIcon from '$lib/assets/square-filled.svg';
  
  let ct = [];
  
  async function update_containers_list() {
    await invoke('fetch_containers').then((result) => {
      ct = result;
    }).catch((error) => {
      console.log(error);
    });
  };
  
  async function delete_container(ID, VOL, FORCE, LINK) {
    await invoke('container_remove', {
      id: ID.Id, volumes: VOL, force: FORCE, link: LINK
    }).then((result) => {
      console.log(result);
    }).catch((error) => {
      console.log(error);
    });
  };
  
  onMount(async function () {
     update_containers_list();
  });

</script>

<div class="container block ml-6 mr-6">
  <div class="columns">
    <div class="column is-full">
      <div class="box">
        <p class="subtitle" align="center">
          Containers
        </p>
        <div class="table-container">
          <table class="table is-narrow is-striped is-hoverable sortable" s
                 tyle="margin: auto;" align="center">
            <thead>
              <tr>
                <th>
                  <button align="center" 
                          class="button is-small has-tooltip-right" 
                          on:click={update_containers_list}
                          data-tooltip="Refresh">
                    <span class="icon is-small">
                      <img src={RefreshIcon} alt="Refresh icon">
                    </span>
                  </button>
                </th>
                <th>Stop</th>
                <th>Start</th>
                <th>Restart</th>
                <th>Image</th>
                <th>Name</th>
                <th>ID</th>
                <th>Status</th>
                <th>Command</th>
                <th>Created</th>
                <th>Ports</th>
              </tr>
            </thead>
            <tbody>
              {#each ct as { Names, Id, Image, Command, Created, Status, Ports } }
              <tr>
                <td class="has-text-centered">
                  <button on:click={() => delete_container({Id}, false, false, false)} 
                          class="button is-small has-tooltip-right"
                          data-tooltip="Delete container">
                    <span class="icon is-small">
                      <img src={TrashIcon} alt="Trash icon">
                    </span>
                  </button>
                </td>
                <td class="has-text-centered">
                  <button
                          class="button is-small has-tooltip-right"
                          data-tooltip="Stop container">
                    <span class="icon is-small">
                      <img src={StopIcon} alt="Stop icon">
                    </span>
                  </button>
                </td>
                <td class="has-text-centered">
                  <button
                          class="button is-small has-tooltip-right"
                          data-tooltip="Start container">
                    <span class="icon is-small">
                      <img src={PlayIcon} alt="Play icon">
                    </span>
                  </button>
                </td>
                <td class="has-text-centered">
                  <button
                          class="button is-small has-tooltip-right"
                          data-tooltip="Restart container">
                    <span class="icon is-small">
                      <img src={RefreshIcon} alt="Restart icon">
                    </span>
                  </button>
                </td>
                <td style="text-align: center;">{strip_name(Image)}</td>
                <td>{strip_name(Names)}</td>
                <td>{Id.substring(0,11)}</td>
                <td>{Status}</td>
                <td>{Command}</td>
                <td>{Unix_timestamp(Created)}</td>
                <td>{#if Ports != null}{print_ports(Ports)}{/if}</td>
              </tr>
              {/each}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
