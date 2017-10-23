#!/bin/bash
# @Function
# switch svn work directory to trunk.
#
# @Usage
#   $ ./swtrunk.sh [<svn work dir>...]
#
# @online-doc https://github.com/oldratlee/useful-scripts/blob/master/docs/vcs.md#beer-swtrunksh
# @author Jerry Lee (oldratlee at gmail dot com)

# NOTE: $'foo' is the escape sequence syntax of bash
readonly ec=$'\033' # escape char
readonly eend=$'\033[0m' # escape end

colorEcho() {
    local color=$1
    shift
    if [ -t 1 ] ; then
        # if stdout is console, turn on color output.
        echo "$ec[1;${color}m$@$eend"
    else
        echo "$@"
    fi
}

redEcho() {
    colorEcho 31 "$@"
}

greenEcho() {
    colorEcho 32 "$@"
}

[ $# -eq 0 ] && dirs=(.) || dirs=("$@")

for d in "${dirs[@]}" ; do
    [ ! -d ${d}/.svn ] && {
        redEcho "directory $d is not a svn work directory, ignore directory $d !"
        continue
    }
    (
        cd "$d" &&
        branches=`svn info | grep '^URL' | awk '{print $2}'` &&
        trunk=`echo $branches | awk -F'/branches/' '{print $1}'`/trunk &&

        svn sw "$trunk" &&
        greenEcho "svn work directory $d switch from ${branches} to ${trunk} ." ||
        redEcho "fail to switch $d to trunk!"
    )
done
