#!/bin/bash

DESCRIPTION="\
Creates a python script with shebang line and 755 permissions
"

default_script_name=script.py

usage()
{
  THIS_SCRIPT_NAME=$(basename "$0")
  echo "Usage: ./$THIS_SCRIPT_NAME [output_script_name=$default_script_name]" >&2
}

if [ "${1:0:1}" == "-" ]; then
    printf "${DESCRIPTION}" >&2
    usage
    exit 0
fi

if !(which jq &>/dev/null); then
  echo please install jq
  exit 1
fi

if (( "${#}" > 0 )); then
  output_script_name="${1}"
else
  output_script_name=$default_script_name
  echo "Using default script name: $output_script_name"
fi

if [ -f "${output_script_name}" ]; then
  echo "Script ${output_script_name}" already exists
  exit 0
fi

jq -nr '"#!/usr/bin/python3"' | install --mod=755 /dev/stdin "${output_script_name}"

echo "Created script ${output_script_name}"
