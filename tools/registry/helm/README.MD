## README

These folders contains the helmfile and values for deploying a basic docker registry helm chart in your cluster

If you do not have a helm registry set-up, you can manually do the same process via `kubectl create namespace registries && helm install charts/base -f tools/registry/helm/YOUR_ENVIRONMENT/values.yaml -n registries`

After this is setup, you should have access to your helm repository and can start pushing to it.