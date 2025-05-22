#!/bin/bash

# Script that only compiles KuzuDB extensions, supports KUZU_DIR environment variable
# apk add --no-cache openssl openssl-dev
APP_ROOT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}")/..; pwd)
KUZU_SOURCE_DIR="$APP_ROOT_DIR/node_modules/kuzu/kuzu-source"
EXTENSION_DIR="${KUZU_SOURCE_DIR}/extension"


SYSTEM="$(uname -o)"
if [ "$SYSTEM" = "Msys" ]; then
    export MSYS2_ARG_CONV_EXCL="*"
    echo "Msys"
    APP_ROOT_DIR="$(cygpath -w $APP_ROOT_DIR)"
    KUZU_SOURCE_DIR="$(cygpath -w $KUZU_SOURCE_DIR)"
    EXTENSION_DIR="$(cygpath -w $EXTENSION_DIR)"
fi

#EXTENSION_LIST="$(find "${EXTENSION_DIR}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | grep -v '^duckdb$' | sort | tr '\n' ';' | sed 's/;$//')"
EXTENSION_LIST="httpfs;json;fts;vector;neo4j;algo"
echo "Automatically detected extension list: ${EXTENSION_LIST}"

if [ ! -f "${KUZU_SOURCE_DIR}/CMakeLists.txt" ] || [ ! -d "${KUZU_SOURCE_DIR}/extension" ]; then
    echo "Error: Please run this script in the root directory of the kuzu repository, or set the KUZU_DIR environment variable to point to the kuzu source directory"
    echo "Current KUZU_SOURCE_DIR: ${KUZU_SOURCE_DIR}"
    exit 1
fi

BUILD_DIR="${KUZU_SOURCE_DIR}/build_extensions"
if [ ! -d "$BUILD_DIR" ]; then
    mkdir "$BUILD_DIR"
fi

cd "$BUILD_DIR" || exit 1

# Check if already compiled, if so delete it
if [ -d "extension" ]; then
    echo "Detected existing extension directory, deleting..."
    rm -rf extension
fi

echo "Configuring CMake to build only extensions..."
echo "Source directory: ${KUZU_SOURCE_DIR}"
cmake "${KUZU_SOURCE_DIR}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_EXTENSIONS="${EXTENSION_LIST}" \
    -DOPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so \
    -DOPENSSL_SSL_LIBRARY=/usr/lib/libssl.so \
    -DOPENSSL_USE_STATIC_LIBS=OFF \
    -DBUILD_KUZU=FALSE 

CORES=$(nproc --all)
echo "Using $CORES cores for compilation..."

# Use all target for compilation (more generic)
cmake --build . -- -j"$CORES"

echo "All extensions compiled successfully!"

#check cpu architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    echo "Detected x86_64 architecture"
    ARCH="amd64"
elif [ "$ARCH" = "aarch64" ]; then
    echo "Detected aarch64 architecture"
    ARCH="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

EXTENSION_DIST_DIR="${KUZU_SOURCE_DIR}/extension/alpine-${ARCH}"
mkdir -p $EXTENSION_DIST_DIR
find "${KUZU_SOURCE_DIR}/extension" -type f -path "*/build/*.kuzu_extension" -exec cp {} $EXTENSION_DIST_DIR \;

# find "/app/node_modules/kuzu/kuzu-source/extension" -type f -path "*/build/*.kuzu_extension" -exec cp {} /app/extensions/alpine-amd64 \;

echo "All extensions have been copied to the $EXTENSION_DIST_DIR directory"