#!/bin/sh
set -eu
./fetch_dependencies.py downloads.ini LLVM
mkdir final
mv llvm-project final
# llvm/llvm-project/issues/127764
patch -p1 -d final/llvm-project < patches/46de3200388c300ee871f5b4941dff0d97ba9480.patch
