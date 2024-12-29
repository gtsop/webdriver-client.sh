#!/usr/bin/env sh
cd "$(dirname "$0")" || exit 1

. ../spec/test-utils.sh
. ../src/webdriver-client.sh

echo_server 4444
trap kill_echo_server EXIT INT TERM

session_id="aSession"
element="anElement"
shadow="aShadow"

test_new_session() {
    expect_http_response \
        "new_session http://localhost:4444 {\"capabilities\":{\"browserName\":\"icecat\"}}" \
        "POST /session HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 41

        {\"capabilities\":{\"browserName\":\"icecat\"}}"
}

test_delete_session() {
    expect_http_response \
        "delete_session http://localhost:4444 $session_id" \
        "DELETE /session/aSession HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_status() {
    expect_http_response \
        "status http://localhost:4444" \
        "GET /status HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_get_timeouts() {
    expect_http_response \
        "get_timeouts http://localhost:4444 $session_id" \
        "GET /session/aSession/timeouts HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_set_timeouts() {
    expect_http_response \
        "set_timeouts http://localhost:4444 $session_id {\"script\":9999}" \
        "POST /session/aSession/timeouts HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 15

         {\"script\":9999}"
}

test_navigate_to() {
    expect_http_response \
        "navigate_to http://localhost:4444 $session_id {\"url\":\"file://$(pwd)/index.html\"}" \
        "POST /session/aSession/url HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 89

         {\"url\":\"file://$(pwd)/index.html\"}"
}

test_get_current_url() {
    expect_http_response \
        "get_current_url http://localhost:4444 $session_id" \
        "GET /session/aSession/url HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_back() {
    expect_http_response \
        "back http://localhost:4444 aSession" \
        "POST /session/aSession/back HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 2

         {}"
}

test_forward() {
expect_http_response \
        "forward http://localhost:4444 aSession" \
        "POST /session/aSession/forward HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 2

         {}"
}

test_refresh() {
    expect_http_response \
        "refresh http://localhost:4444 aSession" \
        "POST /session/aSession/refresh HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 2

         {}"
}

test_get_title() {
    expect_http_response \
        "get_title http://localhost:4444 aSession" \
        "GET /session/aSession/title HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_get_window_handle() {
    expect_http_response \
        "get_window_handle http://localhost:4444 aSession" \
        "GET /session/aSession/window HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_close_window() {
    expect_http_response \
        "close_window http://localhost:4444 aSession" \
        "DELETE /session/aSession/window HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_switch_to_window() {
    expect_http_response \
        "switch_to_window http://localhost:4444 aSession {\"foo\":\"bar\"}" \
        "POST /session/aSession/window HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test_get_window_handles() {
    expect_http_response \
        "get_window_handles http://localhost:4444 aSession" \
        "GET /session/aSession/window/handles HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_new_window() {
    expect_http_response \
        "new_window http://localhost:4444 aSession" \
        "POST /session/aSession/window/new HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 2

         {}"
}

test_switch_to_frame() {
    expect_http_response \
        "switch_to_frame http://localhost:4444 aSession {\"foo\":\"bar\"}" \
        "POST /session/aSession/frame HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test_switch_to_parent_frame() {
    expect_http_response \
        "switch_to_parent_frame http://localhost:4444 aSession" \
        "POST /session/aSession/frame/parent HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 2

         {}"
}

test_get_window_rect() {
    expect_http_response \
        "get_window_rect http://localhost:4444 aSession" \
        "GET /session/aSession/window/rect HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_set_window_rect() {
    expect_http_response \
        "set_window_rect http://localhost:4444 aSession {\"foo\":\"bar\"}" \
        "POST /session/aSession/window/rect HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test_maximize_window() {
    expect_http_response \
        "maximize_window http://localhost:4444 aSession" \
        "POST /session/aSession/window/maximize HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 2

         {}"
}

test_minimize_window() {
    expect_http_response \
        "minimize_window http://localhost:4444 aSession" \
        "POST /session/aSession/window/minimize HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 2

         {}"
}

test_fullscreen_window() {
    expect_http_response \
        "fullscreen_window http://localhost:4444 aSession" \
        "POST /session/aSession/window/fullscreen HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 2

         {}"
}

test_find_element() {
    expect_http_response \
        "find_element http://localhost:4444 aSession {\"foo\":\"bar\"}" \
        "POST /session/aSession/element HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test_find_elements() {
    expect_http_response \
        "find_elements http://localhost:4444 aSession {\"foo\":\"bar\"}" \
        "POST /session/aSession/elements HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test_find_element_from_element() {
    expect_http_response \
        "find_element_from_element http://localhost:4444 aSession anElement {\"foo\":\"bar\"}" \
        "POST /session/aSession/element/anElement/element HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test_find_elements_from_element() {
    expect_http_response \
        "find_elements_from_element http://localhost:4444 aSession anElement {\"foo\":\"bar\"}" \
        "POST /session/aSession/element/anElement/elements HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test_find_element_from_shadow_root() {
    expect_http_response \
        "find_element_from_shadow_root http://localhost:4444 aSession aShadow {\"foo\":\"bar\"}" \
        "POST /session/aSession/shadow/aShadow/element HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test_find_elements_from_shadow_root() {
    expect_http_response \
        "find_elements_from_shadow_root http://localhost:4444 aSession aShadow {\"foo\":\"bar\"}" \
        "POST /session/aSession/shadow/aShadow/elements HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test_get_active_element() {
    expect_http_response \
        "get_active_element http://localhost:4444 aSession" \
        "GET /session/aSession/element/active HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_get_element_shadow_root() {
    expect_http_response \
        "get_element_shadow_root http://localhost:4444 aSession anElement" \
        "GET /session/aSession/element/anElement/shadow HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_is_element_selected() {
    expect_http_response \
        "is_element_selected http://localhost:4444 aSession anElement" \
        "GET /session/aSession/element/anElement/selected HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_get_element_attribute() {
    expect_http_response \
        "get_element_attribute http://localhost:4444 aSession anElement id" \
        "GET /session/aSession/element/anElement/attribute/id HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_get_element_property() {
    expect_http_response \
        "get_element_property http://localhost:4444 aSession anElement textContent" \
        "GET /session/aSession/element/anElement/property/textContent HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_get_element_css_value() {
    expect_http_response \
        "get_element_css_value http://localhost:4444 aSession anElement color" \
        "GET /session/aSession/element/anElement/css/color HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_get_element_text() {
    expect_http_response \
        "get_element_text http://localhost:4444 aSession anElement" \
        "GET /session/aSession/element/anElement/text HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_get_element_tag_name() {
    expect_http_response \
        "get_element_tag_name http://localhost:4444 aSession anElement" \
        "GET /session/aSession/element/anElement/name HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_get_element_rect() {
    expect_http_response \
        "get_element_rect http://localhost:4444 aSession anElement" \
        "GET /session/aSession/element/anElement/rect HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_is_element_enabled() {
    expect_http_response \
        "is_element_enabled http://localhost:4444 aSession anElement" \
        "GET /session/aSession/element/anElement/enabled HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_get_computed_role() {
    expect_http_response \
        "get_computed_role http://localhost:4444 aSession anElement" \
        "GET /session/aSession/element/anElement/computedrole HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_get_computed_label() {
    expect_http_response \
        "get_computed_label http://localhost:4444 aSession anElement" \
        "GET /session/aSession/element/anElement/computedlabel HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_element_click() {
    expect_http_response \
        "element_click http://localhost:4444 aSession anElement" \
        "POST /session/aSession/element/anElement/click HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 2

         {}"
}

test_element_clear() {
    expect_http_response \
        "element_clear http://localhost:4444 aSession anElement" \
        "POST /session/aSession/element/anElement/clear HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 2

         {}"
}

test_element_send_keys() {
    expect_http_response \
        "element_send_keys http://localhost:4444 aSession anElement {\"foo\":\"bar\"}" \
        "POST /session/aSession/element/anElement/value HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test_get_page_source() {
    expect_http_response \
        "get_page_source http://localhost:4444 aSession" \
        "GET /session/aSession/source HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_execute_script() {
    expect_http_response \
        "execute_script http://localhost:4444 aSession {\"foo\":\"bar\"}" \
        "POST /session/aSession/execute/sync HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test_execute_async_script() {
    expect_http_response \
        "execute_async_script http://localhost:4444 aSession {\"foo\":\"bar\"}" \
        "POST /session/aSession/execute/async HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test_get_all_cookies() {
    expect_http_response \
        "get_all_cookies http://localhost:4444 aSession" \
        "GET /session/aSession/cookie HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_get_named_cookie() {
    expect_http_response \
        "get_named_cookie http://localhost:4444 aSession foo" \
        "GET /session/aSession/cookie/foo HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_add_cookie() {
    expect_http_response \
        "add_cookie http://localhost:4444 aSession {\"foo\":\"bar\"}" \
        "POST /session/aSession/cookie HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test_perform_actions() {
    expect_http_response \
        "perform_actions http://localhost:4444 aSession {\"foo\":\"bar\"}" \
        "POST /session/aSession/actions HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test_release_actions() {
    expect_http_response \
        "release_actions http://localhost:4444 aSession" \
        "DELETE /session/aSession/actions HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_dismiss_alert() {
    expect_http_response \
        "dismiss_alert http://localhost:4444 aSession" \
        "POST /session/aSession/alert/dismiss HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 2

         {}"
}

test_accept_alert() {
    expect_http_response \
        "accept_alert http://localhost:4444 aSession" \
        "POST /session/aSession/alert/accept HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 2

         {}"
}

test_get_alert_text() {
    expect_http_response \
        "get_alert_text http://localhost:4444 aSession" \
        "GET /session/aSession/alert/text HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive"
}

test_send_alert_text() {
    expect_http_response \
        "send_alert_text http://localhost:4444 aSession {\"foo\":\"bar\"}" \
        "POST /session/aSession/alert/text HTTP/1.1
         Host: localhost:4444
         Accept: */*
         Accept-Encoding: identity
         Connection: Keep-Alive
         Content-Type: application/json
         Content-Length: 13

         {\"foo\":\"bar\"}"
}

test "new_session" test_new_session
test "delete_session"  test_delete_session
test "status"  test_status
test "get_timeouts"  test_get_timeouts
test "set_timeouts"  test_set_timeouts
test "navigate_to" test_navigate_to
test "get_current_url" test_get_current_url
test "back" test_back
test "forward" test_forward
test "refresh" test_refresh
test "get_title" test_get_title
test "get_window_handle" test_get_window_handle
test "close_window" test_close_window
test "switch_to_window" test_switch_to_window
test "get_window_handles" test_get_window_handles
test "new_window" test_new_window
test "switch_to_frame" test_switch_to_frame
test "switch_to_parent_frame" test_switch_to_parent_frame
test "get_window_rect" test_get_window_rect
test "set_window_rect" test_set_window_rect
test "maximize_window" test_maximize_window
test "minimize_window" test_minimize_window
test "fullscreen_window" test_fullscreen_window
test "find_element" test_find_element
test "find_elements" test_find_elements
test "find_element_from_element" test_find_element_from_element
test "find_elements_from_element" test_find_elements_from_element
test "find_element_from_shadow_root" test_find_element_from_shadow_root
test "find_elements_from_shadow_root" test_find_elements_from_shadow_root
test "get_active_element" test_get_active_element
test "get_element_shadow_root" test_get_element_shadow_root
test "is_element_selected" test_is_element_selected
test "get_element_attribute" test_get_element_attribute
test "get_element_property" test_get_element_property
test "get_element_css_value" test_get_element_css_value
test "get_element_text" test_get_element_text
test "get_element_tag_name" test_get_element_tag_name
test "get_element_rect" test_get_element_rect
test "is_element_enabled" test_is_element_enabled
test "get_computed_role" test_get_computed_role
test "get_computed_label" test_get_computed_label
test "element_click" test_element_click
test "element_clear" test_element_clear
test "element_send_keys" test_element_send_keys
test "get_page_source" test_get_page_source
test "execute_script" test_execute_script
test "execute_async_script" test_execute_async_script
test "get_all_cookies" test_get_all_cookies
test "get_named_cookie" test_get_named_cookie
test "add_cookie" test_add_cookie
test "perform_actions" test_perform_actions
test "release_actions" test_release_actions
test "dismiss_alert" test_dismiss_alert
test "accept_alert" test_accept_alert
test "get_alert_text" test_get_alert_text
test "send_alert_text" test_send_alert_text
