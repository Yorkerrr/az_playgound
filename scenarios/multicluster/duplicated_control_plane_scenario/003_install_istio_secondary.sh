#!/bin/bash

. utils.sh

istioctl install -f istio-control-plane.yaml --context ${REMOTE_CLUSTER_CTX}
kubectl apply -f mTLS.yaml -n istio-system --context ${REMOTE_CLUSTER_CTX}