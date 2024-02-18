#!/usr/bin/env bash
set -e

base_dir="$(pwd)"

rm -rf install
rm -rf vendor
rm -rf build

mkdir -p install
mkdir -p vendor

echo "Clone fmt"
git clone https://github.com/fmtlib/fmt vendor/fmt

echo "Checkout fmt 10.0.0"
cd vendor/fmt
git checkout 10.0.0
cd "${base_dir}"

echo "Build fmt"
cmake \
    -DCMAKE_PREFIX_PATH="${base_dir}/install" \
    -DCMAKE_INSTALL_PREFIX="${base_dir}/install" \
    -DFMT_DOC=OFF \
    -DFMT_TEST=OFF \
    -B vendor/fmt/build \
    vendor/fmt
cmake --build vendor/fmt/build -- install

echo "Clone spdlog"
git clone https://github.com/gabime/spdlog vendor/spdlog

echo "Build spdlog"
cmake \
    -DCMAKE_PREFIX_PATH="${base_dir}/install" \
    -DCMAKE_INSTALL_PREFIX="${base_dir}/install" \
    -DSPDLOG_FMT_EXTERNAL=ON \
    -DSPDLOG_BUILD_EXAMPLE=OFF \
    -B vendor/spdlog/build \
    vendor/spdlog
cmake --build vendor/spdlog/build -- install

echo "Build test"
cmake \
    -DCMAKE_PREFIX_PATH="${base_dir}/install" \
    -B build \
    .
cmake --build build -- all
./build/test
