#!/usr/bin/env -S jq -fRc
split("")
|reduce .[] as $char ({record:"",line:[],inside_quotes:false,quotes_inside_quotes:false};
    # outside double quotes: double quotes change to inside_quotes, comma ends record, other char is appended
    if .inside_quotes==false then
        if $char == "\"" then .inside_quotes=true
        elif $char == "," then .line+=[.record]|.record=""
        else .record+=$char end
    # inside  double quotes: double quotes change to quotes_inside_quotes, other char is appended
    elif .quotes_inside_quotes==false then
        if $char == "\"" then .quotes_inside_quotes=true
        else .record+=$char end
    # double quotes inside double quotes (double quotes may end qotes or escape double quotes)
    else
        # double double quotes inside double quotes(double quotes escaped by double quotes): append double quotes
        if $char == "\"" then .record+="\""|.quotes_inside_quotes=false
        # comma ends record and we are outside double quotes
        elif $char == "," then .line+=[.record]|.record=""|.quotes_inside_quotes=false|.inside_quotes=false
        # other character is appended and we are outside double quotes
        else .record+=$char|.quotes_inside_quotes=false|.inside_quotes=false end
    end
)
# append last record (not followed by comma) to the line
|.line+=[.record]
|.line
