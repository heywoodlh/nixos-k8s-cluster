#!/usr/bin/env bash
helm uninstall -n argocd argo-cd
kubectl delete -n argocd Application/bootstrap-app

kubectl patch -n argocd Application bootstrap-app -p '{"metadata":{"finalizers":null}}' --type=merge
kubectl patch -n argocd Application argo-cd -p '{"metadata":{"finalizers":null}}' --type=merge
