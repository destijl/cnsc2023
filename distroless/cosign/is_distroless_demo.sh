#!/bin/bash

source ../../shell_setup.sh

CONTAINER="us-central1-docker.pkg.dev/gcastle-gke-dev/gcastle-test/distroless"
PROJECT="gcastle-gke-dev"
CLUSTER="cosign-demo"
ZONE="us-central1-c"

gcloud container clusters get-credentials $CLUSTER --zone $ZONE --project $PROJECT &> /dev/null

# Default namespace isn't enforced
pe "kubectl run allow-unenforced --image=busybox -- /bin/sleep 1" || true
pe "kubectl run deny -n cosign-enforced --image=busybox -- /bin/sleep 1" || true
pe "clear"
pe "kubectl run allow -n cosign-enforced --image=${CONTAINER}"

kubectl delete -n cosign-enforced --wait=false pods allow &> /dev/null
kubectl delete --wait=false pods allow-unenforced &> /dev/null
