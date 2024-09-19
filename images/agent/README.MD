## Introduction

This folder contains the dockerfile for a simple ci/cd agent

## Features

This ci/cd agent has the following tools installed:
- curl
- git
- age
- yq
- sops

It copies(and need) a keys.txt file, which is an age recipient used by sops to decrypt your secrets, you can create one with:

`age-keygen -o keys.txt`

It also copies(and need) a id_rsa.pub file, which should have the ssh keys needed for it to download whichever repository, [this guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) will walk you through the proccess

If this was meant for a production setting, then those files should be retrieved from a secure vault with RBAC and delete lines 16-19

