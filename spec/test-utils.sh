#!/usr/bin/env sh

port=""
kill_echo_server() {
    pkill -f "socat.*$port"
}

_echo_handler() {
    length="0"
    while read -r line; do
        echo $line;

        if echo "$line" | grep -q "^Content-Length"; then
            length=$(echo $line | sed 's/^Content-Length: //g')
            length=$(echo $length | sed 's/\r//g')
        fi
        [ "$line" = $'\r' ] && break;
    done;

    if [ "$length" -gt "0" ]; then
        head -c $length
    fi
}
export -f _echo_handler

echo_server() {
    port=$1
    kill_echo_server "$port"
    socat TCP-LISTEN:"$port",fork,reuseaddr,end-close SYSTEM:'_echo_handler' > /dev/null 2>&1 &
}

clean_response() {
    echo "$@" | cat -v | sed 's/^[[:space:]]*//g' | sed 's/\^M$//g'
}

expect_http_response() {
    request=$1
    expected_response="$2"

    response=$($request)

    response=$(clean_response "$response")
    expected_response=$(clean_response "$expected_response")

    if [ "$response" = "$expected_response" ]; then
        return 0
    else
        echo ""
        echo "========================================="
        echo "Expectation failed for request: $request"
        echo "Expected:"
        echo "$expected_response"
        echo "---"
        echo "Received:"
        echo "$response"
        echo "========================================="
        echo "Correct expectation:"
        echo "
    expect_http_response \\
        \"$request\" \\
        \"$response\" "

        return 1
    fi
}

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
