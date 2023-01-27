#!/bin/bash

# $Id: $
source ../../shell_setup.sh

CONTAINER="us-central1-docker.pkg.dev/gcastle-gke-dev/gcastle-test/distroless@sha256:624dec0474955fd8cac0ce44f3266b5204dad35ec7d23783bf0388e2d42c4c82"
PROJECT="gcastle-gke-dev"
CLUSTER="cnsc2"
ZONE="us-central1-c"

gcloud container clusters get-credentials $CLUSTER --zone $ZONE --project $PROJECT &> /dev/null

pe "kubectl run deny --image=registry.hub.docker.com/library/busybox@sha256:937aad7ae3ff2f7a7320c48779a3cc5c6a44788a09e86b2866ca96a66b6f047e -- /bin/sleep 60" || true
pe "clear"
pe "kubectl run allow --image=${CONTAINER}"

kubectl delete --wait=false pods allow &> /dev/null
