#!/bin/sh
set -eu
LLVM_RELEASE="$(cat llvm-release.txt)"
[ ! -f llvm-project-"$LLVM_RELEASE".src.tar.xz ] && curl -O -L https://github.com/llvm/llvm-project/releases/download/llvmorg-"$LLVM_RELEASE"/llvm-project-"$LLVM_RELEASE".src.tar.xz
[ "$(shasum -a 512 llvm-project-"$LLVM_RELEASE".src.tar.xz)" != "$(cat checksum.txt)" ] && exit 1
mkdir final
tar -xf llvm-project-"$LLVM_RELEASE".src.tar.xz
mv llvm-project-"$LLVM_RELEASE".src final/llvm-project
# llvm/llvm-project/issues/127764
patch -p1 -d final/llvm-project < 46de3200388c300ee871f5b4941dff0d97ba9480.patch
