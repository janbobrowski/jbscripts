#!/usr/bin/env -S jq -fR
split("")
|reduce .[] as $char ({string:"",row:[],inside:false,quote_inside:false};
    # outside double quotes: double quotes change to inside, comma ends record, other char is appended
    if .inside==false then
        if $char == "\"" then .inside=true
        elif $char == "," then .row+=[.string]|.string=""
        else .string+=$char end
    # inside double quotes: double quotes change to quote_inside, other char is appended
    elif .quote_inside==false then
        if $char == "\"" then .quote_inside=true
        else .string+=$char end
    # double quotes inside double quotes (double quote may end qotes or escape double quotes)
    else
        # double double quotes inside double quotes(double quotes escaped by double quotes): append double quotes
        if $char == "\"" then .string+="\""|.quote_inside=false
        # comma ends record and we are outside double quotes
        elif $char == "," then .row+=[.string]|.string=""|.quote_inside=false|.inside=false
        # other character is appended and we are outside double quotes
        else .string+=$char|.quote_inside=false|.inside=false end
    end
)
|.row+=[.string]
|.row
