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

COPY . test
RUN echo building

RUN mkdir dist
RUN echo done > dist/test.txt

# Slim image
#============
FROM base as slim

USER ubuntu

COPY --from=tsbuild /usr/src/app/dist dist
RUN touch full.txt
RUN cat dist/test.txt

# Full image
#============
FROM base as full

RUN echo install more deps

USER ubuntu

COPY --from=tsbuild /usr/src/app/dist dist
RUN touch full.txt
RUN cat dist/test.txt
