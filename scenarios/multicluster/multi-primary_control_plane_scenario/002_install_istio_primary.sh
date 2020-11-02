#!/bin/bash

. utils.sh

istioctl install -f istio-control-primary.yaml --context ${MAIN_CLUSTER_CTX}

kubectl apply -f mTLS.yaml -n istio-system --context ${MAIN_CLUSTER_CTX}