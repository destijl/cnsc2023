#!/bin/bash

set -o errexit
set -o pipefail

# Following
# https://docs.sigstore.dev/cosign/overview/
# https://docs.sigstore.dev/policy-controller/overview/
# https://github.com/sigstore/helm-charts/tree/main/charts/policy-controller

CONTAINER="us-central1-docker.pkg.dev/gcastle-gke-dev/gcastle-test/distroless"
PROJECT="gcastle-gke-dev"
CLUSTER="cosign-demo"
ZONE="us-central1-c"

gcloud container clusters get-credentials $CLUSTER --zone $ZONE --project $PROJECT &> /dev/null

go install github.com/sigstore/cosign/cmd/cosign@latest

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

helm repo add sigstore https://sigstore.github.io/helm-charts
helm repo update
kubectl create namespace cosign-system
helm install policy-controller -n cosign-system sigstore/policy-controller --devel

# You should set a real password, or better yet, use the KMS or keyless
# cosigning options. Skipping for demo simplicity.
export COSIGN_PASSWORD=""
cosign generate-key-pair

cosign sign --key cosign.key $CONTAINER
cosign verify --key cosign.pub $CONTAINER

kubectl create secret generic cosign-distroless -n \
cosign-system --from-file=cosign.pub=./cosign.pub

kubectl apply -f cosign_image_policy.yaml
kubectl apply -f cosign_opt_in_namespace.yaml 
