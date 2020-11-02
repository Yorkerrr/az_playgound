#!/bin/bash

. utils.sh

CORE_DNS_PRIMARY_CLUSTER_IP=$(kubectl get svc -n istio-system istiocoredns -o jsonpath={.spec.clusterIP} --context ${MAIN_CLUSTER_CTX})
CORE_DNS_SECONDARY_CLUSTER_IP=$(kubectl get svc -n istio-system istiocoredns -o jsonpath={.spec.clusterIP} --context ${REMOTE_CLUSTER_CTX})

cat > coredns-primary.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns-custom
  namespace: kube-system
data:
  istio.server: |
    global:53 {
        errors
        cache 30
        forward . ${CORE_DNS_PRIMARY_CLUSTER_IP}:53
    }
EOF

cat > coredns-secondary.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns-custom
  namespace: kube-system
data:
  istio.server: |
    global:53 {
        errors
        cache 30
        forward . ${CORE_DNS_SECONDARY_CLUSTER_IP}:53
    }
EOF

kubectl apply -f coredns-primary.yaml --context ${MAIN_CLUSTER_CTX}
kubectl apply -f coredns-secondary.yaml --context ${REMOTE_CLUSTER_CTX}