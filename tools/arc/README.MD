## Introduction

This folder contains the necessary files to install [Actions Runner Controller](https://github.com/actions/actions-runner-controller) in a context with our custom image from images/agents

## Requirements

You need to have sops, yq, base64 and cat installed in a linux or mac environment

You need to have a local registry created, deply [this hemlfile](tools/registry/docker/dev/helmfile.yaml) to set it up, if you dont have the helm image pushed on a repository that you can use(and thus, makes the helmfile apply fail), you can do this locally from the project source via `kubectl create namespace registries && helm install charts/base -f tools/registry/helm/dev/values.yaml -n registries`

## Usage

Run [secrets.sh](secrets.sh) and it should work as long as you have the requirements, if you have the secrets.enc.yaml file(or are using mine), it will upgrade an existing installation, so if you have a secrets.enc.yaml file but no installation on your configured cluster, delete this file

If you run it without a secrets.enc.yaml you will be prompted for 5 values:

-   The Namespace where arc will be installed
-   The GitHub Application ID([Guide here](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/authenticating-to-the-github-api#authenticating-arc-with-a-github-app))
-   The GitHub Application Installation ID([Guide here](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/authenticating-to-the-github-api#authenticating-arc-with-a-github-app))
-   The GitHub Application Private Key([Guide here](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/authenticating-to-the-github-api#authenticating-arc-with-a-github-app))
-   The GitHub Organization

After this process finishes you will have an installation that follows the values of controller.values.yaml and scaleset.values.yaml

Alternatively, you can run helmfile apply and create the secrets manually with the lines 24-48 of our secrets.sh script, read carefully to create the secrets correctly, and make sure that the private key is on a multiline value as in `github_application_private_key: |`