# 在宿主机（非容器内）安装 QEMU
sudo apt-get install qemu-user-static  # Debian/Ubuntu

# 复制 QEMU 模拟器到容器
docker rm -f qemu-aarch64-alpine \
&& \
docker run -it \
--name qemu-aarch64-alpine \
--platform linux/arm64 \
  -v /usr/bin/qemu-aarch64-static:/usr/bin/qemu-aarch64-static \
node:18-alpine

 
# docker rm -f qemu-amd64-alpine \
# && \
# docker run -it \
# --platform linux/amd64 \
# --name qemu-amd64-alpine \
# node:18-alpine


1. vscode attach to running container
2. install the kuzu
```
yarn add kuzu
```

3. go to kuzu source

cd ./node_modules/kuzu
then goto kuzu-source/tools/nodejs_api

4. modify the build.js  THREADS=2

5. run ***yarn***

6.
apk add --no-cache \
    g++ \
    gcompat \
    libc6-compat \
    build-base \
    python3 \
    nodejs-npm \
    libressl-dev \
    musl-libresolv \
    make \
    cmake \
    zlib-dev \
    musl-dev

7.  yarn build

8.  copy the kuzujs.node to kuzujs-alpine-arm64.node
