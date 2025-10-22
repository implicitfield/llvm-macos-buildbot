#!/bin/sh
LLVM_RELEASE="$(cat llvm-release.txt)"
[ ! -f llvm-project-"$LLVM_RELEASE".src.tar.xz ] && curl -O -L https://github.com/llvm/llvm-project/releases/download/llvmorg-"$LLVM_RELEASE"/llvm-project-"$LLVM_RELEASE".src.tar.xz
[ "$(shasum -a 512 llvm-project-"$LLVM_RELEASE".src.tar.xz)" != "$(cat checksum.txt)" ] && exit 1
mkdir final
tar -xf llvm-project-"$LLVM_RELEASE".src.tar.xz
mv llvm-project-"$LLVM_RELEASE".src final/llvm-project
patch -p1 -R -d final/llvm-project < 4dec62f4d4a0a496a8067e283bf66897fbf6e598.patch
# llvm/llvm-project/issues/155532
patch -p1 -d final/llvm-project < d64802d6d96ec5aff3739ce34f8143b935921809.patch
# llvm/llvm-project/issues/127764
patch -p1 -d final/llvm-project < add-rtsan-libcxx-dependency.patch
