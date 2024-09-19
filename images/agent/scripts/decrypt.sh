#!/bin/bash

decryptSecretsYaml () {
    sops -d repo/ops/$1/secrets.enc.yaml | yq '.data' | base64 -d > repo/ops/$1/secrets.yaml
}

environments=("local" "dev" "sta" "prod" )

for str in ${environments[@]}; do
  decryptSecretsYaml $str
done