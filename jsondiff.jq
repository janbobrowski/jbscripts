#!/usr/bin/jq -fs
# script compares objects from the input stream (two first objects, the rest is ignored)
# script reads input into an array (jq -s parameter)
# for the objects with similar structure (matching leaf values)
# it shows differences as a singe object
# $ jq -n '{a:1,b:2},{b:22,c:33}' | ./jsondiff.jq | jq -c
# {"a":[1],"b":[2,22],"c":[null,33]}
# if it is not possible differences are shown as two objects
# jq -n '{a:1,b:2},{b:[22],c:33}' | ./jsondiff.jq | jq -c
# {"a":1,"b":2}
# {"b":[22],"c":33}

# function transforms nth object from the input array into the json stream (path-value pairs)
# n is either 0 (the first object) or 1 (for the second object)
# so 0 is aded to every path of the first object and 1 to every path of the second object
# it's like every leaf_value in the first object would be substituted
#   with an array having the leaf_value on the first position: [leaf_value]
# and every leaf_value in the second object
#   with an array having the leaf_value on the second position [null,leaf_value]
def create_stream($n):
[
  .[$n]
  |tostream
  |select(length==2)
  |.[0]+=[$n]
]
;
create_stream(0) as $s0
|create_stream(1) as $s1

# combine the input streams together
|$s0+$s1
# group by the original path (without added 0 and 1)
|group_by(.[0][:-1])
|map(
  # select only different values
  select(.[0][1] != .[1][1])
) as $diffstream
# transform the stream of path-value pairs back into the object (keys in the object will be sorted alpabetically)
| try
  fromstream($diffstream[][],[[[]]])
  catch (
    $diffstream|
    (
      map(map(
          select(.[0][-1]==0)
          |.[0]|=.[:-1]
        )),
      map(map(
          select(.[0][-1]==1)
          |.[0]|=.[:-1]
        ))
    ) | fromstream(.[][],[[[]]])
  )
