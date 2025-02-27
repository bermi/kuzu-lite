FROM node:18-alpine

USER root

apk add --no-cache \
    g++ \
    gcompat \
    libc6-compat \
    build-base \
    python3 \
    libressl-dev \
    make \
    cmake \
    zlib-dev \
    musl-dev


## for run the kuzu
apk add --no-cache   gcompat libc6-compat