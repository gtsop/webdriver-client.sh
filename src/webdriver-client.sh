#!/usr/bin/env sh

http_wget_catch_error() {
    # Wget exit status codes manual:
    # https://www.gnu.org/software/wget/manual/html_node/Exit-Status.html
    #
    url=$1
    method=$2
    exit_code=$3

    error_prefix="$method $url - wget error ($exit_code)  "

    if [ "$exit_code" = "4" ]; then
        echo "$error_prefix" "Network failure" >&2
        exit
    elif [ "$exit_code" = "8" ]; then
        echo "$error_prefix" "Server issued an error response" >&2
        exit
    fi
}

http_delete() {
    url=$1

    wget -q -O - --method=delete "$url"

    http_wget_catch_error "$url" "DELETE" "$?"
}

http_get() {
    url=$1

    wget -q -O - "$url"

    http_wget_catch_error "$url" "GET" "$?"
}

http_post() {
    url=$1
    data=$2

    if [ -z "$data" ]; then
        data="{}"
    fi

    wget -q --content-on-error -O - --header="Content-Type: application/json" --post-data="$data" "$url"

    http_wget_catch_error "$url" "POST" "$?"
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

# 11.3 Switch To Window
#
switch_to_window() {
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

# 12.3.2 Find Element
#
find_element() {
    endpoint_url=$1;
    session_id=$2
    payload=$3

    http_post "$endpoint_url"/session/"$session_id"/element "$payload"
}

# 12.3.3 Find Elements
#
find_elements() {
    endpoint_url=$1;
    session_id=$2
    payload=$3

    http_post "$endpoint_url"/session/"$session_id"/elements "$payload"
}

# 12.3.4 Find Element From Element
#
find_element_from_element() {
    endpoint_url=$1;
    session_id=$2
    element_id=$3
    payload=$4

    http_post "$endpoint_url"/session/"$session_id"/element/"$element_id"/element "$payload"
}

# 12.3.5 Find Elements From Element
#
find_elements_from_element() {
    endpoint_url=$1;
    session_id=$2
    element_id=$3
    payload=$4

    http_post "$endpoint_url"/session/"$session_id"/element/"$element_id"/elements "$payload"

}

# 12.3.6 Find Element From Shadow Root
#
find_element_from_shadow_root() {
    endpoint_url=$1;
    session_id=$2
    shadow_id=$3
    payload=$4

    http_post "$endpoint_url"/session/"$session_id"/shadow/"$shadow_id"/element "$payload"
}

# 12.3.7 Find Elements From Shadow Root
#
find_elements_from_shadow_root() {
    endpoint_url=$1;
    session_id=$2
    shadow_id=$3
    payload=$4

    http_post "$endpoint_url"/session/"$session_id"/shadow/"$shadow_id"/elements "$payload"
}

# 12.3.8 Get Active Element
#
get_active_element() {
    endpoint_url=$1;
    session_id=$2

    http_get "$endpoint_url"/session/"$session_id"/element/active
}

# 12.3.9 Get Element Shadow Root
#
get_element_shadow_root() {
    endpoint_url=$1;
    session_id=$2
    element_id=$3

    http_get "$endpoint_url"/session/"$session_id"/element/"$element_id"/shadow
}

# 12.4.1 Is Element Selected
#
is_element_selected() {
    endpoint_url=$1;
    session_id=$2;
    element_id=$3;

    http_get "$endpoint_url"/session/"$session_id"/element/"$element_id"/selected
}

# 12.4.2 Get Element Attribute
#
get_element_attribute() {
    endpoint_url=$1;
    session_id=$2;
    element_id=$3;
    attribute=$4;

    http_get "$endpoint_url"/session/"$session_id"/element/"$element_id"/attribute/"$attribute"
}

# 12.4.3 Get Element Property
#
get_element_property() {
    endpoint_url=$1;
    session_id=$2;
    element_id=$3;
    property=$4;

    http_get "$endpoint_url"/session/"$session_id"/element/"$element_id"/property/"$property"
}

# 12.4.4 Get Element CSS Value
#
get_element_css_value() {
    endpoint_url=$1;
    session_id=$2;
    element_id=$3;
    css_property=$4;

    http_get "$endpoint_url"/session/"$session_id"/element/"$element_id"/css/"$css_property"
}

# 12.4.5 Get Element Text
#
get_element_text() {
    endpoint_url=$1;
    session_id=$2;
    element_id=$3;

    http_get "$endpoint_url"/session/"$session_id"/element/"$element_id"/text
}

# 12.4.6 Get Element Tag Name
#
get_element_tag_name() {
    endpoint_url=$1;
    session_id=$2;
    element_id=$3;

    http_get "$endpoint_url"/session/"$session_id"/element/"$element_id"/name
}

# 12.4.7 Get Element Rect
#
get_element_rect() {
    endpoint_url=$1;
    session_id=$2;
    element_id=$3;

    http_get "$endpoint_url"/session/"$session_id"/element/"$element_id"/rect
}

# 12.4.8 Is Element Enabled
#
is_element_enabled() {
    endpoint_url=$1;
    session_id=$2;
    element_id=$3;

    http_get "$endpoint_url"/session/"$session_id"/element/"$element_id"/enabled
}

# 12.4.9 Get Computed Role
#
get_computed_role() {
    endpoint_url=$1;
    session_id=$2;
    element_id=$3;

    http_get "$endpoint_url"/session/"$session_id"/element/"$element_id"/computedrole
}

# 12.4.10 Get Computed Label
#
get_computed_label() {
    endpoint_url=$1;
    session_id=$2;
    element_id=$3;

    http_get "$endpoint_url"/session/"$session_id"/element/"$element_id"/computedlabel
}

# 12.5.1 Element Click
#
element_click() {
    endpoint_url=$1;
    session_id=$2;
    element_id=$3;

    http_post "$endpoint_url"/session/"$session_id"/element/"$element_id"/click
}

# 12.5.2 Element Clear
#
element_clear() {
    endpoint_url=$1;
    session_id=$2;
    element_id=$3;

    http_post "$endpoint_url"/session/"$session_id"/element/"$element_id"/clear
}

# 12.5.3 Element Send Keys
#
element_send_keys() {
    endpoint_url=$1;
    session_id=$2;
    element_id=$3;
    payload=$4;

    http_post "$endpoint_url"/session/"$session_id"/element/"$element_id"/value "$payload"
}

# 13.1 Get Page Source
#
get_page_source() {
    endpoint_url=$1;
    session_id=$2;

    http_get "$endpoint_url"/session/"$session_id"/source
}

# 13.2.1 Execute Script
#
execute_script() {
    endpoint_url=$1;
    session_id=$2;
    payload=$3;

    http_post "$endpoint_url"/session/"$session_id"/execute/sync "$payload"
}

# 13.2.2 Execute Async Script 
#
execute_async_script() {
    endpoint_url=$1;
    session_id=$2;
    payload=$3;

    http_post "$endpoint_url"/session/"$session_id"/execute/async "$payload"
}

# 14.1 Get All Cookies
#
get_all_cookies() {
    endpoint_url=$1;
    session_id=$2;

    http_get "$endpoint_url"/session/"$session_id"/cookie
}

# 14.2 Get Named Cookie
#
get_named_cookie() {
    endpoint_url=$1;
    session_id=$2;
    name=$3;

    http_get "$endpoint_url"/session/"$session_id"/cookie/"$name"
}

# 14.3 Add Cookie
#
add_cookie() {
    endpoint_url=$1;
    session_id=$2;
    payload=$3;

    http_post "$endpoint_url"/session/"$session_id"/cookie "$payload"
}


##### TODO COOKIES

# 15.7 Perform Actions
#
perform_actions() {
    endpoint_url=$1;
    session_id=$2;
    payload=$3;

    http_post "$endpoint_url"/session/"$session_id"/actions "$payload"
}

# 15.8 Release Actions
#
release_actions() {
    endpoint_url=$1;
    session_id=$2;

    http_delete "$endpoint_url"/session/"$session_id"/actions
}

# 16.2 Dismiss Alert
#
dismiss_alert() {
    endpoint_url=$1;
    session_id=$2;

    http_post "$endpoint_url"/session/"$session_id"/alert/dismiss
}

# 16.3 Accept Alert
#
accept_alert() {
    endpoint_url=$1;
    session_id=$2;

    http_post "$endpoint_url"/session/"$session_id"/alert/accept
}

# 16.4 Get Alert Text
#
get_alert_text() {
    endpoint_url=$1;
    session_id=$2;

    http_get "$endpoint_url"/session/"$session_id"/alert/text
}

# 16.5 Send Alert Text
#
send_alert_text() {
    endpoint_url=$1;
    session_id=$2;
    payload=$3;

    http_post "$endpoint_url"/session/"$session_id"/alert/text "$payload"
}
