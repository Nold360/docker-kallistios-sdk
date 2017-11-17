#!/bin/bash
# Small KOS-Wrapper Script
if [ -z "$1" ] ; then
	cmd="make"
else
	cmd=$@
fi

[ -z "$KOS_BASE" ] && source /opt/toolchains/dc/kos/environ.sh
echo "######### KallistiOS Environment ##########"
echo "# CMD: $cmd"
$cmd
exit 0
