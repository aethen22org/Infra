## Introduction

This folder contains the dockerfile for a simple ci/cd agent

## Features

This ci/cd agent has the following tools installed:
- curl
- git
- age
- wget
- unzip
- actions runner
- yq
- sops
- make
- kubectl 
- helmfile
- helm

Of which:
- yq
- sops
- kubectl 
- helmfile
- helm

Were installed with brew, if you need to use them, run `eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"` before running them

## Building

It copies(and need) a keys.txt file, which is an age recipient used by sops to decrypt your secrets, you can create one with:

`age-keygen -o keys.txt`

If this was meant for a production setting, then that file should be retrieved from a secure vault with RBAC and delete lines 27-29