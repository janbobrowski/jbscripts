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
git log -1 --format=fuller --shortstat | gitlog2json.jq
{
  "commit": "cfb2c827d9a3214eee08974ae09cbf18e3002699",
  "Author": "Jan Bobrowski <janbobrowski@gmail.com>",
  "AuthorDate": "Sat Oct 19 19:19:57 2024 +0200",
  "Commit": "Jan Bobrowski <janbobrowski@gmail.com>",
  "CommitDate": "Sat Oct 19 19:19:57 2024 +0200",
  "stats": {
    "files changed": 1,
    "insertions(+)": 1,
    "deletions(-)": 1
  },
  "message": "jsondiff_all.jq: show equal values as single value"
}
```