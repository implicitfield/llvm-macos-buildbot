#!/bin/sh
[ ! -f llvm-project-16.0.0.src.tar.xz ] && curl -O -L https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.0/llvm-project-16.0.0.src.tar.xz
[ "$(shasum -a 512 llvm-project-16.0.0.src.tar.xz)" != "$(cat checksum.txt)" ] && exit 1
mkdir final
tar -xf llvm-project-16.0.0.src.tar.xz
mv llvm-project-16.0.0.src final/llvm-project
cp final/llvm-project/llvm/utils/release/test-release.sh .
patch -p1 < skip-tests.patch
./test-release.sh -release 16.0.0 -final -triple x86-64-apple-darwin22.0 -no-checkout -no-clang-tools -no-test-suite -no-openmp -no-polly -no-mlir -no-flang -use-gzip
echo "{file_name}={clang+llvm-16.0.0-x86-64-apple-darwin22.0.tar.gz}" >> $GITHUB_STATE
echo "{release_tag_version}={16.0.0}" >> $GITHUB_STATE
mkdir output
mv final/clang+llvm-16.0.0-x86-64-apple-darwin22.0.tar.gz output/
