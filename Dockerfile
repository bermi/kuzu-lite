# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM node:18-alpine AS base

# Common dependencies
RUN apk add --no-cache -X https://mirrors.aliyun.com/alpine/v3.21/main \
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

# Install kuzu
RUN yarn add kuzu

# Build for ARM64
FROM --platform=linux/arm64 base AS build-arm64
RUN cd /app/node_modules/kuzu/kuzu-source/tools/nodejs_api && \
    yarn install && \
    yarn build && \
    mkdir -p /app/node_modules/kuzu/prebuilt && \
    cp -f ./build/kuzujs.node /app/node_modules/kuzu/prebuilt/kuzujs-alpine-arm64.node

# Build for AMD64
FROM --platform=linux/amd64 base AS build-amd64
RUN cd /app/node_modules/kuzu/kuzu-source/tools/nodejs_api && \
    yarn install && \
    yarn build && \
    mkdir -p /app/node_modules/kuzu/prebuilt && \
    cp -f ./build/kuzujs.node /app/node_modules/kuzu/prebuilt/kuzujs-alpine-amd64.node

# Final stage to collect artifacts
FROM node:18-alpine AS final

WORKDIR /app

# Copy prebuilt binaries from both build stages
COPY --from=build-arm64 /app/node_modules/kuzu/prebuilt/kuzujs-alpine-arm64.node /app/prebuilt/
COPY --from=build-amd64 /app/node_modules/kuzu/prebuilt/kuzujs-alpine-amd64.node /app/prebuilt/

CMD [ "sh" ]
