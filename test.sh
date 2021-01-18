#!/bin/sh
#
# run ShellCheck to catch syntactical errors and promote best practice
find . -type f -not -path '*/\.git/*' -name '*.sh' \
  -exec shellcheck {} \;

