#!/bin/bash

source ../shell_setup.sh
TYPE_SPEED=""

CONTAINER="us-central1-docker.pkg.dev/gcastle-gke-dev/gcastle-test/distroless"
PROJECT="gcastle-gke-dev"
CLUSTER="cosign-demo"
ZONE="us-central1-c"

gcloud container clusters get-credentials $CLUSTER --zone $ZONE --project $PROJECT &> /dev/null

pe "kubectl run deny -n enforcing --image=registry.hub.docker.com/library/busybox -- /bin/sleep 1" || true
pe "kubectl run allow -n enforcing --image=gcr.io/google-containers/busybox -- /bin/sleep 1"
pe "kubectl get pods -n enforcing"

kubectl delete -n enforcing --wait=false pods --all &> /dev/null || true
#Debugging policy not working
#pe "cat fail_closed.yaml"
#p "kubectl patch validatingwebhookconfigurations.admissionregistration.k8s.io gatekeeper-validating-webhook-configuration --patch-file fail_closed.yaml"
