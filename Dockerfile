FROM ubuntu:latest

# Cache layers for faster build
RUN apt-get update -y && \
    apt-get install -y git python3 python3-pip curl && \
    rm -rf /var/lib/apt/lists/*

# Install Visual Studio Code Server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create directory for SSH keys and set permissions
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh

# Set working directory
WORKDIR /dbt

# Add SSH key from the variable into the container
# Copy the file with the SSH key into the container
COPY private_ssh_key /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

# Add SSH key to known hosts
ARG GIT_REPO_NAME
RUN touch /root/.ssh/known_hosts && \
    ssh-keyscan "$GIT_REPO_NAME" >> /root/.ssh/known_hosts

# Set global Git user settings from environment variables
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
RUN git config --global user.email "$GIT_USER_EMAIL" && \
    git config --global user.name "$GIT_USER_NAME"

# Clone repository from the GIT_REPO_URL variable
ARG GIT_REPO_URL
RUN git clone $GIT_REPO_URL .

# Set PASSWORD variable for VSCode
ARG PASSWORD
ENV PASSWORD $PASSWORD

# Copy and install dbt dependencies
COPY requirements.txt /dbt/requirements.txt
RUN pip3 install -r requirements.txt

# Run code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "password", "."]
