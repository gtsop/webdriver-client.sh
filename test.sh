#!/usr/bin/env sh

./check.sh

. ./webdriver-client.sh

status http://localhost:4444; echo "";

response=$(new_session http://localhost:4444 '{"capabilities": { "browserName": "icecat" } }')

session_id=$(echo "$response" | sed 's/.*"sessionId":"\(.[^"]*\)".*/\1/g')

set_timeouts http://localhost:4444 "$session_id" '{"script":999999, "pageLoad":999999, "implicit":999999}'; echo "";

get_timeouts http://localhost:4444 "$session_id"; echo "";

navigate_to http://localhost:4444 "$session_id" '{"url":"https://www.gnu.org"}'; echo "";

get_current_url http://localhost:4444 "$session_id"; echo "";

navigate_to http://localhost:4444 "$session_id" '{"url":"https://www.gnu.org/gnu/gnu.html"}'; echo "";

get_current_url http://localhost:4444 "$session_id"; echo "";

back http://localhost:4444 "$session_id"; echo "";

get_current_url http://localhost:4444 "$session_id"; echo "";

delete_session http://localhost:4444 "$session_id"; echo "";

