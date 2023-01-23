#!/bin/bash

source ../shell_setup.sh

cd used_lib

pe "cat main.go"

pe "go1.18.1 build -o badapp1"

# Don't actually push, image is already there
p "Image pushed to us-central1-docker.pkg.dev/wpanther-gke-dev/wpanther-test/badimage:v1"

pe "govulncheck badapp1 || true"

rm badapp1

p ""
