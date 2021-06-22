#!/usr/bin/env bash

set -euo pipefail

NAMESPACE="$1"
OUTPUT_FILE="$2"

count=0
until kubectl get secret argocd-secret -n "${NAMESPACE}" > /dev/null 2>&1 ; do
  if [[ $count -eq 10 ]]; then
    echo "Timed out waiting for secret ${NAMESPACE}/argocd-secret"
    exit 1
  fi

  count=$((count + 1))
  echo "Waiting for secret ${NAMESPACE}/argocd-secret"
  kubectl get all -n "${NAMESPACE}"
  kubectl get secret -n "${NAMESPACE}"
  sleep 30
done

# kubectl get secret argocd-secret -n "${NAMESPACE}" -o jsonpath='{ .data.admin\.password }' | base64 -d > "${OUTPUT_FILE}"
kubectl -n "${NAMESPACE}" get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > "${OUTPUT_FILE}"