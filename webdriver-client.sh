#!/usr/bin/env sh

http_delete() {
    url=$1

    wget -q -O - --method=delete "$url"
}

http_get() {
    url=$1

    wget -q -O - "$url"
}

http_post() {
    url=$1
    data=$2

    if [ -z "$data" ]; then
        data="{}"
    fi

    wget -q -O - --header="Content-Type: application/json" --post-data="$data" "$url"
}

# 8.2 New Session
#

new_session() {
    endpoint_url=$1;
    payload=$2

    http_post "$endpoint_url"/session "$payload"
}

# 8.3 Delete Session
#

delete_session() {
    endpoint_url=$1;
    session_id=$2

    http_delete "$endpoint_url"/session/"$session_id"
}

# 8.4 Status
#
status() {
    endpoint_url=$1;

    http_get "$endpoint_url"/status
}

# 9.1 Get Timeouts
#
get_timeouts() {
    endpoint_url=$1;
    session_id=$2

    http_get "$endpoint_url"/session/"$session_id"/timeouts
}

# 9.2 Set Timeouts
#
set_timeouts() {
    endpoint_url=$1;
    session_id=$2
    payload=$3

    http_post "$endpoint_url"/session/"$session_id"/timeouts "$payload"
}

# 10.1 Navigate To
#
navigate_to() {
    endpoint_url=$1;
    session_id=$2
    payload=$3

    http_post "$endpoint_url"/session/"$session_id"/url "$payload"
}

# 10.2 Get Current URL
#
get_current_url() {
    endpoint_url=$1;
    session_id=$2

    http_get "$endpoint_url"/session/"$session_id"/url
}

# 10.3 Back
#
back() {
    endpoint_url=$1;
    session_id=$2

    http_post "$endpoint_url"/session/"$session_id"/back
}
