#!/usr/bin/env sh

# ./check.sh

. ./webdriver-client.sh

# Kill existing instances
ps -aux | grep gecko | grep "\--port 4444" | awk '{print $2}' | xargs kill > /dev/null 2>&1
# create new instance
geckodriver --port 4444 > /dev/null 2>&1 &
webdriver_pid=$!
session_id=""
create_session() {
    response=$(new_session http://localhost:4444 '{"capabilities": { "browserName": "icecat" } }')
    session_id=$(echo "$response" | sed 's/.*"sessionId":"\(.[^"]*\)".*/\1/g')
}
clear_session() {
    response=$(delete_session http://localhost:4444 "$session_id")
}
visit_index() {
    response=$(navigate_to http://localhost:4444 "$session_id" "{\"url\":\"file://$(pwd)/index.html\"}")
}
cleanup() {
    clear_session
    kill "$webdriver_pid" 2>/dev/null
    exit
}
trap cleanup EXIT INT TERM

pause() {
    echo "PAUSED: press enter to continue the test"
    read
}

while true; do
    response=$(status "http://localhost:4444")
    is_ready=$(echo "$response" | sed 's/.*"ready":\(true\|false\).*/\1/g')
    if [ "$is_ready" = "true" ]; then
        break
    fi
    sleep 1
done
test() {
    title="$1"
    test_case="$2"

    printf "%s" "[TEST] $title "

    $test_case

    result=$?

    if [ "$result" = "0" ]; then
        printf "[PASS]\n"
    else
        printf "[FAIL]\n"
    fi
}

######################################################################

test_new_session() {
    response=$(new_session http://localhost:4444 '{"capabilities": { "browserName": "icecat" } }')
    session_id=$(echo "$response" | sed 's/.*"sessionId":"\(.[^"]*\)".*/\1/g')

    [ -n "$session_id" ]
}

test_delete_session() {
    response=$(delete_session http://localhost:4444 "$session_id")
    value=$(echo "$response" | sed 's/.*"value":\(null\).*/\1/g')

    [ "$value" = "null" ]
}

test_status() {
    response=$(status "http://localhost:4444")
    is_ready=$(echo "$response" | sed 's/.*"ready":\(true\|false\).*/\1/g')

    [ "$is_ready" = "true" ]
}

test_get_timeouts() {
    response=$(set_timeouts http://localhost:4444 "$session_id" '{"script":9999}')
    response=$(get_timeouts http://localhost:4444 "$session_id")
    script_timeout=$(echo "$response" | sed 's/.*"script":\([0-9]\+\).*/\1/g')

    [ "$script_timeout" = "9999" ]
}

test_set_timeouts() {
    response=$(set_timeouts http://localhost:4444 "$session_id" '{"script":9999}')
    response=$(get_timeouts http://localhost:4444 "$session_id")
    script_timeout=$(echo "$response" | sed 's/.*"script":\([0-9]\+\).*/\1/g')

    [ "$script_timeout" = "9999" ]
}

test_navigate_to() {
    response=$(navigate_to http://localhost:4444 "$session_id" "{\"url\":\"file://$(pwd)/index.html\"}")
    value=$(echo "$response" | sed 's/.*"value":\(null\).*/\1/g')

    [ "$value" = "null" ]
}

test_get_current_url() {
    response=$(get_current_url http://localhost:4444 "$session_id")
    value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')

    [ "$value" = "file://$(pwd)/index.html" ]
}

test_back() {
    response=$(navigate_to http://localhost:4444 "$session_id" "{\"url\":\"file://$(pwd)/index.html#foo\"}")
    response=$(back http://localhost:4444 "$session_id")
    response=$(get_current_url http://localhost:4444 "$session_id")
    value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')

    [ "$value" = "file://$(pwd)/index.html" ]
}

test_forward() {
    response=$( forward http://localhost:4444 "$session_id")
    response=$(get_current_url http://localhost:4444 "$session_id")
    value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')

    [ "$value" = "file://$(pwd)/index.html#foo" ]
}

test_refresh() {
    response=$(refresh http://localhost:4444 "$session_id")
    value=$(echo "$response" | sed 's/.*"value":\(null\).*/\1/g')

    [ "$value" = "null" ]
}

test_get_title() {
    response=$(get_title http://localhost:4444 "$session_id")
    value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')

    [ "$value" = "Title" ]
}

test_get_window_handle() {
    response=$(get_window_handle http://localhost:4444 "$session_id")
    value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')

    [ -n "$value" ]
}

test_close_window() {
    response=$(close_window http://localhost:4444 "$session_id")
    value=$(echo "$response" | sed 's/.*"value":\[\(.*\)\].*/\1/g')

    [ -z "$value" ]
}

test_switch_to_window() {
    response=$(get_window_handle http://localhost:4444 "$session_id")
    window_handle=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')
    response=$(switch_to_window http://localhost:4444 "$session_id" "{\"handle\": \"$window_handle\"}")
    value=$(echo "$response" | sed 's/.*"value":\(null\).*/\1/g')

    [ "$value" = "null" ]
}

test_get_window_handles() {
    response=$(get_window_handles http://localhost:4444 "$session_id")
    value=$(echo "$response" | sed 's/.*"value":\["\(.*\)"\].*/\1/g')

    [ -n "$value" ]
}

test_new_window() {
    response=$(new_window http://localhost:4444 "$session_id")
    value=$(echo "$response" | sed 's/.*"handle":"\(.[^"]*\)".*/\1/g')

    [ -n "$value" ]
}

test_switch_to_frame() {
    response=$(switch_to_frame http://localhost:4444 "$session_id" '{"id":null}')
    value=$(echo "$response" | sed 's/.*"value":\(null\).*/\1/g')

    [ -n "$value" ]
}

test_switch_to_parent_frame() {
    response=$(switch_to_parent_frame http://localhost:4444 "$session_id" '{"id":null}')
    value=$(echo "$response" | sed 's/.*"value":\(null\).*/\1/g')

    [ -n "$value" ]
}

test_get_window_rect() {
    response=$(get_window_rect http://localhost:4444 "$session_id")
    width=$(echo "$response" | sed 's/.*"width":\([0-9]\+\).*/\1/g')

    [ "$width" = "1280" ]
}

test_set_window_rect() {
    response=$(set_window_rect http://localhost:4444 "$session_id" '{"x":100,"y":50,"width":500,"height":500}')
    response=$(get_window_rect http://localhost:4444 "$session_id")
    width=$(echo "$response" | sed 's/.*"width":\([0-9]\+\).*/\1/g')

    [ "$width" = "500" ]
}

test_maximize_window() {
    response=$(maximize_window http://localhost:4444 "$session_id")
    x=$(echo "$response" | sed 's/.*"x":\([0-9]\+\).*/\1/g')

    [ "$x" = "0" ]
}

test_minimize_window() {
    response=$(minimize_window http://localhost:4444 "$session_id")
    width=$(echo "$response" | sed 's/.*"width":\([0-9]\+\).*/\1/g')

    [ "$width" -lt "600" ]
}

test_fullscreen_window() {
    response=$(fullscreen_window http://localhost:4444 "$session_id")
    x=$(echo "$response" | sed 's/.*"x":\([0-9]\+\).*/\1/g')

    [ "$x" = "0" ]
}

test_find_element() {
    response=$(navigate_to http://localhost:4444 "$session_id" "{\"url\":\"file://$(pwd)/index.html\"}")
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"a"}')
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')

    [ -n "$element" ]
}

test_find_elements() {
    response=$(find_elements http://localhost:4444 "$session_id" '{"using":"css selector", "value":"a"}')
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')

    [ -n "$element" ]
}

test_find_element_from_element() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"main"}')
    main_element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(find_element_from_element http://localhost:4444 "$session_id" "$main_element" '{"using":"css selector", "value":"a"}')
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')

    [ -n "$element" ]
}

test_find_elements_from_element() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"main"}')
    main_element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(find_elements_from_element http://localhost:4444 "$session_id" "$main_element" '{"using":"css selector", "value":"a"}')
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')

    [ -n "$element" ]
}

test_find_element_from_shadow_root() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"section"}')
    section_element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(get_element_shadow_root http://localhost:4444 "$session_id" "$section_element")
    shadow=$(echo "$response" | sed 's/.*"shadow-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(find_element_from_shadow_root http://localhost:4444 "$session_id" "$shadow" '{"using":"css selector", "value":"span"}')
    span=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')

    [ -n "$span" ]
}

test_find_elements_from_shadow_root() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"section"}')
    section_element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(get_element_shadow_root http://localhost:4444 "$session_id" "$section_element")
    shadow=$(echo "$response" | sed 's/.*"shadow-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(find_elements_from_shadow_root http://localhost:4444 "$session_id" "$shadow" '{"using":"css selector", "value":"span"}')
    span=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')

    [ -n "$shadow" ]
}

test_get_active_element() {
    response=$(get_active_element http://localhost:4444 "$session_id")
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    
    [ -n "$element" ]
}

test_get_element_shadow_root() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"section"}')
    section_element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(get_element_shadow_root http://localhost:4444 "$session_id" "$section_element")
    shadow=$(echo "$response" | sed 's/.*"shadow-.[^"]*":"\(.[^"]*\)".*/\1/g')

    [ -n "$shadow" ]
}

test_is_element_selected() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"section"}')
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(is_element_selected http://localhost:4444 "$session_id" "$element")
    value=$(echo "$response" | sed 's/.*"value":\(true\|false\).*/\1/g')

    [ "$value" = "false" ]
}

test_get_element_attribute() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"p"}')
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(get_element_attribute http://localhost:4444 "$session_id" "$element" id)
    value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')

    [ "$value" = "text" ]
}

test_get_element_property() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"p"}')
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(get_element_property http://localhost:4444 "$session_id" "$element" textContent)
    value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')

    [ "$value" = "hello world" ]
}

test_get_element_css_value() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"p"}')
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(get_element_css_value http://localhost:4444 "$session_id" "$element" color)
    value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')

    [ "$value" = "rgb(0, 0, 0)" ]
}

test_get_element_text() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"p"}')
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(get_element_text http://localhost:4444 "$session_id" "$element")
    value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')

    [ "$value" = "hello world" ]
}

test_get_element_tag_name() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"p"}')
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(get_element_tag_name http://localhost:4444 "$session_id" "$element")
    value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')

    [ "$value" = "p" ]
}

test_get_element_rect() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"p"}')
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(get_element_rect http://localhost:4444 "$session_id" "$element")
    height=$(echo "$response" | sed 's/.*"height":\([0-9.]\+\).*/\1/g')

    [ "$height" = "22.0" ]
}

test_is_element_enabled() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"p"}')
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(is_element_enabled http://localhost:4444 "$session_id" "$element")
    value=$(echo "$response" | sed 's/.*"value":\(true\|false\).*/\1/g')

    [ "$value" = "true" ]
}

test_get_computed_role() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"p"}')
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(get_computed_role http://localhost:4444 "$session_id" "$element")
    value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')

    [ "$value" = "paragraph" ]
}

test_get_computed_label() {
    response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"input"}')
    element=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')
    response=$(get_computed_label http://localhost:4444 "$session_id" "$element")
    value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')

    [ "$value" = "First Name" ]
}

#test "8. Sessions - 8.2 New Session"  test_new_session
#test "8. Sessions - 8.3 Delete Session"  test_delete_session
#test "8. Sessions - 8.4 Status"  test_status
#create_session
#test "9. Sessions - 9.1 Get Timeouts"  test_get_timeouts
#test "9. Sessions - 9.2 Set Timeouts"  test_set_timeouts
#test "10. Navigation - 10.1 Navigate To" test_navigate_to
#test "10. Navigation - 10.2 Get Current URL" test_get_current_url
#test "10. Navigation - 10.3 Back" test_back
#test "10. Navigation - 10.4 Forward" test_forward
#test "10. Navigation - 10.5 Refresh" test_refresh
#test "10. Navigation - 10.6 Get Title" test_get_title
#test "11. Contexts - 11.1 Get Window Handle" test_get_window_handle
#test "11. Contexts - 11.2 Close Window" test_close_window
#create_session
#test "11. Contexts - 11.3 Switch To Window" test_switch_to_window
#test "11. Contexts - 11.4 Get Window Handles" test_get_window_handles
#test "11. Contexts - 11.5 New Window" test_new_window
#test "11. Contexts - 11.6 Switch To Frame" test_switch_to_frame
#test "11. Contexts - 11.7 Switch To Parent Frame" test_switch_to_parent_frame
#test "11. Contexts - 11.8.1 Get Window Rect" test_get_window_rect
#test "11. Contexts - 11.8.2 Set Window Rect" test_set_window_rect
#test "11. Contexts - 11.8.3 Maximize Window" test_maximize_window
#test "11. Contexts - 11.8.4 Minimize Window" test_minimize_window
#test "11. Contexts - 11.8.5 Fullscreen Window" test_fullscreen_window
#test "12. Elements - 12.3.2 Find Element" test_find_element
#test "12. Elements - 12.3.3 Find Elements" test_find_elements
#test "12. Elements - 12.3.4 Find Element From Element" test_find_element_from_element
#test "12. Elements - 12.3.5 Find Elements From Element" test_find_elements_from_element
#test "12. Elements - 12.3.6 Find Element From Shadow Root" test_find_element_from_shadow_root
#test "12. Elements - 12.3.7 Find Elements From Shadow Root" test_find_elements_from_shadow_root
#test "12. Elements - 12.3.8 Get Active Element" test_get_active_element
#test "12. Elements - 12.4.1 Is Element Selected" test_is_element_selected
#test "12. Elements - 12.4.2 Get Element Attribute" test_get_element_attribute
#test "12. Elements - 12.4.3 Get Element Property" test_get_element_property
#test "12. Elements - 12.4.4 Get Element CSS Value" test_get_element_css_value
#test "12. Elements - 12.4.5 Get Element Text" test_get_element_text
#test "12. Elements - 12.4.6 Get Element Tag Name" test_get_element_tag_name
create_session; visit_index
test "12. Elements - 12.4.7 Get Element Rect" test_get_element_rect
test "12. Elements - 12.4.8 Is Element Enabled" test_is_element_enabled
test "12. Elements - 12.4.9 Get Computed Role" test_get_computed_role
test "12. Elements - 12.4.10 Get Computed Label" test_get_computed_label

