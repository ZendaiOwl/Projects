<script context="module">
  
  export function strip_name(name) {
    let name_split = name.toString().split('/');
    return name_split[name_split.length-1];
  };
  
  export function strip_container_name(name) {
    if (name != undefined) {
      let name_split = name.toString().split('/');
      let tag_split = name_split[name_split.length-1].split(':');
      return tag_split[0];
    } else {
      return "<none>";
    };
  };
  
  export function strip_container_tag(name) {
    if (name != undefined) {
      let name_split = name.toString().split('/');
      let tag_split = name_split[name_split.length-1].split(':');
      return tag_split[tag_split.length-1];
    } else {
      return "<none>";
    };
  };
  
  export function extract_volume_mountpoint(mountpoint) {
    let split_string = mountpoint.toString().split('/');
    return split_string[split_string.length-1];
  };
  
  export function Unix_timestamp(t) {
    var dt = new Date(t*1000);
    var hr = dt.getHours();
    var m = "0" + dt.getMinutes();
    return dt.toLocaleString();
  };
  
  export function format_bytes(bytes, decimals = 2) {
    if (!+bytes) return '0 Bytes'

    const k = 1024
    const dm = decimals < 0 ? 0 : decimals
    const sizes = ['Bytes', 'KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB']

    const i = Math.floor(Math.log(bytes) / Math.log(k))

    return `${parseFloat((bytes / Math.pow(k, i)).toFixed(dm))} ${sizes[i]}`
  };
  
  export function print_ports(ports) {
    var output = "";
    if (JSON.stringify(ports) != "[]") {
      for (var i = 0; i < ports.length; i++) {
        output += ports[i].PrivatePort + ':' + ports[i].PublicPort + '\n';
      };
    };
    return output;
  };
  
  export function extract_time(clock) {
    let date = new Date(clock);
    return date.toLocaleDateString();
  };
  
  export function extract_locale_time(time) {
    let date = new Date(time);
    return date.toLocaleString();
  };
  
  export function extract_system_time(clock) {
    let date = new Date(clock);
    return date.toString();
  };
  
  export function test_name(input) {
    let name_regex = new RegExp('^[a-zA-Z0-9][a-zA-Z0-9_.-]*$');
    return name_regex.test(input);
  };
  
  export function valid_ip(ipaddress) {
    let ip_regex = new RegExp('^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
    return ip_regex.test(ipaddress);
  };
  
  export function uppercase_first_letter(string) {
      return string.charAt(0).toUpperCase() + string.slice(1);
  };
  
  export function string_12(string) {
    return string.substring(0,11);
  };
  
</script>
