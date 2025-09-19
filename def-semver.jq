# function that enables sorting as it is specified Semantic Versioning Specification: https://semver.org/#spec-item-11
# (that is different than sort -V: https://www.gnu.org/software/coreutils/manual/html_node/Version-sort-overview.html)
# sort_by(semver) will sort an array containing file names

# function transforms input string into an array of:
# - package name
# - version core (version core is an array of numbers and/or strings)
# - boolean that is set to true if there is no pre-release (pre-release versions have a lower precedence than the associated normal version)
# - pre-release

def semver:
[
  # extract name and version
  match("[0-9]+[0-9.]*";"").offset //null as $version_index
  # if input string contains version
  |if $version_index then
      (.[:$version_index]) as $name
      |.[$version_index:]
      # ignore build
      |split("+")[0]
      # extract version core and pre-release as arrays of numbers and strings
      |split("-")
      |(.[0]|split(".")|map(tonumber? // .)) as $version_core
      |(.[1:]|join("-")|split(".")|map(tonumber? // .)) as $pre_release
      # package name
      |$name,
      # version core
      $version_core,
      # pre-release versions have a lower precedence than the associated normal version
      ($pre_release|length)==0,
      # pre-release
      $pre_release
  # if input string does not contain version name is whole input and only name will be in the output array
  else . as $name | $name
  end
];
