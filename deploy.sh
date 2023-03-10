#!/usr/bin/env bash

kubectl get ns/argocd &>/dev/null || kubectl create ns argocd
# Deploy argo-cd
helm dep update charts/argo-cd
helm list | grep -q argo-cd || helm upgrade -n argocd --install argo-cd charts/argo-cd/ -f ./charts/argo-cd/values.yaml

# Deploy bootstrap-app (wait 45 seconds for argo to deploy)
helm dep update bootstrap-apps
helm list | grep -q bootstrap-app &> /dev/null || echo 'waiting 45 seconds for argo to deploy' && sleep 45 
argo_args="--port-forward --port-forward-namespace argocd --plaintext"
# Login with argocd CLI
argocd login --username admin --password $(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d) ${argo_args}
# Create argo bootstrap-app
argocd app list ${argo_args} | grep -q bootstrap-app || argocd app create bootstrap-app --project security --repo https://github.com/heywoodlh/k8s-security.git
