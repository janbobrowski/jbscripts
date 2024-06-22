#!/usr/bin/jq -fRs

# splits array on rows fulfilling given condition
# each row fulfilling condition starts a new subarray
def split_array_on_condition(condition):
[
  . as $input_array
  # get indexes of the rows fulfilling conditions
  |to_entries
  |map(
    select(.value|condition).key
  )
  # create $indexes array with indexes that will be used to split input array

  # adding null at the beginning of an array
  # if the first one is not 0 (first row does not fulfill given condition)
  # (first row needs to start a new subarray no matter if it fulfills given condition)
  |if .[0]!=0 then [null]+. else . end
  |[
    .,
    .[1:]+[null]
  ]
  # each row of indexes contains
  # index of the row fulfilling condition
  # and index of the next row fulfilling condition
  |transpose[] as $indexes
  # split input array into subarrays
  |$input_array[$indexes[0]:$indexes[1]]
]
;

# script reads an input as a single string

# split commits

# add new line at the beginning to get the same for the first row
"\n"+.
|split("\ncommit ")[1:][]
|split("\n")
# split commit information into sections (each section starts with empty line)
# add empty string to get the same in the first row
|[""]+.
|split_array_on_condition(.=="")
# last character of commit information is \n
# - last line after split is always empty
# and can be removed
|.[:-1]
# first row is always empty (empty row was used to split array)
|map(.[1:])
|(.[0][0]) as $commit
|(
  .[0][1:]
  |
  map(
    split(":\\s+";"")
    |{(.[0]):.[1]}
  )
  |add
) as $commit_info
|(
  .[1]
  |map(.[4:])
  |join("\n")
) as $message
|(
  if .[2] and (.[2]|map(test("^[ +-]";"")|not)|all) then .[2]
  else null end
) as $changed_files
|(
  if .[2] and (.[2]|length==1) and .[2][0][:1]==" " then
    .[2][0][1:]
    |split(", ")
    |map({(split(" ")[1:]|join(" ")|sub("file ";"files ")|sub("insertion\\(";"insertions(")|sub("deletion\\(";"deletions(")):split(" ")[0]|tonumber})
    |add
  else null end
) as $stats
|{$commit}+$commit_info+{$changed_files}+{$stats}+{$message}
|map_values(select(.))
