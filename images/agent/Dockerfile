FROM ghcr.io/actions/actions-runner:latest

USER root

# Update and install basic dependencies
RUN apt update
RUN apt install -y \
    curl \
    build-essential \
    age \
    git \
    jq \
    libicu-dev \
    wget \
    unzip \
    make

# Install brew and run the necessary commands to set it up
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install brew utilities
RUN /home/linuxbrew/.linuxbrew/bin/brew install gcc yq sops kubectl helm

# Copy scripts for later usage
COPY scripts /home/runner/scripts

# Copy the age recipient into sops folder
COPY keys.txt /home/runner/sops/age/keys.txt

# Setup XDG_CONFIG_HOME and HOME environmental variable for sops
ENV XDG_CONFIG_HOME=/home/runner
ENV HOME=/home/runner

# Return to default user
USER runner