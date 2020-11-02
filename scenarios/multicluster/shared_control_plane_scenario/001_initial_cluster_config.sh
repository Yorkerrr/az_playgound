#!/bin/bash
. utils.sh

kubectl create namespace istio-system --context=${MAIN_CLUSTER_CTX} || echo "${MAIN_CLUSTER_CTX} istio-system namespace created"
kubectl create namespace istio-system --context=${REMOTE_CLUSTER_CTX} || echo "${REMOTE_CLUSTER_CTX} istio-system namespace created"
kubectl create secret generic cacerts -n istio-system \
    --from-file=./samples/certs/ca-cert.pem \
    --from-file=./samples/certs/ca-key.pem \
    --from-file=./samples/certs/root-cert.pem \
    --from-file=./samples/certs/cert-chain.pem \
    --context ${MAIN_CLUSTER_CTX}

kubectl create secret generic cacerts -n istio-system \
    --from-file=./samples/certs/ca-cert.pem \
    --from-file=./samples/certs/ca-key.pem \
    --from-file=./samples/certs/root-cert.pem \
    --from-file=./samples/certs/cert-chain.pem \
    --context ${REMOTE_CLUSTER_CTX}

istioctl operator init --context=${MAIN_CLUSTER_CTX}
istioctl operator init --context=${REMOTE_CLUSTER_CTX}

