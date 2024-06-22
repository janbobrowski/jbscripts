#!/bin/bash

DESCRIPTION="\
Transforms JSON to the stream of [<path>, <leaf-value>] which is also a JSON.
Reads from the standard input.
"

if [ "${1:0:1}" == "-" ]; then
    printf "${DESCRIPTION}" >&2
    exit 0
fi

if !(which jq &>/dev/null); then
  echo please install jq
  exit 1
fi

jq  -r --stream 'select(length==2)|tostring' | jq -c
