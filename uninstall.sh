#!/usr/bin/env bash
helm uninstall -n argocd bootstrap-app
helm uninstall -n argocd argo-cd

kubectl patch -n argocd Application bootstrap-app -p '{"metadata":{"finalizers":null}}' --type=merge
kubectl patch -n argocd Application argo-cd -p '{"metadata":{"finalizers":null}}' --type=merge
