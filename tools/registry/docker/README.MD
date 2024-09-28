## README

These folders contains the helmfile and values for deploying a basic docker registry helm chart in your cluster

If you do not have a helm registry set-up, you can manually do the same process via `kubectl create namespace registries && helm install charts/base -f tools/registry/docker/YOUR_ENVIRONMENT/values.yaml -n registries`