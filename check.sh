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

    REPO_NAME="$(basename "$dir")"

    # Update the index
    git update-index -q --ignore-submodules --refresh

    # Disallow unstaged changes in the working tree
    if ! git diff-files --quiet --ignore-submodules --
    then
        echo >&2 "$REPO_NAME: you have unstaged changes."
        git diff-files --quiet --name-status -r --ignore-submodules --
    fi

    # Disallow uncommitted changes in the index
    if ! git diff-index --cached --quiet HEAD --ignore-submodules --
    then
        echo >&2 "$REPO_NAME: your index contains uncommitted changes."
        git diff-index --cached --quiet --name-status -r --ignore-submodules HEAD --
    fi

    if [ "$(git cherry -v)" ]
    then
      echo "$REPO_NAME has unpushed commits"
    fi
done

exit 0

