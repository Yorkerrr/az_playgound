#!/bin/bash

. utils.sh

kubectl apply -f istio-gw.yaml  --context=${MAIN_CLUSTER_CTX}
kubectl apply -f istio-gw-secondary.yaml  --context=${REMOTE_CLUSTER_CTX}