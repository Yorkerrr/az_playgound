#!/bin/bash

. utils.sh

kubectl apply -f ./samples/addons/prometheus.yaml -n istio-system --context=${REMOTE_CLUSTER_CTX}
# kubectl apply -f ./samples/addons/kiali.yaml -n istio-system --context=${REMOTE_CLUSTER_CTX}
kubectx primary
bash <(curl -L https://kiali.io/getLatestKialiOperator) --accessible-namespaces '**' --auth-strategy 'anonymous' --helm-repo-chart-version 'v1.25' --operator-image-version 'v1.25'
kubectx secondary
bash <(curl -L https://kiali.io/getLatestKialiOperator) --accessible-namespaces '**' --auth-strategy 'anonymous' --helm-repo-chart-version 'v1.25' --operator-image-version 'v1.25'
kubectl apply -f ./samples/addons/prometheus.yaml -n istio-system --context=${MAIN_CLUSTER_CTX}
# kubectl apply -f ./samples/addons/kiali.yaml -n istio-system --context=${MAIN_CLUSTER_CTX}