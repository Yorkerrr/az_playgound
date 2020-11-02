#!/bin/bash
. utils.sh

az aks get-credentials --resource-group azure-k8stest --name ${MAIN_CLUSTER_CTX} --overwrite-existing
az aks get-credentials --resource-group azure-k8stest --name ${REMOTE_CLUSTER_CTX} --overwrite-existing