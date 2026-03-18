#!/bin/sh
set -eu
LLVM_RELEASE="$(./fetch_dependencies.py downloads.ini -v LLVM)"
if [ "$2" != "stage1" ]; then
    tar -xf build_directory.tar.gz
fi
cp final/llvm-project/llvm/utils/release/test-release.sh .
patch -p1 < 0001-skip-tests.patch
patch -p1 < 0002-support-partitioned-builds.patch
patch -p1 < 0003-use-built-in-xz-compression.patch
./test-release.sh -release "$LLVM_RELEASE" -final -triple "$1"-apple-darwin24.0 -no-checkout -no-clang-tools -no-test-suite -no-openmp -no-polly -no-mlir -no-flang -no-compare-files -use-ninja -configure-flags -DLLVM_APPEND_VC_REV=OFF -"$2"
if [ "$2" != "stage3" ]; then
    tar -cf - final | gzip -1 > build_directory.tar.gz
    exit 0
fi
_release_tag_version="$LLVM_RELEASE"-"$1"
REVISION="$(cat revision.txt)"
[ "$REVISION" -ne 0 ] && _release_tag_version="$_release_tag_version"-"$REVISION"
echo "file_name=clang+llvm-$LLVM_RELEASE-$1-apple-darwin24.0.tar.xz" >> $GITHUB_OUTPUT
echo "release_tag_version=$_release_tag_version" >> $GITHUB_OUTPUT
printf 'SHA512 checksum:\n<code>' > github_release_text.md
printf "$(shasum -a 512 final/clang+llvm-"$LLVM_RELEASE"-$1-apple-darwin24.0.tar.xz | sed 's,final/,,' | sed 's, ,\&nbsp;,g')" >> github_release_text.md
printf '</code>\n' >> github_release_text.md
mkdir output
mv final/clang+llvm-"$LLVM_RELEASE"-"$1"-apple-darwin24.0.tar.xz output/
