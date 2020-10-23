# Base image
#============
FROM renovate/yarn AS base

LABEL maintainer="Michael Kries <michael.kriese@visualon.de"
LABEL name="test"
LABEL org.opencontainers.image.source="https://github.com/viceice-tests/docker-buildx-tests"

WORKDIR /usr/src/app/

# required for install
USER root

RUN chown -R ubuntu:0 /usr/src/app/


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

RUN apt-get update && apt-get install -y build-essential && \
    rm -rf /var/lib/apt/lists/*


USER ubuntu

COPY --from=tsbuild /usr/src/app/dist dist
RUN touch full.txt
RUN cat dist/test.txt
