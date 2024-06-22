#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo provide single argument: file name
  exit 1
fi

file_name=$1

if [ ! -f "${file_name}" ]; then
  echo file "${file_name}" does not exist
  exit 1
fi

sed -i 's/\r$//' "${file_name}" # removing carriage return from the end of each line
