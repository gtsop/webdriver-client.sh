#!/usr/bin/env sh

./check.sh

. ./webdriver-client.sh

echo ""
echo "=== 12. Elements"
echo ""

response=$(new_session http://localhost:4444 '{"capabilities": { "browserName": "icecat" } }')
session_id=$(echo "$response" | sed 's/.*"sessionId":"\(.[^"]*\)".*/\1/g')

navigate_to http://localhost:4444 "$session_id" '{"url":"https://www.gnu.org"}'; echo "";

find_elements http://localhost:4444 "$session_id" '{"using":"css selector", "value":"a"}'; echo ""

response=$(find_element http://localhost:4444 "$session_id" '{"using":"css selector", "value":"#navigation"}');
echo "$response"
element_id=$(echo "$response" | sed 's/.*"element-.[^"]*":"\(.[^"]*\)".*/\1/g')

find_element_from_element http://localhost:4444 "$session_id" "$element_id" '{"using":"css selector", "value":"ul"}'; echo ""
find_elements_from_element http://localhost:4444 "$session_id" "$element_id" '{"using":"css selector", "value":"a"}'; echo ""

delete_session http://localhost:4444 "$session_id"; echo "";

exit

echo ""
echo "=== 8. Sessions";
echo ""

status http://localhost:4444; echo "";

response=$(new_session http://localhost:4444 '{"capabilities": { "browserName": "icecat" } }')
echo "$response";

session_id=$(echo "$response" | sed 's/.*"sessionId":"\(.[^"]*\)".*/\1/g')

echo ""
echo "=== 9. Timeouts"
echo ""

set_timeouts http://localhost:4444 "$session_id" '{"script":999999, "pageLoad":999999, "implicit":999999}'; echo "";

get_timeouts http://localhost:4444 "$session_id"; echo "";

echo ""
echo "=== 10. Navigation"
echo ""

navigate_to http://localhost:4444 "$session_id" '{"url":"https://www.gnu.org"}'; echo "";

navigate_to http://localhost:4444 "$session_id" '{"url":"https://www.gnu.org/gnu/gnu.html"}'; echo "";

back http://localhost:4444 "$session_id"; echo "";

get_current_url http://localhost:4444 "$session_id"; echo "";

forward http://localhost:4444 "$session_id"; echo "";

get_current_url http://localhost:4444 "$session_id"; echo "";

refresh http://localhost:4444 "$session_id"; echo "";

get_title http://localhost:4444 "$session_id"; echo "";

echo ""
echo "==== 11. Contexts"
echo ""


set_window_rect http://localhost:4444 "$session_id" '{"x":100,"y":50,"width":500,"height":500}'; echo ""
get_window_rect http://localhost:4444 "$session_id"; echo ""
fullscreen_window http://localhost:4444 "$session_id"; echo ""
minimize_window http://localhost:4444 "$session_id"; echo ""
maximize_window http://localhost:4444 "$session_id"; echo ""

switch_to_frame http://localhost:4444 "$session_id" '{"id": null}'; echo ""
switch_to_parent_frame http://localhost:4444 "$session_id"; echo ""

get_window_handles http://localhost:4444 "$session_id"; echo ""

response=$(get_window_handle http://localhost:4444 "$session_id");
echo "$response";

handle_id=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')

new_window http://localhost:4444 "$session_id"; echo ""

switch_window http://localhost:4444 "$session_id" "{\"handle\":\"$handle_id\"}"; echo "";

close_window http://localhost:4444 "$session_id"; echo "";

delete_session http://localhost:4444 "$session_id"; echo "";


