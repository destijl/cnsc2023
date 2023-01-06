#!/bin/bash

source ../shell_setup.sh

p "kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml"
p "kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/general/allowedrepos/template.yaml"
pe "cat fail_closed.yaml"
p "kubectl patch validatingwebhookconfigurations.admissionregistration.k8s.io gatekeeper-validating-webhook-configuration --patch-file fail_closed.yaml"
pe "cat allowed_repos.yaml"
p "kubectl apply -f allowed_repos.yaml"

pe "kubectl run deny --image=registry.hub.docker.com/library/busybox -- /bin/sleep 60" || true
pe "kubectl run allow --image=gcr.io/google-containers/busybox -- /bin/sleep 60"
pe "kubectl get pods"

kubectl delete pods allow --wait=false &> /dev/null
kubectl delete pods deny --wait=false &> /dev/null || true
