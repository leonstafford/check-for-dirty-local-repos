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
for dir in "$STARTING_DIR"/*/; do
    # ignore if no .git dir within
    if [ ! -d "$dir/.git" ]; then
      continue
    fi

    # echo "Checking $(basename $dir)"

    cd "$dir" || continue

    #   check for uncomitted changes
    # returns 0 if changes
    # TODO: don't print initial git status to stdout
    pwd
    HAS_UNCOMMITTED="$(git diff-index --quiet HEAD --)"

    if [ "$HAS_UNCOMMITTED" ]; then
      echo "dir has uncommitted changes:"
      basename "$dir"
      # git status
    fi

    # cd -


#   check for unpushed commits 
done

exit 0
# for each dir

