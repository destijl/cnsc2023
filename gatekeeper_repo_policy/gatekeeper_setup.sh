#!/bin/bash

set -o errexit
set -o pipefail

CONTAINER="us-central1-docker.pkg.dev/gcastle-gke-dev/gcastle-test/distroless"
PROJECT="gcastle-gke-dev"
CLUSTER="cosign-demo"
ZONE="us-central1-c"

gcloud container clusters get-credentials $CLUSTER --zone $ZONE --project $PROJECT &> /dev/null

kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/general/allowedrepos/template.yaml
kubectl wait --for=condition=ready pod -n gatekeeper-system --all
kubectl create namespace enforcing || true
kubectl apply -f allowed_repos.yaml

#kubectl delete --wait=false -f allowed_repos.yaml &> /dev/null
