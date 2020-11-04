#!/bin/bash

. utils.sh
# kubectl delete -f istio-main-cluster.yaml --namespace istio-system --context=${MAIN_CLUSTER_CTX}
# kubectl delete -f istio-secondary-cluster.yaml --namespace istio-system --context=${REMOTE_CLUSTER_CTX}
kubectl delete istiooperator installed-state -n istio-system --context=${MAIN_CLUSTER_CTX}
kubectl delete istiooperator installed-state -n istio-system --context=${REMOTE_CLUSTER_CTX}
# sleep 15
# kubectl delete namespace istio-operator --context=${MAIN_CLUSTER_CTX}
# kubectl delete namespace istio-operator --context=${REMOTE_CLUSTER_CTX}
kubectl delete namespace kiali-operator --context=${MAIN_CLUSTER_CTX}
kubectl delete namespace kiali-operator --context=${REMOTE_CLUSTER_CTX}
kubectl delete namespace sample --context=${MAIN_CLUSTER_CTX}
kubectl delete namespace sample --context=${REMOTE_CLUSTER_CTX}
pkill kubectl
