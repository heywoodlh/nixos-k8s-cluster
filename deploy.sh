#!/usr/bin/env bash

kubectl get ns/argocd &>/dev/null || kubectl create ns argocd
# Deploy argo-cd
helm dep update charts/argo-cd
helm list | grep -q argo-cd || helm upgrade -n argocd --install argo-cd charts/argo-cd/ -f ./charts/argo-cd/values.yaml
# Deploy bootstrap-app (wait 45 seconds for argo to deploy)
helm dep update bootstrap-apps
helm list | grep -q bootstrap-app || echo 'waiting 45 seconds for argo to deploy' && sleep 45 && helm upgrade -n argocd --install bootstrap-app apps/ -f ./apps/values.yaml
