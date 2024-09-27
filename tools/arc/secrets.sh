#!/bin/bash

# Function for decrypting our sops secrets and then decrypting the base64 inside it into secrets.yaml
decryptSecretsYaml () {
    sops -d secrets.enc.yaml | yq '.data' | base64 -d > secrets.yaml
}

# Function for encrypting a secrets.yaml file into a secrets.enc.yaml sops-encrypted file
encryptSecretsYaml () {
    base64Secrets="data: \""
    base64Secrets+="$(cat secrets.yaml | base64 -w 0)"
    base64Secrets+=\"
    echo -n $base64Secrets > secrets.b64.yaml
    sops encrypt secrets.b64.yaml > secrets.enc.yaml
    rm -rf secrets.b64.yaml
}

# If we have secrets already in place, we decrypt them and upgrade, if not, we create a new one and install
if [ -f ./secrets.enc.yaml ]; then
  INSTALL=false
  echo "Decrypting secrets.enc.yaml"
  decryptSecretsYaml
else
  INSTALL=true
  echo "secrets.enc.yaml file not found"
  echo "You will be prompted for the required value to fill the secrets.enc.yaml file"
  echo "ARC will be deployed to the cluster you're connected to"
  echo "Input the Namespace where you will install ARC:"
  read NAMESPACE
  NAMESPACE="'.namespace= \"$NAMESPACE\"'"
  /bin/bash -c  "yq -n $NAMESPACE" > secrets.yaml
  echo "Input your Github Application ID:"
  read GITHUB_APPID
  GITHUB_APPID="'.github_application_id= \"$GITHUB_APPID\"'"
  /bin/bash -c  "yq -n $GITHUB_APPID" >> secrets.yaml
  echo "Input your Github Application Installation ID:"
  read GITHUB_INSTALLATION_ID
  GITHUB_INSTALLATION_ID="'.github_application_instalation_id= \"$GITHUB_INSTALLATION_ID\"'"
  /bin/bash -c  "yq -n $GITHUB_INSTALLATION_ID" >> secrets.yaml
  echo "Input your Github Application private key:"
  read GITHUB_APP_PRIVATE_KEY
  GITHUB_APP_PRIVATE_KEY="'.github_application_private_key= \"$GITHUB_APP_PRIVATE_KEY\"'"
  /bin/bash -c  "yq -n $GITHUB_APP_PRIVATE_KEY" >> secrets.yaml
  echo "Input your organization:"
  read ORG
  ORG="'.organization= \"$ORG\"'"
  /bin/bash -c  "yq -n $ORG" >> secrets.yaml
  encryptSecretsYaml
fi

# Get values from secrets.yaml
NAMESPACE=`yq '.namespace' secrets.yaml`
GITHUB_APPID=`yq '.github_application_id' secrets.yaml`
GITHUB_INSTALLATION_ID=`yq '.github_application_instalation_id' secrets.yaml`
GITHUB_APP_PRIVATE_KEY=`yq --unwrapScalar=false '.github_application_private_key' secrets.yaml`
echo "${GITHUB_APP_PRIVATE_KEY}"
ORG=`yq '.organization' secrets.yaml`

if [ "$INSTALL" = "true" ]; then
  # We create the namespace so the secrets can be created on it
  kubectl create namespace ${NAMESPACE}
  # Create kubernetes secrets
  kubectl create secret generic arc-gh-secret \
      --namespace="${NAMESPACE}" \
      --from-literal=github_app_id="${GITHUB_APPID}" \
      --from-literal=github_app_installation_id="${GITHUB_INSTALLATION_ID}" \
      --from-literal=github_app_private_key="${GITHUB_APP_PRIVATE_KEY}"
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
else
  # Delete Kubernetes secrets in case we need to replace them
  kubectl delete secret arc-gh-secret -n "${NAMESPACE}"
  # Create kubernetes secrets
  kubectl create secret generic arc-gh-secret \
      --namespace="${NAMESPACE}" \
      --from-literal=github_app_id="${GITHUB_APPID}" \
      --from-literal=github_app_installation_id="${GITHUB_INSTALLATION_ID}" \
      --from-literal=github_app_private_key="${GITHUB_APP_PRIVATE_KEY}"
fi