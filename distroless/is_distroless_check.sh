#!/bin/bash

source ../shell_setup.sh

pe "~/go/bin/gcrane export us-central1-docker.pkg.dev/gcastle-gke-dev/gcastle-test/distroless:latest - | tar -Oxf - usr/lib/os-release"
pe "~/go/bin/gcrane export ubuntu:latest - | tar -Oxf - usr/lib/os-release"
pe "~/go/bin/gcrane export alpine:latest - | tar -Oxf - etc/os-release"

