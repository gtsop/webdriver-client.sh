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

response=$(new_session http://localhost:4444 '{"capabilities": { "browserName": "icecat" } }')

session_id=$(echo "$response" | sed 's/.*"sessionId":"\(.[^"]*\)".*/\1/g')

delete_session http://localhost:4444 "$session_id"
