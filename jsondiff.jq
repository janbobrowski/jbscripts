#!/usr/bin/env -S jq -fs

# script compares two first values from the input stream (other values are ignored)
# for the objects with similar structure
# it shows differences as a singe object:
# $ jq -n '{a:1,b:2,c:[3]},{b:2,c:3,d:4}' | ./jsondiff.jq -c
# {"a":[1],"c":[[3],3],"d":[null,4]}
# if it is not possible differences are shown as two objects:
# $ jq -n '{a:1,b:2,c:3},{b:2,c:[3],d:4}' | ./jsondiff.jq -c
# {"a":1,"c":3}
# {"c":[3],"d":4}

# function transforms json value into stream of path-value pairs using tostream
# and appends given number (0 or 1) to each path in that stream
# it's like every leaf_value in the first object would be substituted
#   with [leaf_value]
# and every leaf_value in the second object would be substituted
#   with [null,leaf_value]
def create_compare_stream($n):
[
  tostream
  |select(length==2)
  |.[0]+=[$n]
]
;

# function is used when different values cannot be combined
# into single object (fromstream fails)
# function takes an array with path-value pairs as an input,
# gets only pairs having path ending with given number
# and removes that number from path of selected pairs
def filter_compare_stream($n):
  map(
      select(.[0][-1]==$n)
      |.[0]|=.[:-1]
    )
;

# this line is for performance only, rest of the code
# would return no values for equal objects
if .[0] == .[1] then empty else
# create streams of values from input and combine
(.[0]|create_compare_stream(0)) + (.[1]|create_compare_stream(1))
# group by the original path (without added 0 and 1)
|group_by(.[0][:-1])
|map(
  # select only different values
  select(.[0][1] != .[1][1])
  |.[]
)
as $diffstream
| try
  # transform the stream of selected path-value pairs (with different values for matching keys)
  # back into single object (keys in the object will be sorted alpabetically)
  fromstream($diffstream[],[[[]]])
  catch (
    # if creating single object fails (leaf value paths do not match)
    # two objects are created:
    # first object with only different values, then second object with only different values
    $diffstream
    |(filter_compare_stream(0),filter_compare_stream(1))
    | fromstream(.[],[[[]]])
  )
end
