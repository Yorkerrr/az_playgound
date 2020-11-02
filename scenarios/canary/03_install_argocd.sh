#!/bin/bash
. utils.sh

kubectl apply -f argocd/system/application.yaml --context ${MAIN_CLUSTER_CTX}
