# syntax=docker/dockerfile:1.4

# ----- amd64 构建 -----
FROM --platform=linux/amd64 node:18-alpine  AS build-amd64
WORKDIR /app
RUN echo "Building for $(uname -m)"
RUN apk add --no-cache  \
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
    
RUN yarn cache clean && yarn add kuzu --force
RUN cd /app/node_modules/kuzu/kuzu-source/tools/nodejs_api && \
    sed -i 's/THREADS =/THREADS = 1;\/\//' build.js && \
    yarn install 
RUN yarn build  
   
RUN mkdir -p /app/node_modules/kuzu/prebuilt  && \
    cp -f /app/node_modules/kuzu/kuzu-source/tools/nodejs_api/build/kuzujs.node /app/node_modules/kuzu/prebuilt/kuzujs-linux-amd64.node

# ----- arm64 构建 -----
FROM --platform=linux/arm64 node:18-alpine  AS build-arm64
WORKDIR /app
RUN echo "Building for $(uname -m)"
RUN apk add --no-cache \
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

RUN yarn cache clean && yarn add kuzu --force
RUN cd /app/node_modules/kuzu/kuzu-source/tools/nodejs_api && \
    sed -i 's/THREADS =/THREADS = 1;\/\//' build.js && \
    yarn install 
RUN yarn build  
   
RUN mkdir -p /app/node_modules/kuzu/prebuilt  && \
    cp -f /app/node_modules/kuzu/kuzu-source/tools/nodejs_api/build/kuzujs.node /app/node_modules/kuzu/prebuilt/kuzujs-linux-arm64.node