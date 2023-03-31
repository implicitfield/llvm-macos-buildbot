#!/bin/sh
[ ! -f llvm-project-16.0.0.src.tar.xz ] && curl -O -L https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.0/llvm-project-16.0.0.src.tar.xz
[ "$(shasum -a 512 llvm-project-16.0.0.src.tar.xz)" != "$(cat checksum.txt)" ] && exit 1
mkdir final
tar -xf llvm-project-16.0.0.src.tar.xz
mv llvm-project-16.0.0.src final/llvm-project
