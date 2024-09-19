FROM ubuntu:22.04

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
    unzip

# Install brew and run the necessary commands to set it up
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /root/.bashrc
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install gcc for compatilibity
RUN /home/linuxbrew/.linuxbrew/bin/brew install gcc

# Install yq and sops for secret management
RUN /home/linuxbrew/.linuxbrew/bin/brew install yq
RUN /home/linuxbrew/.linuxbrew/bin/brew install sops

# Create a non-root user
RUN useradd -m -s /bin/bash github

# Define variables for GitHub Runner version and URL
ARG RUNNER_VERSION="2.319.1"
ARG RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"

# Create a directory for the runner
RUN mkdir -p /home/agent && chown github:github /home/agent

# Switch to non-root user
USER github

# Download and install the GitHub Actions runner
RUN curl -L $RUNNER_URL -o /tmp/actions-runner.tar.gz \
    && tar -xzf /tmp/actions-runner.tar.gz -C /home/agent \
    && rm /tmp/actions-runner.tar.gz

# Switch to root user
USER root

# Install runner dependencies
RUN /home/agent/bin/installdependencies.sh

# Set a workdir and copy scripts for later usage
WORKDIR /home/agent/
COPY scripts /home/agent/scripts

# Clean the kitchen
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Give execution permission to entrypoint
RUN chmod +x scripts/entrypoint.sh

# Switch to non-root user
USER github

# Copy the age recipient into sops folder
COPY keys.txt /home/agent/sops/age/keys.txt

# Copy our ssh key into the image so that we can clone repositories
COPY id_rsa.pub /root/.ssh/id_rsa.pub

# Setup XDG_CONFIG_HOME and HOME environmental variable for sops
ENV XDG_CONFIG_HOME=/home/agent
ENV HOME=/home/agent

# Set up entrypoint
ENTRYPOINT ["/home/agent/scripts/entrypoint.sh"]