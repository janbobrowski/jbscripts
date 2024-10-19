#!/usr/bin/jq -fs

def create_compare_stream($n):
[
  # transform json value into stream of path-value pairs
  tostream
  |select(length==2)
  # append given number (0 or 1) to each path in that stream
  |.[0]+=[$n]
];
# this line creates single array with path-value pairs from both input values
(.[0]|create_compare_stream(0)) + (.[1]|create_compare_stream(1))
# group by the original path (without added 0 and 1)
|group_by(.[0][:-1])
|map(
  # select only different values with the same path
  select(.[0][1] != .[1][1])
  |.[]
)
# transform back the stream of path-value pairs into single json
| fromstream(.[],[[[]]])
