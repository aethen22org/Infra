# Introduction

This repository serves as an infra repository to run a kubernetes cluster locally on a Minikube cluster

## Contents

- charts - contains charts
    - base - contains chart base
- images - contains docker images
    - agent - contains agent docker image
- tools - contains tools to install in kubernetes
    - arc - contains arc configuration and deployment files
    - monitoring - contains monitoring tools
        - grafana - contains grafana configuration and deployment files
        - prometheus - contains prometheus configuration and deployment files
    - registry - contains registries
        - docker - contains docker registry configuration and deployment files
        - helm - contains helm registry configuration and deployment files

## Setup

### Requirements

- Minikube installed
- kubectl
- helm
- docker
- helmfile
- yq
- sops

### Step-by-step

After installing Minikube you have to start the cluster, we normally use a volume to save our registries there, it is done this way in case we loose access to the registries, as we can run a dockerized registry pointing to these volumes, so we can use them even if something goes badly

To start with this volume run this `minikube start --mount --mount-string="/path/to/your/local/repository/volumes:/volumes/" --network-plugin=cni --cni=bridge`

Why Minikube? Just so we can have the poor man's Lens by using `minikube dashboard` and so that we can use `minikube tunnel` instead of port-forwards, which makes it easier to run, run both before following with the next steps

After setting up Minikube we should start deploying our registries and arc, which we will use to deploy everything else, this is done via:

`helm install charts/base -f tools/registry/helm/dev/values.yaml`

`helm install charts/base -f tools/registry/docker/dev/values.yaml`

Follow [this](tools\arc\README.MD) documentation, or just run this command, but reading the documentation is advised, as you will need to get some values from github

`cd tools/arc && rm secrets.enc.yaml && chmod +x secrets.sh && ./secrets.sh`

With this, your cluster is set to run, but you need to push images to these repositories, so, lets start by creating and pushing the necessary tags via:

`git tag chart-base/v1.0.4`

We use version 1.0.4 because helmfiles are configured for that version, as it was the last working one

The first time we push the agent image, we need to do it manually, do this via

`eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)`
`mv charts/base images/agent/base`
`cd images/agent`
`docker build . --build-arg BUILDKIT_INLINE_CACHE=1 -t localhost:5000/agent:latest`
`docker push localhost:5000/agent -a`

Then just run this to return the repository to it's original state

`git restore .`

Launch image-agent cicd

`git tag image-agent/v1.0.1`

We use version 1.0.1 because our charts are configured for that version, as it was the last working one

`git push --tags`

Let the pipelines run and you should have both images on your registries, after that you can run the rest of the pipelines and deploy everything, this step should not be needed, as a GitOps tool should be setup, which would in turn deploy every helmfile