#!/bin/bash
. utils.sh

sleep 30

kubectl apply -f argocd/system/application.yaml --context ${MAIN_CLUSTER_CTX}
