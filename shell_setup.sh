#!/bin/bash

set -o errexit
set -o pipefail

export TERM=xterm

# Make sure we have go1.18.1 to build the binary
if [ ! -f go1.18.1 ]; then
  go install golang.org/dl/go1.18.1@latest
  go1.18.1 download
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


