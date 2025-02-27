#!/usr/bin/env -S jq -fRrn

# read input lines as an array
[inputs]
|sort_by(
  # extract name and version
  match("[0-9]+[0-9.]*";"").offset  as $version_index
  |.[:$version_index] as $name
  |.[$version_index:]
  # ignore build
  |split("+")[0]
  # extract version core and pre-release as arrays of numbers and strings
  |split("-")
  |(.[0]|split(".")|map(tonumber? // .)) as $version_core
  |(.[1:]|join("-")|split(".")|map(tonumber? // .)) as $pre_release
  # sort by name
  |$name,
  # sort by version core
  $version_core,
  # pre-release versions have a lower precedence than the associated normal version
  ($pre_release|length)==0,
  # sort by pre-release
  $pre_release
)
#extract values from an array
|.[]
