#!/bin/sh
LLVM_RELEASE="$(cat llvm-release.txt)"
if [ "$1" != "stage1" ]; then
    tar -xf build_directory.tar
fi
cp final/llvm-project/llvm/utils/release/test-release.sh .
patch -p1 < 0001-skip-tests.patch
patch -p1 < 0002-support-partitioned-builds.patch
./test-release.sh -release "$LLVM_RELEASE" -final -triple x86-64-apple-darwin21.0 -no-checkout -no-clang-tools -no-test-suite -no-openmp -no-polly -no-mlir -no-flang -use-gzip -no-compare-files -"$1"
if [ "$1" != "stage3" ]; then
    tar -cf build_directory.tar final
    exit 0
fi
_release_tag_version="$LLVM_RELEASE"
[ "$(cat revision.txt)" -ne 0 ] && _release_tag_version="$_release_tag_version"-"$(cat revision.txt)"
echo "file_name=clang+llvm-$LLVM_RELEASE-x86-64-apple-darwin21.0.tar.gz" >> $GITHUB_OUTPUT
echo "release_tag_version=$_release_tag_version" >> $GITHUB_OUTPUT
shasum -a 512 final/clang+llvm-"$LLVM_RELEASE"-x86-64-apple-darwin21.0.tar.gz | sed 's,final/,,' > github_release_text.txt
mkdir output
mv final/clang+llvm-"$LLVM_RELEASE"-x86-64-apple-darwin21.0.tar.gz output/
