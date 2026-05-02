#!/bin/bash
# Open Meld to show git diff for a file or directory

TARGET="${1#file://}"

WINDOWID=$(xdotool getactivewindow 2>/dev/null)

zenity_msg() {
    local type="$1"
    local msg="$2"
    if [ -n "$WINDOWID" ]; then
        zenity --"$type" --text="$msg" --attach="$WINDOWID" 2>/dev/null
    else
        zenity --"$type" --text="$msg" 2>/dev/null
    fi
}

if [ -f "$TARGET" ]; then
    DIR=$(dirname "$TARGET")
else
    DIR="$TARGET"
fi

GIT_ROOT=$(git -C "$DIR" rev-parse --show-toplevel 2>/dev/null)

if [ -z "$GIT_ROOT" ]; then
    zenity_msg "error" "Not a git repository."
    exit 1
fi

if [ -f "$TARGET" ]; then
    # Single file: diff that file
    if git -C "$GIT_ROOT" diff --quiet -- "$TARGET" && \
       git -C "$GIT_ROOT" diff --quiet --cached -- "$TARGET"; then
        zenity_msg "info" "No changes in this file."
        exit 0
    fi
    meld "$TARGET" &
else
    # Directory: diff scoped to that directory (not necessarily GIT_ROOT)
    if git -C "$GIT_ROOT" diff --quiet -- "$DIR" && \
       git -C "$GIT_ROOT" diff --quiet --cached -- "$DIR"; then
        zenity_msg "info" "No changes in this directory."
        exit 0
    fi
    meld "$DIR" &
fi
