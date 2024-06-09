#!/bin/bash

output_script_name=script.py

help()
{
  THIS_SCRIPT_NAME=$(basename "$0")
  echo "Creates python script with shebang line and 755 permissions" >&2
  echo "Usage: ./$THIS_SCRIPT_NAME [output_script_name=$output_script_name]" >&2
}

if [ "${1:0:1}" == "-" ]; then
    help
    exit 0
fi

if (( "${#}" > 0 )); then
  output_script_name="${1}"
else
  echo "Using default script name: $output_script_name"
fi

if [ -f "${output_script_name}" ]; then
  echo "Script ${output_script_name}" already exists
  exit 0
fi

jq -nr '"#!/usr/bin/python3"' | install --mod=755 /dev/stdin "${output_script_name}"

echo "Created script ${output_script_name}"
