#!/bin/bash

. utils.sh

kubectl delete namespace argocd --context=${MAIN_CLUSTER_CTX}
kubectl delete namespace argo-rollouts --context=${MAIN_CLUSTER_CTX}
kubectl delete namespace istio-system --context=${MAIN_CLUSTER_CTX}
kubectl delete namespace canary --context=${MAIN_CLUSTER_CTX}