# Introduction

This is a helm chart meant to be used as a requirement to create sub-charts from this fully configurable chart

## Defaults

By default, this chart deploys a service, a deployment and a hpa, these can all be configured through the values.yaml file, but these defaults should be left untouched

## Resources

This chart can deploy the following resources:

- deployment
- hpa
- ingress
- namespace
- persistentVolume
- persistentVolumeClaim
- service
- serviceAccount
- serviceMonitor

### TODO

We should have istio configurations, roleBindings and roles, but they are not done yet as they were not needed for the experiment

## Values

Values configuration is documented under values.yaml, any comment that contains code is an example of what should be filled