#!/bin/bash
. utils.sh
echo "Verify Primary cluster Sleep to Secondary cluster via ingress gw:"
ISTIOD_REMOTE_EP=$(kubectl get svc -n istio-system --context=${REMOTE_CLUSTER_CTX} istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
for i in {1..10}
do
curl -s curl http://${ISTIOD_REMOTE_EP}/hello
done

echo "Verify Primary cluster Sleep to Secondary cluster via helloworld-secondary.sample:5000/hello"

kubectl exec --context="${MAIN_CLUSTER_CTX}" -n sample -c sleep-primary \
    "$(kubectl get pod --context="${MAIN_CLUSTER_CTX}" -n sample -l \
    app=sleep-primary -o jsonpath='{.items[0].metadata.name}')" \
    -- sh -c 'for i in `seq 1 10`; do curl -s helloworld-secondary.sample:5000/hello; done'

echo "Verify Secondary cluster Sleep to Primary cluster via helloworld-primary.sample:5000/hello"
kubectl exec --context="${REMOTE_CLUSTER_CTX}" -n sample -c sleep-secondary \
    "$(kubectl get pod --context="${REMOTE_CLUSTER_CTX}" -n sample -l \
    app=sleep-secondary -o jsonpath='{.items[0].metadata.name}')" \
    -- sh -c 'for i in `seq 1 10`; do curl -s helloworld-primary.sample:5000/hello; done'

echo "Verify Secondary cluster Sleep to Primary cluster via helloworld.sample:5000/hello"
kubectl exec --context="${REMOTE_CLUSTER_CTX}" -n sample -c sleep-secondary \
    "$(kubectl get pod --context="${REMOTE_CLUSTER_CTX}" -n sample -l \
    app=sleep-secondary -o jsonpath='{.items[0].metadata.name}')" \
    -- sh -c 'for i in `seq 1 10`; do curl -s helloworld.sample:5001/hello; done'