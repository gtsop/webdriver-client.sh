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

# 10.4 Forward
#
forward() {
    endpoint_url=$1;
    session_id=$2

    http_post "$endpoint_url"/session/"$session_id"/forward
}

# 10.5 Refresh
#
refresh() {
    endpoint_url=$1;
    session_id=$2

    http_post "$endpoint_url"/session/"$session_id"/refresh
}

# 10.6 Get Title
#
get_title() {
    endpoint_url=$1;
    session_id=$2

    http_get "$endpoint_url"/session/"$session_id"/title
}

# 11.1 Get Window Handle
#
get_window_handle() {
    endpoint_url=$1;
    session_id=$2

    http_get "$endpoint_url"/session/"$session_id"/window
}

# 11.2 Close Window
#
close_window() {
    endpoint_url=$1;
    session_id=$2

    http_delete "$endpoint_url"/session/"$session_id"/window
}

# 11.3 Switch Window
#
switch_window() {
    endpoint_url=$1;
    session_id=$2
    payload=$3

    http_post "$endpoint_url"/session/"$session_id"/window "$payload"
}

# 11.4 Get Window Handles
#
get_window_handles() {
    endpoint_url=$1;
    session_id=$2

    http_get "$endpoint_url"/session/"$session_id"/window/handles
}

# 11.5 New Window
#
new_window() {
    endpoint_url=$1;
    session_id=$2

    http_post "$endpoint_url"/session/"$session_id"/window/new
}

# 11.6 Switch To Frame
#
switch_to_frame() {
    endpoint_url=$1;
    session_id=$2
    payload=$3

    http_post "$endpoint_url"/session/"$session_id"/frame "$payload"
}

# 11.7 Switch To Parent Frame
#
switch_to_parent_frame() {
    endpoint_url=$1;
    session_id=$2

    http_post "$endpoint_url"/session/"$session_id"/frame/parent
}

# 11.8.1 Get Window Rect
#
get_window_rect() {
    endpoint_url=$1;
    session_id=$2

    http_get "$endpoint_url"/session/"$session_id"/window/rect
}


# 11.8.2 Set Window Rect
#
set_window_rect() {
    endpoint_url=$1;
    session_id=$2
    payload=$3

    http_post "$endpoint_url"/session/"$session_id"/window/rect "$payload"
}

# 11.8.3 Maximize Window 
#
maximize_window() {
    endpoint_url=$1;
    session_id=$2

    http_post "$endpoint_url"/session/"$session_id"/window/maximize
}

# 11.8.4 Minimize Window 
#
minimize_window() {
    endpoint_url=$1;
    session_id=$2

    http_post "$endpoint_url"/session/"$session_id"/window/minimize
}

# 11.8.5 Fullscreen Window 
#
fullscreen_window() {
    endpoint_url=$1;
    session_id=$2

    http_post "$endpoint_url"/session/"$session_id"/window/fullscreen
}
