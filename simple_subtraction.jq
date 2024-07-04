#!/usr/bin/jq -fnrc

def array_subtraction($a1;$a2):
  reduce ($a2|reverse[]) as $item (
    $a1;
    del(.[rindex($item)?])
  )
;

def object_subtraction($o1;$o2):
  $o1 | del(.[$o2|keys[]])
;

def simple_subtraction($v1;$v2):
  if [($v1,$v2|type=="array")]|all then array_subtraction($v1;$v2) 
  elif [($v1,$v2|type=="object")]|all then object_subtraction($v1;$v2) 
  else $v1 end
;

simple_subtraction([1,2,3,1,2];[1,2]),
simple_subtraction([1,2,3,1,2];{a:1,b:2}),
simple_subtraction({a:11,b:22,c:33,d:55};{a:1,b:2,c:3})
