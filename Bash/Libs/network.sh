#!/usr/bin/env bash
# Victor-ray, S.

. ./calculus.sh
. ./docker.sh
. ./git.sh
. ./installation.sh
. ./json.sh
. ./tests.sh
. ./utility.sh


# ---------------------------
# Riksdagen - Document Search
# Swedish Law
# ---------------------------

# Sends a search query for Swedish legal documents (SFS) 
function lag {
	[[ "$#" -ne 1 ]] && { return 1; }
	! has_cmd 'jq' && { return 2; }
	local SEARCH 
	SEARCH="$(url_encode "$1")"
	local -r URL="https://data.riksdagen.se/dokumentlista/?sok=${SEARCH}&doktyp=SFS&utformat=json"
	curl --silent --location "$URL" | jq '.'
}

# Fetches an SFS document
function sfs_dokument {
	[[ "$#" -ne 1 ]] && { return 1; }
	! has_cmd 'jq' && { return 2; }
	local -r URL="https://data.riksdagen.se/dokument/$1"
	# curl --silent --location "$URL" | jq '.'
	curl --silent --location "$URL"
}

# ----------
# Dictionary
# ----------

# Queries a word for the dictionary definition
function dictionary {
	[[ "$#" -ne 1 ]] && { return 1; }
	! has_cmd 'curl' || ! has_cmd 'jq' && { return 2; }
    local -r base_url="https://api.dictionaryapi.dev/api/v2/entries/en/$1"
    curl --silent --location "$base_url" | jq
}


# -------
# Network
# -------

# Test if a port is open or closed on a remote host
# Exit codes
# 1: Open
# 2: Closed
# 3: Invalid number of arguments
function test_remote_port {
    [[ "$#" -eq 2 ]] && { log 2 "[ $#/2 ] Requires: HOST, PORT"; return 2; }
    if timeout 2.0 bash -c "true &>/dev/null>/dev/tcp/${1}/${2}"
    then log -1 "Open"
    else log -1 "Closed"; return 1
    fi
}

# Queries DNS record of a domain
# Return codes
# 1: Invalid number of arguments
# 2: Missing argument(s): Domain, Optional Domain Record
function get_dns_record {
    [[ "$#" -eq 0  || "$#" -gt 2 ]] && { log 2 "Invalid number of arguments: $#/1-2"; return 1; }
    [[ "$#" -eq 2 ]] && { dig "$1" "$2" +short; }
    [[ "$#" -eq 1 ]] && { dig "$1" +short; }
}

# Gets the public IP for the network
# Return codes
# 1: Missing command: curl
function get_all_public_ip {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 1; }
    local -r URLv4="https://ipv4.icanhazip.com" \
               URLv6="https://ipv6.icanhazip.com" \
               ARGS=(--silent --max-time 4)
    curl "${ARGS[@]}" --ipv4 "$URLv4" 2>/dev/null || println 'N/A'
    curl "${ARGS[@]}" --ipv6 "$URLv6" 2>/dev/null || println 'N/A'
}

# Gets the public IP for the network
# Return codes
# 1: Fail - No public IPv4
# 2: Missing command: curl
function get_public_ipv4 {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 2; }
    local -r URLv4="https://ipv4.icanhazip.com" \
               ARGS=(--silent --max-time 4)
    curl "${ARGS[@]}" --ipv4 "$URLv4" 2>/dev/null || return 1
}

# Gets the public IP for the network
# Return codes
# 1: Fail - No public IPv6
# 2: Missing command: curl
function get_public_ipv6 {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 2; }
    local -r URLv6="https://ipv6.icanhazip.com" \
               ARGS=(--silent --max-time 4)
    curl "${ARGS[@]}" --ipv6 "$URLv6" 2>/dev/null || return 1
}

# Tests for Public IPv4
# Return codes
# 0: Public IPv4 Available
# 1: Public IPv4 Unavailable
# 2: Missing command: curl
function test_public_ipv4 {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 2; }
    local -r URL="https://ipv4.icanhazip.com" \
             ARGS=(--silent --max-time 4 --ipv4)
    if curl "${ARGS[@]}" "$URL" &>/dev/null
    then log -1 "Available"
    else log -1 "Unavailable"; return 1
    fi
}

# Tests for Public IPv6
# Return codes
# 0: Public IPv6 Available
# 1: Public IPv6 Unavailable
# 2: Missing command: curl
function test_public_ipv6 {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 2; }
    local -r URL="https://ipv6.icanhazip.com" \
             ARGS=(--silent --max-time 4 --ipv6)
    if curl "${ARGS[@]}" "$URL" &>/dev/null
    then { log -1 "Available"; return 0; }
    else { log -1 "Unavailable"; return 1; }
    fi
}

# Gets the local IP assigned to the WiFi card for the device
# IPv4, IPv6 & Link-local
function get_local_ip {
    if has_cmd 'jq'
    then ip -j address | jq -r '.[].addr_info[] as $i |
        if $i.scope == "global"
        then
            if $i.family == "inet6"
            then
                if $i.label?
                then "IPv6 " + $i.local + " (" + $i.label  + ")"
                else "IPv6 " + $i.local
                end
            else
                if $i.label?
                then "IPv4 " + $i.local + " (" + $i.label  + ")"
                else "IPv4 " + $i.local
                end
            end
        else empty
        end'
    else ip a | grep 'scope global' | awk '{print $2}' | head -2 | sed 's|/.*||g'
    fi
}

# Gets all the local IP-addresses on the device
function get_all_local_ip {
    if has_cmd 'jq'
    then ip -j address | jq -r '.[].addr_info[].local'
    else ip a | grep 'inet' | awk '{print $2}' | sed 's|/.*||g'
    fi
}

# Get device IP information
# Return codes
# 1: Invalid number of arguments
function get_ip_info {
    [[ "$#" -gt 0 ]] && { log 2 "Invalid number of arguments: $#/0"; return 1; }
    if has_cmd 'jq'
    then ip -j address | jq '.'
    else ip address
    fi
}

# Gets the listening ports on the system
# Return codes
# 1: Missing command: grep
# 2: Missing command: lsof
# 3: No root privileges
function get_listening_services {
    ! has_cmd 'lsof' && { log 2 "Missing command: lsof"; return 2; }
    ! has_cmd 'grep' && { log 2 "Missing command: grep"; return 1; }
    if is_root
    then grep 'LISTEN' <(lsof -i -P -n)
    elif has_cmd 'sudo'
    then sudo lsof -i -P -n | grep 'LISTEN'
    else log 2 "No root privileges"; return 3
    fi
}

# Gets the services running on the network interfaces
# Return code
# 1: Missing command: lsof
# 2: Missing command: sudo (No root privileges)
function network_interface_services {
    ! has_cmd 'lsof' && { log 2 "Missing command: lsof"; return 1; }
    if is_root
    then lsof -n -P -i
    elif has_cmd 'sudo'
    then sudo lsof -n -P -i
    else { log 2 "No root privileges"; return 2; }
    fi
}

# Gets the HTML code for a URL with Bash TCP
# Reuires the host TCP server to listen on HTTP, not HTTPS, it'a a plain HTTP request
# Return codes
# 1: Arguments error, requires: Host, Port
function get_url {
    [[ "$#" -ne 2 ]] && { log 2 "[ $#/2 ] Requires: HOST, PORT"; return 1; }
    exec 5<>/dev/tcp/"$1"/"$2"
    echo -e "GET / HTTP/1.1\r\nHost: ${1}\r\nConnection: close\r\n\r" >&5
    cat <&5
    
}

# Loops through HTML elements that are fed into the function through a pipe via STDIN
function html_next {
    local IFS='>'
    # shellcheck disable=SC2034
    read -r -d '<' TAG VALUE
}


# ------
# Crypto
# ------

# Fetches the current price of Bitcoin in Euro € from Binance
# Return codes
# 1: Missing command: curl
function get_btc {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 1; }
    local -r URL="https://api.binance.com/api/v3/ticker/price?symbol=BTCEUR" \
               ARGS=(--silent --location)
    if ! has_cmd 'jq'
    then curl "${ARGS[@]}" "$URL"
    else curl "${ARGS[@]}" "$URL" | jq '.'
    fi
}

# Checks and tests so the commands for the BTC functions are present
function check_btc_query_commands {
    if ! has_cmd 'curl' || ! has_cmd 'jq'
    then
        return 1
    else
        return 0
    fi
}

# API information from BTC.com to query the Bitcoin blockchain
# Source: https://explorer.btc.com/btc/adapter?type=api-doc
# Source: https://www.blockchain.com/explorer/api/blockchain_api
function btc_query {
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands
    then
        return 1
    fi
    local DATA_ADDRESS DATA_TX
    DATA_ADDRESS="$(btc_query_address "$1")"
    DATA_TX="$(btc_query_balance "$1")"
    if is_json_object "$DATA_ADDRESS"
    then
        json_read "$DATA_ADDRESS"
    fi
    if is_json_object "$DATA_TX"
    then
        json_read "$DATA_TX"
    fi
}

# Checks the data for a given BTC address
function btc_address {
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands
    then
        return 1
    fi
    local -r URL="https://blockchain.info/rawaddr/$1"
    local DATA
    DATA="$(curl --silent --location "$URL")"
    if [[ "$DATA" ]]
    then
        json_read "$DATA"
    else
        return 2
    fi
}

# Checks the data for a given BTC transaction
function btc_transaction {
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands
    then
        return 1
    fi
    local -r URL="https://blockchain.info/rawtx/$1"
    local DATA
    DATA="$(curl --silent --location "$URL")"
    if [[ "$DATA" ]]
    then
        json_read "$DATA"
    fi
}

# Checks the current balance for a BTC wallet address
function btc_balance {
    if ! check_btc_query_commands
    then
        return 1
    fi
    local -r URL="https://blockchain.info/balance?active=$1"
    local DATA
    DATA="$(curl --silent --location "$URL")"
    if [[ "$DATA" ]]
    then
        json_read "$DATA"
    else
        return 2
    fi
}

# Checks the balance or the remainder of unspent BTC on a given wallet address
function btc_address_unspent {
    if ! check_btc_query_commands
    then
        return 1
    fi
    local -r URL="https://blockchain.info/unspent?active=$1"
    local DATA
    DATA="$(curl --silent --location "$URL")"
    if [[ "$DATA" ]]
    then
        json_read "$DATA"
    fi
}

# Checks a given BTC block
function btc_block {
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands
    then
        return 1
    fi
    local URL="https://blockchain.info/rawblock/$1"
    local DATA
    DATA="$(curl --silent --location "$URL")"
    if [[ "$DATA" ]]
    then
        json_read "$DATA"
    fi
}

# Generate RPC authentication credentials for the Bitcoin Client
function btc_rpc_auth {
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands || ! has_cmd 'python3'
    then
        return 1
    fi
    curl -sSL "https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/rpcauth/rpcauth.py" \
    | python3 - "$1"
}

