#!/bin/bash

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    exit 1
fi

# Check if there are any commits
if ! git rev-parse HEAD >/dev/null 2>&1; then
    exit 1
fi

# Get the last commit message
last_commit=$(git log -1 --pretty=%s 2>/dev/null)

# Check if the last commit is a WIP commit
if [[ "$last_commit" == *"--wip--"* ]]; then
    echo "WIP"
    exit 0
else
    exit 1
fi
