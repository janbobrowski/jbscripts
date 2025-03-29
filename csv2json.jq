#!/usr/bin/env -S jq -fR
split("")
|reduce .[] as $char ({string:"",row:[],inside:false,escape:false};
    # escaped character: just append it to the current string
    if .escape==true then .string+=$char|.escape=false
    # next character will be escaped: set escape flag to true
    elif $char == "\\" then .escape=true
    # double quote switches inside flag telling if we are inside double quotes
    elif $char == "\"" then .inside|=not
    # any char except comma (outside double quotes) is appended to the current string
    elif $char!="," or .inside then .string+=$char
    # if char is comma then it is end of the string - string is appended to the row
    # and set back to empty string
    else .row+=[.string]|.string=""
    end
)
# append last string (not followed by comma) to the row
|.row+=[.string]
# row contains the data
|.row
