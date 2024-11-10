#!/usr/bin/env sh

./check.sh

. ./webdriver-client.sh

status http://localhost:4444

response=$(new_session http://localhost:4444 '{"capabilities": { "browserName": "icecat" } }')

session_id=$(echo "$response" | sed 's/.*"sessionId":"\(.[^"]*\)".*/\1/g')

set_timeouts http://localhost:4444 "$session_id" '{"script":999999, "pageLoad":999999, "implicit":999999}'

get_timeouts http://localhost:4444 "$session_id"

navigate_to http://localhost:4444 "$session_id" '{"url":"https://www.gnu.org"}'

delete_session http://localhost:4444 "$session_id"

