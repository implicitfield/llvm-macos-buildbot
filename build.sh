#!/bin/sh
if [ "$1" != "stage1" ]; then
    tar -xf build_directory.tar
fi
cp final/llvm-project/llvm/utils/release/test-release.sh .
patch -p1 < 0001-skip-tests.patch
patch -p1 < 0002-support-partitioned-builds.patch
./test-release.sh -release 16.0.0 -final -triple x86-64-apple-darwin21.0 -no-checkout -no-clang-tools -no-test-suite -no-openmp -no-polly -no-mlir -no-flang -use-gzip -"$1"
if [ "$1" != "stage3" ]; then
    tar -cf build_directory.tar final
    exit 0
fi
echo "{file_name}={clang+llvm-16.0.0-x86-64-apple-darwin21.0.tar.gz}" >> $GITHUB_STATE
echo "{release_tag_version}={16.0.0}" >> $GITHUB_STATE
mkdir output
mv final/clang+llvm-16.0.0-x86-64-apple-darwin21.0.tar.gz output/
