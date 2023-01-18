#!/bin/bash

set -o errexit
set -o pipefail

export TERM=xterm

# This directory is executable on COS
#RUNDIR="/home/kubernetes/bin"
#cd $RUNDIR

#if [ ! -f jq ]; then
#  curl -sS -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o jq 
#  chmod a+x jq
#fi

if [ ! -f go1.19 ]; then
  go install golang.org/dl/go1.19@latest
  go1.19 download
fi

DEMOMAGIC="demo-magic.sh"

if [ ! -f $DEMOMAGIC ]; then
  curl -OsS -L https://raw.githubusercontent.com/paxtonhare/demo-magic/master/demo-magic.sh 
  chmod a+x demo-magic.sh
fi

. ./demo-magic.sh
# Uncomment to turn off command typing.
#TYPE_SPEED=""
#DEMO_PROMPT="compromised_node# "
# Turns out the white defined in demo-magic renders a little grey.
DEMO_CMD_COLOR=$COLOR_RESET
clear
echo ""
echo ""


