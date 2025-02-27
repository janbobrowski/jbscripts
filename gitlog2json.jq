#!/usr/bin/env -S jq -fRn
# script transforms git log to JSON format
# works fine with git log options:
# --format=fuller, --shortstat, --name-only
# usage:
# git log -1 --format=fuller --shortstat | gitlog2json.jq
# {
#   "commit": "cfb2c827d9a3214eee08974ae09cbf18e3002699",
#   "Author": "Jan Bobrowski <janbobrowski@gmail.com>",
#   "AuthorDate": "Sat Oct 19 19:19:57 2024 +0200",
#   "Commit": "Jan Bobrowski <janbobrowski@gmail.com>",
#   "CommitDate": "Sat Oct 19 19:19:57 2024 +0200",
#   "stats": {
#     "files changed": 1,
#     "insertions(+)": 1,
#     "deletions(-)": 1
#   },
#   "message": "jsondiff_all.jq: show equal values as single value"
# }


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

[inputs,""]
|split_array_on_condition(startswith("commit "))
|.[][:-1]
|split_array_on_condition(.=="")
|(.[0][0]|split("commit ")[1]) as $commit
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
  .[1][1:]
  |map(.[4:])
  |join("\n")
) as $message
|(
  if .[2] and (.[2]|map(test("^[ +-]";"")|not)|all) then .[2][1:]
  else null end
) as $changed_files
|(
  if .[2] and (.[2]|length==2) and .[2][1][:1]==" " then
    .[2][1][1:]
    |split(", ")
    |map(
      {
        (
          split(" ")[1:]|join(" ")
          |sub("file ";"files ")
          |sub("insertion\\(";"insertions(")
          |sub("deletion\\(";"deletions(")
        )
        :
        split(" ")[0]|tonumber
      }
    )
  |add
  else null end
) as $stats
|{$commit}+$commit_info+{$changed_files}+{$stats}+{$message}
|map_values(select(.))
