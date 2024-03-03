#!/usr/bin/env bash

get_btc () 
{ 
    ! have_cmd 'curl' && { 
        log 2 "Missing command: curl";
        return 1
    };
    local -r BINANCE_URL="https://api.binance.com/api/v3/ticker/price?symbol=BTCEUR";
    local -r KRAKEN_URL="https://api.kraken.com/0/public/Ticker?pair=XBTEUR";
    local -ar ARGS=(--silent --location);
    if ! have_cmd 'jq'; then
        curl "${ARGS[@]}" "$BINANCE_URL";
        curl "${ARGS[@]}" "$KRAKEN_URL";
    else
        LC_NUMERIC=C printf '%s %.2f %s\n' "€" "$(curl "${ARGS[@]}" "$BINANCE_URL" | jq -r '.price')" "Binance";
        LC_NUMERIC=C printf '%s %.2f %s\n' "€" "$(curl "${ARGS[@]}" "$KRAKEN_URL" | jq -r '.result.XXBTZEUR.c[0]')" "Kraken";
    fi
}

check_btc_query_commands () 
{ 
    if ! have_cmd 'curl' || ! have_cmd 'jq'; then
        return 1;
    else
        return 0;
    fi
}

btc_query () 
{ 
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands; then
        return 1;
    fi;
    local DATA_ADDRESS DATA_TX;
    DATA_ADDRESS="$(btc_query_address "$1")";
    DATA_TX="$(btc_query_balance "$1")";
    if is_json_object "$DATA_ADDRESS"; then
        json_read "$DATA_ADDRESS";
    fi;
    if is_json_object "$DATA_TX"; then
        json_read "$DATA_TX";
    fi
}

btc_address () 
{ 
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands; then
        return 1;
    fi;
    local -r URL="https://blockchain.info/rawaddr/$1";
    local DATA;
    DATA="$(curl --silent --location "$URL")";
    if [[ -n "$DATA" ]]; then
        json_read "$DATA";
    else
        return 2;
    fi
}

btc_transaction () 
{ 
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands; then
        return 1;
    fi;
    local -r URL="https://blockchain.info/rawtx/$1";
    local DATA;
    DATA="$(curl --silent --location "$URL")";
    if [[ -n "$DATA" ]]; then
        json_read "$DATA";
    fi
}

btc_balance () 
{ 
    if ! check_btc_query_commands; then
        return 1;
    fi;
    local -r URL="https://blockchain.info/balance?active=$1";
    local DATA;
    DATA="$(curl --silent --location "$URL")";
    if [[ -n "$DATA" ]]; then
        json_read "$DATA";
    else
        return 2;
    fi
}

btc_address_unspent () 
{ 
    if ! check_btc_query_commands; then
        return 1;
    fi;
    local -r URL="https://blockchain.info/unspent?active=$1";
    local DATA;
    DATA="$(curl --silent --location "$URL")";
    if [[ -n "$DATA" ]]; then
        json_read "$DATA";
    fi
}

btc_block () 
{ 
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands; then
        return 1;
    fi;
    local URL="https://blockchain.info/rawblock/$1";
    local DATA;
    DATA="$(curl --silent --location "$URL")";
    if [[ -n "$DATA" ]]; then
        json_read "$DATA";
    fi
}

btc_rpc_auth () 
{ 
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands || ! have_cmd 'python3'; then
        return 1;
    fi;
    curl -sSL "https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/rpcauth/rpcauth.py" | python3 - "$1"
}

