#!/bin/bash

source ../../shell_setup.sh
DEMO_PROMPT="$ "

CONTAINER="us-central1-docker.pkg.dev/gcastle-gke-dev/gcastle-test/distroless"
PROJECT="gcastle-gke-dev"
CLUSTER="cosign-demo"
ZONE="us-central1-c"

gcloud container clusters get-credentials $CLUSTER --zone $ZONE --project $PROJECT &> /dev/null

# This demo assumes you've run both the cosign and the gatekeeper setup scripts
pe "kubectl run deny-outside-image -n enforcing --image=busybox -- /bin/sleep 1" || true
pe "clear"
echo ""
echo ""
pe "kubectl run deny-non-distroless -n enforcing --image=gcr.io/google-containers/busybox -- /bin/sleep 1" || true
pe "clear"
echo ""
echo ""
pe "kubectl run allow -n enforcing --image=${CONTAINER}"
pe ""

kubectl delete -n enforcing --wait=false pods --all &> /dev/null || true
