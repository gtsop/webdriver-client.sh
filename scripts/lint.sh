#!/usr/bin/env sh
cd "$(dirname "$0")" || exit 1

find ../ -name "*.sh"   -exec shellcheck --shell=sh   {} +
find ../ -name "*.bash" -exec shellcheck --shell=bash {} +
