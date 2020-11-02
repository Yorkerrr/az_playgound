#!/bin/bash
. utils.sh

kubectl create namespace argocd --context ${MAIN_CLUSTER_CTX}
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --context ${MAIN_CLUSTER_CTX}

kubectl create namespace argo-rollouts --context ${MAIN_CLUSTER_CTX}
kubectl apply -n argo-rollouts -f https://raw.githubusercontent.com/argoproj/argo-rollouts/stable/manifests/install.yaml --context ${MAIN_CLUSTER_CTX}
