#!/bin/bash
. utils.sh

istioctl install --set profile=demo --context ${MAIN_CLUSTER_CTX}
kubectl label namespace default istio-injection=enabled --context ${MAIN_CLUSTER_CTX}