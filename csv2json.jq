#!/usr/bin/env -S jq -fRcn

def parse_csv_line_with_quotes:
    # if line in csv file uses double quotes as it is described in https://www.ietf.org/rfc/rfc4180.txt
    # ( fields may be enclosed in double quotes, double quote inside a field escaped by another double quote )
    # iteration over all characters in the line is needed
    split("")
    |reduce .[] as $char ({record:"",array_of_records:[],inside_quotes:false,quotes_inside_quotes:false};
        # outside double quotes: double quotes change to inside_quotes, comma ends record, other char is appended
        if .inside_quotes==false then
            if $char == "\"" then .inside_quotes=true
            elif $char == "," then .array_of_records+=[.record]|.record=""
            else .record+=$char end
        # inside double quotes: double quotes change to quotes_inside_quotes, other char is appended
        elif .quotes_inside_quotes==false then # .inside_quotes==true
            if $char == "\"" then .quotes_inside_quotes=true
            else .record+=$char end
        # double quotes inside double quotes may escape double quotes (followed by double quotes) or end qotes (followed by other character)
        else # .inside_quotes==true .quotes_inside_quotes==true
            # double quotes escaped by double quotes: append double quotes
            if $char == "\"" then .record+="\""|.quotes_inside_quotes=false
            # comma ends record and we are outside double quotes (previous double quotes ended quotes)
            elif $char == "," then .array_of_records+=[.record]|.record=""|.quotes_inside_quotes=false|.inside_quotes=false
            # other character is appended and we are outside double quotes (previous double quotes ended quotes)
            else .record+=$char|.quotes_inside_quotes=false|.inside_quotes=false end
        end
    )
    # append last record (not followed by comma) to the array_of_records
    |.array_of_records+=[.record]
    |.array_of_records
;

def transform_csv_line_to_array:
    if contains("\"") then parse_csv_line_with_quotes else split(",") end
;

# csv does not contain headers - transform each line to array
if $ARGS.positional|map(.!="headers")|all then
    inputs|transform_csv_line_to_array
# first line contains headers - transform each line to object
else
    # first line contains column names
    input|transform_csv_line_to_array as $headers
    |inputs|transform_csv_line_to_array
    # transform strings to numbers or JSON where it is possible
    |map(fromjson? //.)
    # transform arrays to objects using names from the first line
    |with_entries(.key=$headers[.key])
end
