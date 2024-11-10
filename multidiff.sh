#!/bin/bash
jq -Rnr '
  [inputs] as $files
  |$files[] as $file1
  |$files[] as $file2
  |select($file1<$file2)
  |"diff -qs \"\($file1)\" \"\($file2)\""
' | bash