#!/bin/bash

. utils.sh

kubectl create namespace sample --context=${MAIN_CLUSTER_CTX} || echo "${MAIN_CLUSTER_CTX} sample namespace created"
kubectl create namespace sample --context=${REMOTE_CLUSTER_CTX} || echo "${REMOTE_CLUSTER_CTX} sample namespace created"
kubectl label namespace sample istio-injection=enabled --context=${MAIN_CLUSTER_CTX}
kubectl label namespace sample istio-injection=enabled --context=${REMOTE_CLUSTER_CTX}

kubectl apply -f ./samples/helloworld/helloworld-secondary.yaml -n sample --context=${REMOTE_CLUSTER_CTX}
kubectl apply -f ./samples/helloworld/helloworld-primary.yaml -n sample --context=${MAIN_CLUSTER_CTX}
kubectl apply -f ./samples/helloworld/helloworld-gateway.yaml -n sample --context=${REMOTE_CLUSTER_CTX}

kubectl apply -f ./samples/helloworld/helloworld-svc.yaml -n sample --context=${MAIN_CLUSTER_CTX}
kubectl apply -f ./samples/helloworld/helloworld-svc.yaml -n sample --context=${REMOTE_CLUSTER_CTX}

kubectl apply -f ./samples/sleep/sleep-primary.yaml -n sample --context=${MAIN_CLUSTER_CTX}
kubectl apply -f ./samples/sleep/sleep-secondary.yaml -n sample --context=${REMOTE_CLUSTER_CTX}

ISTIOD_REMOTE_EP=$(kubectl get svc -n istio-system --context=${REMOTE_CLUSTER_CTX} istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "ISTIOD_REMOTE_EP is ${ISTIOD_REMOTE_EP}"
echo "curl http://${ISTIOD_REMOTE_EP}/hello"