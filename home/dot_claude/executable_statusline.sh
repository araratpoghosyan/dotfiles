#!/bin/bash
# Read JSON data that Claude Code sends to stdin
input=$(cat)

# Extract fields using jq
MODEL=$(echo "$input" | jq -r '.model.display_name')
# WORKING_DIR is the raw absolute path used for git; DIR is the display version
WORKING_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
DIR=$(echo "$WORKING_DIR" | sed "s|^$HOME|~|")
# The "// 0" provides a fallback if the field is null
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Build a 20-character progress bar for context usage
BAR_WIDTH=20
FILLED=$(( PCT * BAR_WIDTH / 100 ))
EMPTY=$(( BAR_WIDTH - FILLED ))
BAR=""
for i in $(seq 1 $FILLED); do BAR="${BAR}█"; done
for i in $(seq 1 $EMPTY);  do BAR="${BAR}░"; done

# Get git branch using the raw absolute path so ~ expansion is never needed
BRANCH=$(git -C "$WORKING_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)

# Build the status line: full path | git branch | context bar | model
if [ -n "$BRANCH" ]; then
  printf "%s | %s | [%s] %s%% | %s\n" "$DIR" "$BRANCH" "$BAR" "$PCT" "$MODEL"
else
  printf "%s | [%s] %s%% | %s\n" "$DIR" "$BAR" "$PCT" "$MODEL"
fi