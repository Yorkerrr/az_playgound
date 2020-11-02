#!/bin/bash

. utils.sh

istioctl x create-remote-secret --name ${REMOTE_CLUSTER_NAME} --context=${REMOTE_CLUSTER_CTX} | \
    kubectl apply -f - --context=${MAIN_CLUSTER_CTX}

istioctl x create-remote-secret --name ${MAIN_CLUSTER_CTX} --context=${MAIN_CLUSTER_CTX} | \
    kubectl apply -f - --context=${REMOTE_CLUSTER_CTX}