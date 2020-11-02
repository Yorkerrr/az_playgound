#!/bin/bash
. utils.sh
ARGO_PASS="$(kubectl get pods \
  -n argocd \
  -l app.kubernetes.io/name=argocd-server \
  -o "jsonpath={.items[0].metadata.name}" \
  --context ${MAIN_CLUSTER_CTX})"

echo "Argocd Pass: ${ARGO_PASS}"
GW_IP="$(kubectl -n istio-system get services istio-ingressgateway \
  -o "jsonpath={.status.loadBalancer.ingress[0].ip}" --context ${MAIN_CLUSTER_CTX})"

echo "URL: http://$GW_IP"

