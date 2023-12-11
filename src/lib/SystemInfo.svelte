<script>
  import { invoke } from "@tauri-apps/api/tauri";
  import { onMount } from "svelte";
  import { strip_name,
           Unix_timestamp,
           print_ports,
           extract_system_time,
           format_bytes,
           extract_locale_time
          } from './functions.svelte';
  
  let i = "";
  
  onMount(async function () {
     i = await invoke('fetch_system_info');
  });
</script>

<style>
  td {
    vertical-align: middle;
  }
</style>

<div class="container block ml-6 mr-6">
  <div class="columns">
    <div class="column">
      <div class="box">
        <p class="subtitle" align="center">System Information</p>
        <div class="table-container">
          <table class="table is-narrow is-striped is-hoverable" style="margin: auto;" align="center">
            <thead>
              <tr>
                <!-- <th></th> -->
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Images</td>
                <td>{#if i.Images != undefined}{i.Images}{/if}</td>
              </tr>
              <tr>
                <td>Containers</td>
                <td>{#if i.Containers != undefined}{i.Containers}{/if}</td>
              </tr>
              <tr>
                <td>Running</td>
                <td>{#if i.ContainersRunning != undefined}{i.ContainersRunning}{/if}</td>
              </tr>
              <tr>
                <td>Paused</td>
                <td>{#if i.ContainersPaused != undefined}{i.ContainersPaused}{/if}</td>
              </tr>
              <tr>
                <td>Stopped</td>
                <td>{#if i.ContainersStopped != undefined}{i.ContainersStopped}{/if}</td>
              </tr>
              <tr>
                <td>System Time</td>
                <td>{#if i.SystemTime != undefined}{extract_locale_time(i.SystemTime)}{/if}</td>
              </tr>
              <tr>
                <td>Uptime</td>
                <td>{#if i.Uptime != undefined}{i.Uptime}{/if}</td>
              </tr>
              <tr>
                <td>Name</td>
                <td>{#if i.Name != undefined}{i.Name}{/if}</td>
              </tr>
              <tr>
                <td>Operating system</td>
                <td>{#if i.OperatingSystem != undefined}{i.OperatingSystem}{/if}</td>
              </tr>
              <tr>
                <td>OS version</td>
                <td>{#if i.OSVersion != undefined}{i.OSVersion}{/if}</td>
              </tr>
              <tr>
                <td>OS type</td>
                <td>{#if i.OSType != undefined}{i.OSType}{/if}</td>
              </tr>
              <tr>
                <td>Architecture</td>
                <td>{#if i.Architecture != undefined}{i.Architecture}{/if}</td>
              </tr>
              <tr>
                <td>Kernel version</td>
                <td>{#if i.KernelVersion != undefined}{i.KernelVersion}{/if}</td>
              </tr>
              <tr>
                <td>Total memory</td>
                <td>{#if i.MemTotal != undefined}{format_bytes(i.MemTotal)}{/if}</td>
              </tr>
              <tr>
                <td>Swap free</td>
                <td>{#if i.SwapFree != undefined}{format_bytes(i.SwapFree)}{/if}</td>
              </tr>
              <tr>
                <td>Swap total</td>
                <td>{#if i.SwapTotal != undefined}{format_bytes(i.SwapTotal)}{/if}</td>
              </tr>
              <tr>
                <td>Memory limit</td>
                <td>{#if i.MemoryLimit != undefined}{i.MemoryLimit}{/if}</td>
              </tr>
              <tr>
                <td>Swap limit</td>
                <td>{#if i.SwapLimit != undefined}{i.SwapLimit}{/if}</td>
              </tr>
              <tr>
                <td>Driver</td>
                <td>{#if i.Driver != undefined}{i.Driver}{/if}</td>
              </tr>
              <tr>
                <td>CPU CFS Period</td>
                <td>{#if i.CpuCfsPeriod != undefined}{i.CpuCfsPeriod}{/if}</td>
              </tr>
              <tr>
                <td>CPU CFS Quota</td>
                <td>{#if i.CpuCfsQuota != undefined}{i.CpuCfsQuota}{/if}</td>
              </tr>
              <tr>
                <td>CPU Shares</td>
                <td>{#if i.CPUShares != undefined}{i.CPUShares}{/if}</td>
              </tr>
              <tr>
                <td>CPU Set</td>
                <td>{#if i.CPUSet != undefined}{i.CPUSet}{/if}</td>
              </tr>
              <tr>
                <td>PID's Limit</td>
                <td>{#if i.PidsLimit != undefined}{i.PidsLimit}{/if}</td>
              </tr>
              <tr>
                <td>IPv4 Forwarding</td>
                <td>{#if i.IPv4Forwarding != undefined}{i.IPv4Forwarding}{/if}</td>
              </tr>
              <tr>
                <td>Bridge NF IP-tables</td>
                <td>{#if i.BridgeNfIptables != undefined}{i.BridgeNfIptables}{/if}</td>
              </tr>
              <tr>
                <td>Bridge NF IP6-tables</td>
                <td>{#if i.BridgeNfIp6tables != undefined}{i.BridgeNfIp6tables}{/if}</td>
              </tr>
              <tr>
                <td>Debug</td>
                <td>{#if i.Debug != undefined}{i.Debug}{/if}</td>
              </tr>
              <tr>
                <td>NFd</td>
                <td>{#if i.NFd != undefined}{i.NFd}{/if}</td>
              </tr>
              <tr>
                <td>Oom kill disable</td>
                <td>{#if i.OomKillDisable != undefined}{i.OomKillDisable}{/if}</td>
              </tr>
              <tr>
                <td>NGoroutine</td>
                <td>{#if i.NGoroutines != undefined}{i.NGoroutines}{/if}</td>
              </tr>
              <tr>
                <td>Logging driver</td>
                <td>{#if i.LoggingDriver != undefined}{i.LoggingDriver}{/if}</td>
              </tr>
              <tr>
                <td>Cgroup driver</td>
                <td>{#if i.CgroupDrivers != undefined}{i.CgroupDriver}{/if}</td>
              </tr>
              <tr>
                <td>NEvents listener</td>
                <td>{#if i.NEventsListener != undefined}{i.NEventsListener}{/if}</td>
              </tr>
              <tr>
                <td>Index server address</td>
                <td>{#if i.IndexServerAddress != undefined}{i.IndexServerAddress}{/if}</td>
              </tr>
              <tr>
                <td>NCPU</td>
                <td>{#if i.NCPU != undefined}{i.NCPU}{/if}</td>
              </tr>
              <tr>
                <td>Docker Root Directory</td>
                <td>{#if i.DockerRootDir != undefined}{i.DockerRootDir}{/if}</td>
              </tr>
              <tr>
                <td>Http proxy</td>
                <td>{#if i.HttpProxy != undefined}{i.HttpProxy}{/if}</td>
              </tr>
              <tr>
                <td>Https proxy</td>
                <td>{#if i.HttpsProxy != undefined}{i.HttpsProxy}{/if}</td>
              </tr>
              <tr>
                <td>No proxy</td>
                <td>{#if i.NoProxy != undefined}{i.NoProxy}{/if}</td>
              </tr>
              <tr>
                <td>Labels</td>
                <td>{#if i.Labels != null}{i.Labels}{/if}</td>
              </tr>
              <tr>
                <td>Experimental build</td>
                <td>{#if i.ExperimentalBuild != undefined}{i.ExperimentalBuild}{/if}</td>
              </tr>
              <tr>
                <td>Server version</td>
                <td>{#if i.ServerVersion != undefined}{i.ServerVersion}{/if}</td>
              </tr>
              <tr>
                <td>Default runtime</td>
                <td>{#if i.DefaultRuntime != undefined}{i.DefaultRuntime}{/if}</td>
              </tr>
              <tr>
                <td>Live restore enabled</td>
                <td>{#if i.LiveRestoreEnabled != undefined}{i.LiveRestoreEnabled}{/if}</td>
              </tr>
              <tr>
                <td>Isolation</td>
                <td>{#if i.Isolation != undefined}{i.Isolation}{/if}</td>
              </tr>
              <tr>
                <td>Security options</td>
                <td>{#if i.SecurityOptions != undefined}{i.SecurityOptions}{/if}</td>
              </tr>
              <tr>
                <td>Product license</td>
                <td>{#if i.ProductLicense != undefined}{i.ProductLicense}{/if}</td>
              </tr>
              <tr>
                <td>Warnings</td>
                <td>{#if i.Warnings != undefined}{i.Warnings}{/if}</td>
              </tr>
              <tr>
                <td>Buildah version</td>
                <td>{#if i.BuildahVersion != undefined}{i.BuildahVersion}{/if}</td>
              </tr>
              <tr>
                <td>CPU realtime period</td>
                <td>{#if i.CPURealtimePeriod != undefined}{i.CPURealtimePeriod}{/if}</td>
              </tr>
              <tr>
                <td>CPU realtime runtime</td>
                <td>{#if i.CPURealtimeRuntime != undefined}{i.CPURealtimeRuntime}{/if}</td>
              </tr>
              <tr>
                <td>Cgroup version</td>
                <td>{#if i.CgroupVersion != undefined}{i.CgroupVersion}{/if}</td>
              </tr>
              <tr>
                <td>Rootless</td>
                <td>{#if i.Rootless != undefined}{i.Rootless}{/if}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
