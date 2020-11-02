#!/bin/bash

. utils.sh

kubectl create namespace sample --context=${MAIN_CLUSTER_CTX} || echo "${MAIN_CLUSTER_CTX} sample namespace created"
kubectl create namespace sample --context=${REMOTE_CLUSTER_CTX} || echo "${REMOTE_CLUSTER_CTX} sample namespace created"
kubectl label namespace sample istio-injection=enabled --context=${MAIN_CLUSTER_CTX}
kubectl label namespace sample istio-injection=enabled --context=${REMOTE_CLUSTER_CTX}

kubectl apply -f ./samples/helloworld/helloworld-v2.yaml -n sample --context=${REMOTE_CLUSTER_CTX}
kubectl apply  -f ./samples/helloworld/helloworld-gateway.yaml -n sample --context=${MAIN_CLUSTER_CTX}
kubectl apply  -f ./samples/helloworld/helloworld-v2.yaml -l app=helloworld-v2 -n sample --context=${MAIN_CLUSTER_CTX}

kubectl apply -f ./samples/sleep/sleep.yaml -n sample --context=${MAIN_CLUSTER_CTX}
kubectl apply -f ./samples/sleep/sleep.yaml -n sample --context=${REMOTE_CLUSTER_CTX}

ISTIOD_REMOTE_EP=$(kubectl get svc -n istio-system --context=${MAIN_CLUSTER_CTX} istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "ISTIOD_REMOTE_EP is ${ISTIOD_REMOTE_EP}"
echo "curl http://${ISTIOD_REMOTE_EP}/hello"