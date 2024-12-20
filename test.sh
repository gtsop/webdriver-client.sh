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

######################################################################

echo -n "[TEST] 8. Sessions - 8.2 New Session"
response=$(new_session http://localhost:4444 '{"capabilities": { "browserName": "icecat" } }')
session_id=$(echo "$response" | sed 's/.*"sessionId":"\(.[^"]*\)".*/\1/g')
if [ -z $session_id ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 8. Sessions - 8.3 Delete Session"
response=$( delete_session http://localhost:4444 "$session_id")
value=$(echo "$response" | sed 's/.*"value":\(null\).*/\1/g')
if [ "$value" != "null" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 8. Sessions - 8.4 Status"
response=$(status "http://localhost:4444")
is_ready=$(echo "$response" | sed 's/.*"ready":\(true\|false\).*/\1/g')
if [ "$is_ready" != "true" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 9. Sessions - 9.1 Get Timeouts"
response=$(new_session http://localhost:4444 '{"capabilities": { "browserName": "icecat" } }')
session_id=$(echo "$response" | sed 's/.*"sessionId":"\(.[^"]*\)".*/\1/g')
response=$(set_timeouts http://localhost:4444 "$session_id" '{"script":9999}')
response=$(get_timeouts http://localhost:4444 "$session_id")
script_timeout=$(echo "$response" | sed 's/.*"script":\([0-9]\+\).*/\1/g')
if [ "$script_timeout" != "9999" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 9. Sessions - 9.2 Set Timeouts"
response=$(set_timeouts http://localhost:4444 "$session_id" '{"script":9999}')
response=$(get_timeouts http://localhost:4444 "$session_id")
script_timeout=$(echo "$response" | sed 's/.*"script":\([0-9]\+\).*/\1/g')
if [ "$script_timeout" != "9999" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 10. Navigation - 10.1 Navigate To"
response=$(navigate_to http://localhost:4444 "$session_id" "{\"url\":\"file://$(pwd)/index.html\"}")
value=$(echo "$response" | sed 's/.*"value":\(null\).*/\1/g')
if [ "$value" != "null" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 10. Navigation - 10.2 Get Current URL"
response=$(get_current_url http://localhost:4444 "$session_id")
value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')
if [ "$value" != "file://$(pwd)/index.html" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 10. Navigation - 10.3 Back"
response=$(navigate_to http://localhost:4444 "$session_id" "{\"url\":\"file://$(pwd)/index.html#foo\"}")
response=$(back http://localhost:4444 "$session_id")
response=$(get_current_url http://localhost:4444 "$session_id")
value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')
if [ "$value" != "file://$(pwd)/index.html" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 10. Navigation - 10.4 Forward"
response=$( forward http://localhost:4444 "$session_id")
response=$(get_current_url http://localhost:4444 "$session_id")
value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')
if [ "$value" != "file://$(pwd)/index.html#foo" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 10. Navigation - 10.5 Refresh"
response=$(refresh http://localhost:4444 "$session_id")
value=$(echo "$response" | sed 's/.*"value":\(null\).*/\1/g')
if [ "$value" != "null" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 10. Navigation - 10.6 Get Title"
response=$(get_title http://localhost:4444 "$session_id")
value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')
if [ "$value" != "Title" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 11. Contexts - 11.1 Get Window Handle"
response=$(get_window_handle http://localhost:4444 "$session_id")
value=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')
if [ -z "$value" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 11. Contexts - 11.2 Close Window"
response=$(close_window http://localhost:4444 "$session_id")
value=$(echo "$response" | sed 's/.*"value":\[\(.*\)\].*/\1/g')
if [ -n "$value" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

create_session

echo -n "[TEST] 11. Contexts - 11.3 Switch To Window"
response=$(get_window_handle http://localhost:4444 "$session_id")
window_handle=$(echo "$response" | sed 's/.*"value":"\(.[^"]*\)".*/\1/g')
response=$(switch_to_window http://localhost:4444 "$session_id" "{\"handle\": \"$window_handle\"}")
value=$(echo "$response" | sed 's/.*"value":\(null\).*/\1/g')
if [ "$value" != "null" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 11. Contexts - 11.4 Get Window Handles"
response=$(get_window_handles http://localhost:4444 "$session_id")
value=$(echo "$response" | sed 's/.*"value":\["\(.*\)"\].*/\1/g')
if [ -z "$value" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 11. Contexts - 11.5 New Window"
response=$(new_window http://localhost:4444 "$session_id")
value=$(echo "$response" | sed 's/.*"handle":"\(.[^"]*\)".*/\1/g')
if [ -z "$value" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 11. Contexts - 11.6 Switch To Frame"
response=$(switch_to_frame http://localhost:4444 "$session_id" '{"id":null}')
value=$(echo "$response" | sed 's/.*"value":\(null\).*/\1/g')
if [ -z "$value" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 11. Contexts - 11.7 Switch To Parent Frame"
response=$(switch_to_parent_frame http://localhost:4444 "$session_id" '{"id":null}')
value=$(echo "$response" | sed 's/.*"value":\(null\).*/\1/g')
if [ -z "$value" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 11. Contexts - 11.8.1 Get Window Rect"
response=$(get_window_rect http://localhost:4444 "$session_id")
width=$(echo "$response" | sed 's/.*"width":\([0-9]\+\).*/\1/g')
if [ "$width" != "1280" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 11. Contexts - 11.8.2 Set Window Rect"
response=$(set_window_rect http://localhost:4444 "$session_id" '{"x":100,"y":50,"width":500,"height":500}')
response=$(get_window_rect http://localhost:4444 "$session_id")
width=$(echo "$response" | sed 's/.*"width":\([0-9]\+\).*/\1/g')
if [ "$width" != "500" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 11. Contexts - 11.8.3 Maximize Window"
response=$(maximize_window http://localhost:4444 "$session_id")
x=$(echo "$response" | sed 's/.*"x":\([0-9]\+\).*/\1/g')
if [ "$x" != "0" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

echo -n "[TEST] 11. Contexts - 11.8.4 Minimize Window"
response=$(minimize_window http://localhost:4444 "$session_id")
width=$(echo "$response" | sed 's/.*"width":\([0-9]\+\).*/\1/g')
if [ "$width" -gt "600" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

clear_session
create_session

echo -n "[TEST] 11. Contexts - 11.8.5 Fullscreen Window"
response=$(fullscreen_window http://localhost:4444 "$session_id")
x=$(echo "$response" | sed 's/.*"x":\([0-9]\+\).*/\1/g')
if [ "$x" != "0" ]; then
    echo " FAIL"
    exit
fi
echo " OK"

exit


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


