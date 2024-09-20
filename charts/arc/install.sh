#!/bin/bash

# Function for decrypting our sops secrets and then decrypting the base64 inside it into secrets.yaml
decryptSecretsYaml () {
    sops -d secrets.enc.yaml | yq '.data' | base64 -d > secrets.yaml
}

decryptSecretsYaml

# Get values from secrets.yaml
NAMESPACE=`yq '.namespace' secrets.yaml`
GITHUB_APPID=`yq '.github_application_id' secrets.yaml`
GITHUB_INSTALLATION_ID=`yq '.github_application_instalation_id' secrets.yaml`
GITHUB_APP_PRIVATE_KEY=`yq '.github_application_private_key' secrets.yaml`
ORG=`yq '.organization' secrets.yaml`

# Create kubernetes secrets
kubectl create secret generic arc-gh-secret \
    --namespace="${NAMESPACE}" \
    --from-literal=github_app_id="${GITHUB_APPID}" \
    --from-literal=github_app_installation_id="${GITHUB_INSTALLATION_ID}" \
    --from-literal=github_app_private_key="$(GITHUB_APP_PRIVATE_KEY)"

# Install arc controller
helm install arc \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller \
    -f controller.values.yaml

# Install arc runner
helm install arc-runner-set \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --set githubConfigUrl="https://github.com/${ORG}" \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set \
    -f scaleset.values.yaml