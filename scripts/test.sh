#!/usr/bin/env sh
set -e

cd "$(dirname "$0")"

( ./lint.sh )

find ../src -name "*.test.sh" -exec sh {} +

( ../spec/acceptance.sh )
