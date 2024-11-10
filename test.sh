#!/usr/bin/env sh

./check.sh

. ./webdriver-client.sh

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


