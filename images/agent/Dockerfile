FROM ubuntu:22.04

# Update and install basic dependencies
RUN apt update
RUN apt install -y curl git build-essential age
# Install brew and run the necessary commands to set it up
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /root/.bashrc
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# Install gcc for compatilibity
RUN /home/linuxbrew/.linuxbrew/bin/brew install gcc
# Install yq and sops for secret management
RUN /home/linuxbrew/.linuxbrew/bin/brew install yq
RUN /home/linuxbrew/.linuxbrew/bin/brew install sops

# Copy the age recipient into sops folder
COPY keys.txt /root/sops/age/keys.txt
# Copy our ssh key into the image so that we can clone repositories
COPY id_rsa.pub /root/.ssh/id_rsa.pub

# Set a workdir and copy stuff for later
WORKDIR /home/agent/
COPY scripts /home/agent/scripts


ENV XDG_CONFIG_HOME=/root