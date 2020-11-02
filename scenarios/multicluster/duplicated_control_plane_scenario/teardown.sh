#!/bin/bash

. utils.sh
kubectl delete namespace istio-system --context=${MAIN_CLUSTER_CTX}
kubectl delete namespace istio-system --context=${REMOTE_CLUSTER_CTX}
kubectl delete namespace sample --context=${MAIN_CLUSTER_CTX}
kubectl delete namespace sample --context=${REMOTE_CLUSTER_CTX}
pkill kubectl