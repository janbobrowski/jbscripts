#!/usr/bin/env -S jq -fRrn -L ""
include "def-semver";
[inputs]
|sort_by(semver)
|.[]
