#!/bin/bash

source ../shell_setup.sh

cd unused_lib

pe "cat main.go"

pe "go1.19 build -o badapp1"

pe "govulncheck badapp1"

rm badapp1

cd ../used_lib

pe "cat main.go"

pe "go1.19 build -o badapp2"

pe "govulncheck badapp2"

rm badapp2
