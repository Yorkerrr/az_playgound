#!/bin/bash

. utils.sh

kubectl create namespace sample --context=${MAIN_CLUSTER_CTX} || echo "${MAIN_CLUSTER_CTX} sample namespace created"
kubectl create namespace sample --context=${REMOTE_CLUSTER_CTX} || echo "${REMOTE_CLUSTER_CTX} sample namespace created"
kubectl label namespace sample istio-injection=enabled --context=${MAIN_CLUSTER_CTX}
kubectl label namespace sample istio-injection=enabled --context=${REMOTE_CLUSTER_CTX}

kubectl apply -f ./samples/helloworld/helloworld-secondary.yaml -n sample --context=${REMOTE_CLUSTER_CTX}
kubectl apply -f ./samples/helloworld/helloworld-primary.yaml -n sample --context=${MAIN_CLUSTER_CTX}
kubectl apply -f ./samples/helloworld/helloworld-gateway.yaml -n sample --context=${REMOTE_CLUSTER_CTX}

kubectl apply -f ./samples/sleep/sleep-primary.yaml -n sample --context=${MAIN_CLUSTER_CTX}
kubectl apply -f ./samples/sleep/sleep-secondary.yaml -n sample --context=${REMOTE_CLUSTER_CTX}

ISTIOD_REMOTE_EP=$(kubectl get svc -n istio-system --context=${REMOTE_CLUSTER_CTX} istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "ISTIOD_REMOTE_EP is ${ISTIOD_REMOTE_EP}"
echo "curl http://${ISTIOD_REMOTE_EP}/hello"

PRIMARY_GW_ADDR=$(kubectl get --context=$MAIN_CLUSTER_CTX svc --selector=app=istio-ingressgateway -n istio-system -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')
SECONDARY_GW_ADDR=$(kubectl get --context=$REMOTE_CLUSTER_CTX svc --selector=app=istio-ingressgateway -n istio-system -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')

cat > service-entry-primary.yaml <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: helloworld-primary
spec:
  hosts:
  # must be of form name.namespace.global
  - helloworld-secondary.sample.global
  # Treat remote cluster services as part of the service mesh
  # as all clusters in the service mesh share the same root of trust.
  location: MESH_INTERNAL
  ports:
  - name: http1
    number: 5000
    protocol: http
  resolution: DNS
  addresses:
  # the IP address to which httpbin.bar.global will resolve to
  # must be unique for each remote service, within a given cluster.
  # This address need not be routable. Traffic for this IP will be captured
  # by the sidecar and routed appropriately.
  - 240.0.0.2
  endpoints:
  # This is the routable address of the ingress gateway in cluster2 that
  # sits in front of sleep.foo service. Traffic from the sidecar will be
  # routed to this address.
  - address: ${SECONDARY_GW_ADDR}
    ports:
      http1: 15443 # Do not change this port value
EOF

cat > service-entry-secondary.yaml <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: helloworld-secondary
spec:
  hosts:
  # must be of form name.namespace.global
  - helloworld-primary.sample.global
  # Treat remote cluster services as part of the service mesh
  # as all clusters in the service mesh share the same root of trust.
  location: MESH_INTERNAL
  ports:
  - name: http1
    number: 5000
    protocol: http
  resolution: DNS
  addresses:
  # the IP address to which httpbin.bar.global will resolve to
  # must be unique for each remote service, within a given cluster.
  # This address need not be routable. Traffic for this IP will be captured
  # by the sidecar and routed appropriately.
  - 240.0.0.2
  endpoints:
  # This is the routable address of the ingress gateway in cluster2 that
  # sits in front of sleep.foo service. Traffic from the sidecar will be
  # routed to this address.
  - address: ${PRIMARY_GW_ADDR}
    ports:
      http1: 15443 # Do not change this port value
EOF


kubectl apply -f service-entry-primary.yaml -n sample --context=${MAIN_CLUSTER_CTX}
kubectl apply -f service-entry-secondary.yaml -n sample --context=${REMOTE_CLUSTER_CTX}