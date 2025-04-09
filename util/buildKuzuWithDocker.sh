#!/bin/bash
APP_ROOT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}")/..; pwd)

SYSTEM="$(uname -o)"
if [ $SYSTEM == "Msys" ]
then
    export MSYS2_ARG_CONV_EXCL="*"
    APP_ROOT_DIR="$(cygpath -w $APP_ROOT_DIR)"
    echo "Msys"
fi


docker buildx build -t kuzu-lite:latest -f ${APP_ROOT_DIR}/Dockerfile ./

docker run --rm \
    -v ${APP_ROOT_DIR}:/kuzu-lite \
    kuzu-lite:latest /bin/sh -c "
        cd /kuzu-lite && \
        cp -f /kuzu-lite/prebuilt/*.node /kuzu-lite
    "
    
run_test() {
    local arch=$1
    local node_file=$2
    
    echo "Running tests on $arch architecture..."
    docker run --rm \
        --platform linux/$arch \
        -v ${APP_ROOT_DIR}:/kuzu-lite \
        node:18-alpine /bin/sh -c "
            cd /kuzu-lite && \
            cp -f /kuzu-lite/prebuilt/$node_file /kuzu-lite/kuzujs.node && \
            cd /kuzu-lite/util && \
            node ./test.js 
        "
}


# Run tests for different architectures
run_test "arm64" "kuzujs-alpine-arm64.node"
run_test "amd64" "kuzujs-alpine-x64.node"

echo "All tests completed successfully!"

echo "Please use 'yarn release' to release the package to npm!"