#!/bin/sh
# Test basic functionality

set -e

proram=$0
TMPDIR=${TMPDIR:-/tmp}
BASE=tmp.$$
TMPBASE=${TMPDIR%/}/$BASE
CURDIR=.

case "$0" in
  */*)
        CURDIR=$(cd "${0%/*}" && pwd)
        ;;
esac

AtExit ()
{
    rm -f "$TMPBASE"*
}

Run ()
{
    echo "$*"
    shift
    eval "$@"
}

trap AtExit 0 1 2 3 15

# #######################################################################

file="$TMPBASE.file"
link1="$TMPBASE.symlink1"
link2="$TMPBASE.symlink2"
dangling="$TMPBASE.dangling"

: > "$file"
ln -s "$file" "$link1"
ln -s "$link1" "$link2"

: > "$file.1"
ln -s "$file.1" "$dangling"
rm "$file.1"

Run "%% TEST change relative, shorten:" symlinks -c -s "$TMPDIR"
(cd "$TMPDIR" ; ls -l "$TMPBASE"*)

Run "%% TEST delete dangling:" symlinks -d "$TMPDIR"
Run "%% TEST verbose:" symlinks -v "$TMPDIR"

# End of file
