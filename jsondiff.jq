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

# function transforms input into json stream (path-value pairs)
# and appends n to each path
# it's like every leaf_value in the first object would be substituted
#   with an array having the leaf_value on the nth (0-based) position
# n is either 0 or one so this would be [leaf_value] for n==0 and [null,leaf_value] for n==1
def create_compare_stream($n):
[
  tostream
  |select(length==2)
  |.[0]+=[$n]
]
;

def get_different_values_in_the_stream:
  group_by(.[0][:-1])
  |map(
    # select only different values
    select(.[0][1] != .[1][1])
    |.[]
  )
;

def filter_compare_stream($n):
  map(
      select(.[0][-1]==$n)
      |.[0]|=.[:-1]
    )
;

# create streams of values from input and combine
(.[0]|create_compare_stream(0)) + (.[1]|create_compare_stream(1))
# group by the original path (without added 0 and 1)
|get_different_values_in_the_stream as $diffstream
# transform the stream of path-value pairs back into the object (keys in the object will be sorted alpabetically)
| try
  fromstream($diffstream[],[[[]]])
  catch (
    $diffstream
    |(filter_compare_stream(0),filter_compare_stream(1))
    | fromstream(.[],[[[]]])
  )
