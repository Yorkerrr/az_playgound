#!/bin/bash

. utils.sh

ISTIOD_REMOTE_EP=$(kubectl get svc -n istio-system --context=${MAIN_CLUSTER_CTX} istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "ISTIOD_REMOTE_EP is ${ISTIOD_REMOTE_EP}"

cat > istio-secondary-cluster.yaml <<EOF
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  namespace: istio-system
  name: istio-secondary-plane
spec:
  values:
    global:
      # The remote cluster's name and network name must match the values specified in the
      # mesh network configuration of the primary cluster.
      multiCluster:
        clusterName: ${REMOTE_CLUSTER_NAME}
      network: ${REMOTE_CLUSTER_NETWORK}

      # Replace ISTIOD_REMOTE_EP with the the value of ISTIOD_REMOTE_EP set earlier.
      remotePilotAddress: ${ISTIOD_REMOTE_EP}

  # The istio-ingressgateway is not required in the remote cluster if both clusters are on
  # the same network. To disable the istio-ingressgateway component, uncomment the lines below.
  
  components:
   ingressGateways:
   - name: istio-ingressgateway
     enabled: false
   - name: istio-secondary-ingressgateway
     enabled: true
EOF

istioctl install -f istio-secondary-cluster.yaml --context ${REMOTE_CLUSTER_CTX}