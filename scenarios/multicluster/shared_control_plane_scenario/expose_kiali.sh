#!/bin/bash
. utils.sh
echo "Verify Primary cluster Sleep to Secondary cluster via ingress gw:"

echo "Verify Primary cluster Sleep to Secondary cluster via helloworld.sample.global:5000/hello"
nohup kubectl port-forward --context="${MAIN_CLUSTER_CTX}" -n istio-system \
    "$(kubectl get pod --context="${MAIN_CLUSTER_CTX}" -n istio-system -l \
    app=kiali -o jsonpath='{.items[0].metadata.name}')" 8080:20001 &
nohup kubectl port-forward --context="${REMOTE_CLUSTER_CTX}" -n istio-system \
    "$(kubectl get pod --context="${REMOTE_CLUSTER_CTX}" -n istio-system -l \
    app=kiali -o jsonpath='{.items[0].metadata.name}')" 8081:20001 &