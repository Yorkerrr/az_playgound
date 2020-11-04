#!/bin/bash
. utils.sh
echo "Verify Primary cluster Sleep to Secondary cluster via ingress gw:"
ISTIOD_REMOTE_EP=$(kubectl get svc -n istio-system --context=${REMOTE_CLUSTER_CTX} istio-secondary-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
nohup bash -c "while true; do echo 'Internal GW to helloworld-secondary'; curl -s curl http://${ISTIOD_REMOTE_EP}/hello; done" &

echo "Verify Primary cluster Sleep to Secondary cluster via helloworld-secondary:5000/hello"

nohup kubectl exec --context="${MAIN_CLUSTER_CTX}" -n sample -c sleep-primary \
    "$(kubectl get pod --context="${MAIN_CLUSTER_CTX}" -n sample -l \
    app=sleep-primary -o jsonpath='{.items[0].metadata.name}')" \
    -- sh -c 'for i in `seq 1 10`; do curl -s helloworld-secondary:5000/hello; done' &

# echo "Verify Secondary cluster Sleep to Primary cluster via helloworld-primary.sample.global:5000/hello"
# kubectl exec --context="${REMOTE_CLUSTER_CTX}" -n sample -c sleep \
#     "$(kubectl get pod --context="${REMOTE_CLUSTER_CTX}" -n sample -l \
#     app=sleep -o jsonpath='{.items[0].metadata.name}')" \
#     -- sh -c 'for i in `seq 1 10`; do curl -s helloworld-primary.sample.global:5000/hello; done'