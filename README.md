# jbscripts
various scripts, mosty bash with jq

 - Installation:
```
$ git clone https://github.com/janbobrowski/jbscripts
Cloning into 'jbscripts'...
remote: Enumerating objects: 77, done.
remote: Counting objects: 100% (77/77), done.
remote: Compressing objects: 100% (50/50), done.
remote: Total 77 (delta 40), reused 63 (delta 26), pack-reused 0 (from 0)
Receiving objects: 100% (77/77), 13.95 KiB | 6.97 MiB/s, done.
Resolving deltas: 100% (40/40), done.
$ source jbscripts/install.sh
~/.bashrc file will be modified to add /home/jan/jbscripts to the PATH, do you want to continue (y/n)?
y
PATH=$PATH:/home/jan/jbscripts
/home/jan/.bashrc file have been modified
running source /home/jan/.bashrc
```
 - csv2json.jq
```
csv2json.jq --args help
transforms CSV to JSON
reads from a file or standard input
supports quoted values
produces JSON arrays by default:
  $ csv2json.jq <<< $(printf 'a,b,c\n1,"2,3,4",5\nxxx,yyy,"zzz"\n')
  ["a","b","c"]
  [1,"2,3,4",5]
  ["xxx","yyy","zzz"]
when given "--args headers" produces JSON objects, using the first input row as keys:
  $ csv2json.jq --args headers <<< $(printf 'a,b,c\n1,"2,3,4",5\nxxx,yyy,"zzz"\n')
  {"a":1,"b":"2,3,4","c":5}
  {"a":"xxx","b":"yyy","c":"zzz"}
```
 - gitlog2json.jq \
transforms git log to JSON format \
works fine with git log options:
--format=fuller, --shortstat, --name-only
```
$  git -C jbscripts/ log -1 901e2eeeb817c69d04e3375a0e79a90fc976b90e --name-only \
| gitlog2json.jq
{
  "commit": "901e2eeeb817c69d04e3375a0e79a90fc976b90e",
  "Author": "Jan Bobrowski <janbobrowski@gmail.com>",
  "Date": "Thu Aug 28 17:01:57 2025 +0200",
  "changed_files": [
    "2streamjson.sh"
  ],
  "message": "renamed transform_json2stream.sh to 2streamjson.sh"
}
```
 - 2streamjson.sh
```
$ 2streamjson.sh -h
Transforms JSON to the stream of [<path>, <leaf-value>] which is also a JSON.
Reads from the standard input.
$ git -C jbscripts/ log -1 901e2eeeb817c69d04e3375a0e79a90fc976b90e --name-only \
| gitlog2json.jq \
| 2streamjson.sh
[["commit"],"901e2eeeb817c69d04e3375a0e79a90fc976b90e"]
[["Author"],"Jan Bobrowski <janbobrowski@gmail.com>"]
[["Date"],"Thu Aug 28 17:01:57 2025 +0200"]
[["changed_files",0],"2streamjson.sh"]
[["message"],"renamed transform_json2stream.sh to 2streamjson.sh"]
```
 - 2jsonstream.sh
```
$ 2jsonstream.sh -h
Transforms the stream of [<path>, <leaf-value>] to JSON.
Reads from the standard input.
$ git -C jbscripts/ log -1 901e2eeeb817c69d04e3375a0e79a90fc976b90e --name-only \
| gitlog2json.jq | 2streamjson.sh | grep sh \
| 2jsonstream.sh
{
  "changed_files": [
    "2streamjson.sh"
  ],
  "message": "renamed transform_json2stream.sh to 2streamjson.sh"
}
```
 - extensions_summary.jq
```
$ find . -type f | ./extensions_summary.jq
30 
13 sample
 9 sh
 5 jq
 1 idx
 1 md
 1 pack
 1 txt

```
 - create_bash_script.sh
```
$ create_bash_script.sh -h
Creates a bash script with shebang line and 755 permissions.
Usage: ./create_bash_script.sh [output_script_name=script.sh]
$ create_bash_script.sh
Using default script name: script.sh
Created script script.sh
```
 - create_jq_script.sh
```
$ create_jq_script.sh -h
Creates a jq script with shebang line and 755 permissions.
Usage: ./create_jq_script.sh [output_script_name=script.jq]
$ create_jq_script.sh
Using default script name: script.jq
Created script script.jq
```
 - create_python_script.sh
```
$ create_python_script.sh -h
Creates a python script with shebang line and 755 permissions
Usage: ./create_python_script.sh [output_script_name=script.py]
$ create_python_script.sh
Using default script name: script.py
Created script script.py
```
