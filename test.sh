#!/bin/sh

tests=0

describe() {
  tests=$((tests+1))
  description="$1"
}

assert() {
  if [ "$1" = "$2" ]; then
    printf "\033[32m.\033[0m"
  else
    printf "\033[31m\nFAIL: %s\033[0m: '%s' != '%s'\n" "$description" "$1" "$2"
    exit 1
  fi
}

describe "Help"
  ./levenshtein --help > /dev/null 2>&1
  assert $? 0

describe "Help: short flag"
  ./levenshtein -h > /dev/null 2>&1
  assert $? 0

describe "Version"
  ./levenshtein --version > /dev/null 2>&1
  assert $? 0

describe "Version: short flag"
  ./levenshtein -v > /dev/null 2>&1
  assert $? 0

describe "Execute: one argument"
  ./levenshtein foo > /dev/null 2>&1
  assert $? 1

describe "Execute: more than two arguments"
  ./levenshtein foo bar baz > /dev/null 2>&1
  assert $? 1

describe "Execute: should work"
  assert "$(./levenshtein -s "" "a")" 1
  assert "$(./levenshtein -s "a" "")" 1
  assert "$(./levenshtein -s "" "")" 0
  assert "$(./levenshtein -s "levenshtein" "levenshtein")" 0
  assert "$(./levenshtein -s "sitting" "kitten")" 3
  assert "$(./levenshtein -s "gumbo" "gambol")" 2
  assert "$(./levenshtein -s "saturday" "sunday")" 3
  assert "$(./levenshtein -s "DwAyNE" "DUANE")" 2
  assert "$(./levenshtein -s "dwayne" "DuAnE")" 5
  assert "$(./levenshtein -s "aarrgh" "aargh")" 1
  assert "$(./levenshtein -s "aargh" "aarrgh")" 1
  assert "$(./levenshtein -s "a" "b")" 1
  assert "$(./levenshtein -s "ab" "ac")" 1
  assert "$(./levenshtein -s "ac" "bc")" 1
  assert "$(./levenshtein -s "abc" "axc")" 1
  assert "$(./levenshtein -s "xabxcdxxefxgx" "1ab2cd34ef5g6")" 6
  assert "$(./levenshtein -s "xabxcdxxefxgx" "abcdefg")" 6
  assert "$(./levenshtein -s "javawasneat" "scalaisgreat")" 7
  assert "$(./levenshtein -s "example" "samples")" 3
  assert "$(./levenshtein -s "sturgeon" "urgently")" 6
  assert "$(./levenshtein -s "levenshtein" "frankenstein")" 6
  assert "$(./levenshtein -s "distance" "difference")" 5

printf "\033[32m\n(✓) Passed %s assertions without errors\033[0m\n" "$tests"

exit 0
