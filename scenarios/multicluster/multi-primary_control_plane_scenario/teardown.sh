#!/bin/bash

. utils.sh
kubectl delete namespace istio-operator --context=${MAIN_CLUSTER_CTX}
kubectl delete namespace istio-operator --context=${REMOTE_CLUSTER_CTX}

kubectl delete namespace kiali-operator --context=${MAIN_CLUSTER_CTX}
kubectl delete namespace kiali-operator --context=${REMOTE_CLUSTER_CTX}
kubectl patch kiali kiali -n istio-system -p '{"metadata":{"finalizers": []}}' --type=merge --context=${MAIN_CLUSTER_CTX}
kubectl patch kiali kiali -n istio-system -p '{"metadata":{"finalizers": []}}' --type=merge --context=${REMOTE_CLUSTER_CTX}
kubectl delete namespace istio-system --context=${MAIN_CLUSTER_CTX}
kubectl delete namespace istio-system --context=${REMOTE_CLUSTER_CTX}

kubectl delete namespace sample --context=${MAIN_CLUSTER_CTX}
kubectl delete namespace sample --context=${REMOTE_CLUSTER_CTX}

pkill kubectl