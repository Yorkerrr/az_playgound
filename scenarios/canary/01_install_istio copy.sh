#!/bin/bash
. utils.sh

istioctl install --set profile=demo
kubectl label namespace default istio-injection=enabled