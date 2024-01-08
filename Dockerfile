# Docker container to reproduce results of JSON Schema Extraction

# Use a long-term maintained base distribution
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG="C.UTF-8"
ENV LC_ALL="C.UTF-8"

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
		build-essential \
		ca-certificates \
		curl \
		git \
		gnupg \
		make \
		sudo \
		texlive-base \
		texlive-bibtex-extra \
		texlive-fonts-extra \
		texlive-fonts-recommended \
		texlive-latex-base \
		texlive-latex-extra \
		texlive-publishers

# Import MongoDB public key
RUN curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

# Create list file for MongoDB
RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Reload local package database
RUN apt-get update

# Install MongoDB
RUN apt-get install -y mongodb-org

# Install Nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - &&\
   sudo apt-get install -y nodejs

# Add user
RUN useradd -m -G sudo -s /bin/bash repro | chpasswd
USER repro
WORKDIR /home/repro

# Clone project repository
RUN git clone https://github.com/gbd-ufsc/JSONSchemaDiscovery.git

# Install global  Node dependencies
USER root
WORKDIR /home/repro/JSONSchemaDiscovery
RUN npm install -g @angular/cli@13.3.3 && npm install -g typescript@4.6.3

# Change user
USER repro
WORKDIR /home/repro/JSONSchemaDiscovery

# Copy patches and apply node package patch
COPY ./patches /home/repro/patches
RUN patch package.json ../patches/package.json.patch

# Install local node dependencies
RUN npm install --legacy-peer-deps

# Apply node dependency patches
RUN patch node_modules/dotenv/lib/main.d.ts ../patches/main.d.ts.patch && \
   patch server/controllers/rawSchema/rawSchemaBatch.ts ../patches/rawSchemaBatch.ts.patch && \
   patch server/controllers/user/user.ts ../patches/user.ts.patch

# Run smoke test
COPY ./smoke.sh /home/repro/JSONSchemaDiscovery/smoke.sh
RUN ./smoke.sh

# Pull report repository
WORKDIR /home/repro
RUN git clone https://github.com/Nalto/RepEngReport.git
# RUN cd RepEngReport/ && make report
