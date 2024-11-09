#!/usr/bin/env sh

# 8.2 New Session
#

new_session() {
    endpoint_url=$1;
    payload=$2

    wget -q -O - --header="Content-Type: application/json" --post-data="$payload" "$endpoint_url"/session
}

# 8.3 Delete Session
#

delete_session() {
    endpoint_url=$1;
    session_id=$2

    wget -q -O - --method=delete "$endpoint_url"/session/"$session_id"
}

# 8.4 Status
#
status() {
    endpoint_url=$1;

    wget -q -O - "$endpoint_url"/status
}

# 9.1 Get Timeouts
#
get_timeouts() {
    endpoint_url=$1;
    session_id=$2

    wget -q -O - "$endpoint_url"/session/"$session_id"/timeouts
}

# 9.2 Set Timeouts
#
set_timeouts() {
    endpoint_url=$1;
    session_id=$2
    payload=$3

    wget -q -O - --header="Content-Type: application/json" --post-data="$payload" "$endpoint_url"/session/"$session_id"/timeouts
}

status http://localhost:4444

response=$(new_session http://localhost:4444 '{"capabilities": { "browserName": "icecat" } }')

session_id=$(echo "$response" | sed 's/.*"sessionId":"\(.[^"]*\)".*/\1/g')

set_timeouts http://localhost:4444 "$session_id" '{"script":1, "pageLoad":2, "implicit":3}'

get_timeouts http://localhost:4444 "$session_id"

delete_session http://localhost:4444 "$session_id"

