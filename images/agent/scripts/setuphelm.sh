#!/bin/bash
# Setup brew env's so we can use helm, then add the registry and get it's contents
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
helm repo add helm-registry http://helm-registry.helm-registry.svc.cluster.local:8080/charts
helm repo update