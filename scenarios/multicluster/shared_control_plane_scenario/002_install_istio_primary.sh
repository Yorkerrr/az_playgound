#!/bin/bash

. utils.sh

cat > istio-main-cluster.yaml <<EOF
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  namespace: istio-system
  name: istio-control-plane
spec:
  values:
    global:
      multiCluster:
        clusterName: ${MAIN_CLUSTER_NAME}
      network: ${MAIN_CLUSTER_NETWORK}

      # Mesh network configuration. This is optional and may be omitted if
      # all clusters are on the same network.
      meshNetworks:
        ${MAIN_CLUSTER_NETWORK}:
          endpoints:
          - fromRegistry: ${MAIN_CLUSTER_NAME}
          gateways:
          - registry_service_name: istio-ingressgateway.istio-system.svc.cluster.local
            port: 443

        ${REMOTE_CLUSTER_NETWORK}:
          endpoints:
          - fromRegistry: ${REMOTE_CLUSTER_NAME}
          gateways:
          - registry_service_name: istio-ingressgateway.istio-system.svc.cluster.local
            port: 443

      # Use the existing istio-ingressgateway.
      meshExpansion:
        enabled: true
EOF

istioctl install -f istio-main-cluster.yaml --context=${MAIN_CLUSTER_CTX}
