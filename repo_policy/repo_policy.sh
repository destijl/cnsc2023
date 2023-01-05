#!/bin/bash

source ../shell_setup.sh

pe "kubectl run deny --image=registry.hub.docker.com/library/busybox -- /bin/sleep 60" || true
pe "kubectl run allow --image=gcr.io/google-containers/busybox -- /bin/sleep 60"
pe "kubectl get pods"

kubectl delete pods allow --wait=false &> /dev/null
kubectl delete pods deny --wait=false &> /dev/null || true
