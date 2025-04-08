FROM node:18-alpine as base

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

WORKDIR /app

RUN yarn add kuzu

RUN cd /app/node_modules/kuzu/kuzu-source/tools/nodejs_api && \
    yarn install && \
    yarn build 
 
