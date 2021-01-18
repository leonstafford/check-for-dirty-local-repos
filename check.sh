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

touch /tmp/dirtydirs && echo '' > /tmp/dirtydirs

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
        # cache in list for further processing
        echo "$dir" >> /tmp/dirtydirs
    fi

    # Disallow uncommitted changes in the index
    if ! git diff-index --cached --quiet HEAD --ignore-submodules --
    then
        echo >&2 "$REPO_NAME: your index contains uncommitted changes."
        git diff-index --cached --quiet --name-status -r --ignore-submodules HEAD --
        echo "$dir" >> /tmp/dirtydirs
    fi

    if [ "$(git cherry -v)" ]
    then
      echo "$REPO_NAME has unpushed commits"
      echo "$dir" >> /tmp/dirtydirs
    fi
done

# optionally open each dir in new named tmux window

cat /tmp/dirtydirs

if { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
  echo "Already within tmux, please run from outside tmux"
  exit 1
fi

# delete existing cleanup session
# tmux kill-session -t DirtyRepoCleanup

# create new session to hold a window for each dir
tmux new-session -d -s DirtyRepoCleanup
# tmux new-session -s DirtyRepoCleanup -d -n basewindow 'echo new win'

# NOTE: we're still cd'd into last dir we inspected

while IFS="" read -r DIRTY_DIR || [ -n "$DIRTY_DIR" ]
do
  if [ ! "$DIRTY_DIR" ]; then
    continue
  fi

  # printf '%s allo \n' "$DIRTY_DIR"
  DIRTY_BASENAME="$(basename "$DIRTY_DIR")"
  echo " my $DIRTY_DIR ($DIRTY_BASENAME)"
  # tmux new-window -n:"$DIRTY_BASENAME" "cd "$DIRTY_DIR""
  # tmux new-window -n:anewone 'ls'


  # tmux new-window -n "$DIRTY_BASENAME" -t DirtyRepoCleanup: "echo $DIRTY_BASENAME" &
  tmux new-window -n "$DIRTY_BASENAME" -t DirtyRepoCleanup: 

  # -d to prevent current window from changing
  # tmux new-window -d -n Win2
  # tmux new-window -d -n Win3
  # tmux new-window -d -n Win4
  # -d to detach any other client (which there shouldn't be,
  # since you just created the session).
done < /tmp/dirtydirs

tmux attach-session -t DirtyRepoCleanup

exit 0

