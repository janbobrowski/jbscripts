# jbscripts
various scripts, mosty bash with jq

Installation:
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
create_bash_script.sh
```
$ create_bash_script.sh -h
Creates a bash script with shebang line and 755 permissions.
Usage: ./create_bash_script.sh [output_script_name=script.sh]
$ create_bash_script.sh
Using default script name: script.sh
Created script script.sh
```
create_jq_script.sh
```
$ create_jq_script.sh -h
Creates a jq script with shebang line and 755 permissions.
Usage: ./create_jq_script.sh [output_script_name=script.jq]
$ create_jq_script.sh
Using default script name: script.jq
Created script script.jq
```
create_python_script.sh
```
$ create_python_script.sh -h
Creates a python script with shebang line and 755 permissions
Usage: ./create_python_script.sh [output_script_name=script.py]
$ create_python_script.sh
Using default script name: script.py
Created script script.py
```
gitlog2json.jq \
transforms git log to JSON format \
works fine with git log options:
--format=fuller, --shortstat, --name-only
```
$ git -C jbscripts/ log -1 62661d60d178ed9fd1ff96b0fac520a1816d9563 --name-only | gitlog2json.jq
{
  "commit": "62661d60d178ed9fd1ff96b0fac520a1816d9563",
  "Author": "Jan Bobrowski <janbobrowski@gmail.com>",
  "Date": "Sat Jun 22 17:31:08 2024 +0200",
  "changed_files": [
    "remove_carriage_return.sh",
    "remove_trailing_whitespace.sh",
    "transform_json2stream.sh",
    "transform_stream2json.sh"
  ],
  "message": "added remove scripts and renamed other scripts"
}
```
transform_json2stream.sh
```
$ transform_json2stream.sh -h
Transforms JSON to the stream of [<path>, <leaf-value>] which is also a JSON.
Reads from the standard input.
$ git -C jbscripts/ log -1 62661d60d178ed9fd1ff96b0fac520a1816d9563 --name-only | gitlog2json.jq | transform_json2stream.sh 
[["commit"],"62661d60d178ed9fd1ff96b0fac520a1816d9563"]
[["Author"],"Jan Bobrowski <janbobrowski@gmail.com>"]
[["Date"],"Sat Jun 22 17:31:08 2024 +0200"]
[["changed_files",0],"remove_carriage_return.sh"]
[["changed_files",1],"remove_trailing_whitespace.sh"]
[["changed_files",2],"transform_json2stream.sh"]
[["changed_files",3],"transform_stream2json.sh"]
[["message"],"added remove scripts and renamed other scripts"]
```
transform_stream2json.sh
```
$ transform_stream2json.sh -h
Transforms the stream of [<path>, <leaf-value>] to JSON.
Reads from the standard input.
$ git -C jbscripts/ log -1 62661d60d178ed9fd1ff96b0fac520a1816d9563 --name-only | gitlog2json.jq | transform_json2stream.sh | grep 2 | transform_stream2json.sh 
{
  "commit": "62661d60d178ed9fd1ff96b0fac520a1816d9563",
  "Date": "Sat Jun 22 17:31:08 2024 +0200",
  "changed_files": [
    null,
    null,
    "transform_json2stream.sh",
    "transform_stream2json.sh"
  ]
}
```