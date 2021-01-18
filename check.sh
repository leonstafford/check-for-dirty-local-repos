#!/bin/sh

# accept starting directory to scan from
if [ ! "$1" ]; then
  echo "Didn't receive starting directory as input"
  exit 1
fi

STARTING_DIR="$1"

if [ ! -d "$1" ]; then
  echo "Starting directory doesn't exist"
  exit 1
fi

# find all directories under starting directory which contain a .git dir

# for each dir

#   check for uncomitted changes
      # returns 0 if changes
      # TODO: don't print initial git status to stdout
      HAS_UNCOMMITTED="$(git status | grep 'Untrackedsdf')"
      if [ "$HAS_UNCOMMITTED" ]; then
        echo "dir has uncommitted changes:"
        basename "$(pwd)"
        git status
      fi

#   check for unpushed commits 
