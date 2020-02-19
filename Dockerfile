# Base image
#============
FROM renovate/yarn:1.22.0@sha256:22cfbb7ecd47655a905c01fe3f2fcb3ac34839dd6d42d81eeb437c80475483ea AS base

LABEL maintainer="Michael Kries <michael.kriese@visualon.de"
LABEL name="test"
LABEL org.opencontainers.image.source="https://github.com/ViceIce/docker-buildx-tests"

WORKDIR /usr/src/app/

# required for install
USER root

RUN chown -R ubuntu:ubuntu /usr/src/app/


# Build image
#============
FROM base as tsbuild

RUN echo install more build deps

USER ubuntu

COPY package.json .
COPY yarn.lock .
RUN yarn install --frozen-lockfile

COPY lib lib
RUN cp -r lib/ dist/
RUN echo done > dist/test.txt

# Final image
#============
FROM base as final


# The git version of ubuntu 18.04 is too old to sort ref tags properly (see #5477), so update it to the latest stable version
RUN echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu bionic main\ndeb-src http://ppa.launchpad.net/git-core/ppa/ubuntu bionic main" > /etc/apt/sources.list.d/git.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24 && \
    apt-get update && \
    apt-get -y install git && \
    rm -rf /var/lib/apt/lists/*

# Docker client and group

RUN groupadd -g 999 docker
RUN usermod -aG docker ubuntu

ENV DOCKER_VERSION=19.03.1

RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz \
  && tar xzvf docker-${DOCKER_VERSION}.tgz --strip 1 \
  -C /usr/local/bin docker/docker \
  && rm docker-${DOCKER_VERSION}.tgz

# Slim image
#============
FROM final as slim

USER ubuntu

COPY --from=tsbuild /usr/src/app/dist dist
RUN touch full.txt
RUN cat dist/test.txt

# Full image
#============
FROM final as full

RUN apt-get update && apt-get install -y gpg curl wget unzip xz-utils openssh-client bsdtar build-essential && \
    rm -rf /var/lib/apt/lists/*


USER ubuntu

COPY --from=tsbuild /usr/src/app/dist dist
RUN touch full.txt
RUN cat dist/test.txt
