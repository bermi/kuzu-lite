# 1. 在宿主机（非容器内）安装 QEMU
# sudo apt-get install qemu-user-static  # Debian/Ubuntu

# re-install kuzu for clean all build info
yarn remove kuzu
yarn add kuzu


# 2. run qemu-aarch64-alpine and qemu-amd64-alpine

docker rm -f qemu-aarch64-alpine `
&& `
docker run -it `
--name qemu-aarch64-alpine `
-v .\node_modules\kuzu:/kuzu `
--platform linux/arm64 `
node:18-alpine

 
docker rm -f qemu-amd64-alpine `
&& `
docker run -it `
--platform linux/amd64 `
-v .\node_modules\kuzu:/kuzu `
--name qemu-amd64-alpine `
node:18-alpine



# 3. go to kuzu source

cd /kuzu/kuzu-source/tools/nodejs_api


# 4. run ***yarn***

yarn install
 

# 5. install  dependencies  (alpine)
apk add --no-cache -X https://mirrors.aliyun.com/alpine/v3.21/main  \
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

# 5.1 install  dependencies  (ubuntu)

sudo apt update
sudo apt install -y \
    g++ \
    make \
    cmake \
    python3 \
    libssl-dev \
    zlib1g-dev \
    musl-tools \
    musl-dev \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    build-essential \
    pkg-config \
    wget \
    curl


# 6.  yarn build
yarn build

# 7.  copy the kuzujs.node to kuzujs-alpine-arm64.node
cp -f ./build/kuzujs.node ./../../../prebuilt/kuzujs-alpine-arm64.node
