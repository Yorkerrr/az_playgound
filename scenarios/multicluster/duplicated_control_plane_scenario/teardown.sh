#!/bin/bash

. utils.sh
kubectl delete -f istio-control-plane.yaml --context=${MAIN_CLUSTER_CTX}
kubectl delete -f istio-control-plane.yaml --context=${REMOTE_CLUSTER_CTX}
# kubectl delete namespace istio-system --context=${MAIN_CLUSTER_CTX}
# kubectl delete namespace istio-system --context=${REMOTE_CLUSTER_CTX}
kubectl delete namespace kiali-operator --context=${MAIN_CLUSTER_CTX}
kubectl delete namespace kiali-operator --context=${REMOTE_CLUSTER_CTX}
kubectl delete namespace sample --context=${MAIN_CLUSTER_CTX}
kubectl delete namespace sample --context=${REMOTE_CLUSTER_CTX}
pkill kubectl