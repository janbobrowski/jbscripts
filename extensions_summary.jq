#!/usr/bin/env -S jq -fRnr

# takes list of files as an input (output of find command)

# array of all extensions
[
    inputs
    |split("/")[-1] # get only last element from the path
    |split(".")
    |if length>1 then .[-1] else "" end # files with no dot have an empty string as extension
]
|group_by(.) # group by extension
|map(
    {extension:.[0],count:length}
)
|sort_by(-.count)
|map(.count|=tostring)
|(map(.count|length)|max) as $maxlen
|.[]
|(.count|($maxlen-length)*" "+.+" ")+.extension
