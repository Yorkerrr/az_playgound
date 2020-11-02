#!/bin/bash
. utils.sh

istioctl install --set profile=default --context ${MAIN_CLUSTER_CTX}
kubectl apply -f ./addons/prometheus.yaml -n istio-system --context=${MAIN_CLUSTER_CTX}
kubectl label namespace default istio-injection=enabled --context ${MAIN_CLUSTER_CTX}