#!/bin/sh
LLVM_RELEASE="21.1.3"
if [ "$2" != "stage1" ]; then
    tar -xf build_directory.tar
fi
cp final/llvm-project/llvm/utils/release/test-release.sh .
patch -p1 < 0001-skip-tests.patch
patch -p1 < 0002-support-partitioned-builds.patch
patch -p1 < 0003-use-built-in-xz-compression.patch
./test-release.sh -release "$LLVM_RELEASE" -final -triple "$1"-apple-darwin21.0 -no-checkout -no-clang-tools -no-test-suite -no-openmp -no-polly -no-mlir -no-flang -no-compare-files -configure-flags -DLLVM_APPEND_VC_REV=OFF -"$2"
if [ "$2" != "stage3" ]; then
    tar -cf build_directory.tar final
    exit 0
fi
_release_tag_version="$LLVM_RELEASE"-"$1"
[ "$(cat revision.txt)" -ne 0 ] && _release_tag_version="$_release_tag_version"-"$(cat revision.txt)"
echo "file_name=clang+llvm-$LLVM_RELEASE-$1-apple-darwin21.0.tar.xz" >> $GITHUB_OUTPUT
echo "release_tag_version=$_release_tag_version" >> $GITHUB_OUTPUT
printf 'SHA512 checksum:\n<code>' > github_release_text.md
printf "$(shasum -a 512 final/clang+llvm-"$LLVM_RELEASE"-$1-apple-darwin21.0.tar.xz | sed 's,final/,,' | sed 's, ,\&nbsp;,g')" >> github_release_text.md
printf '</code>\n' >> github_release_text.md
mkdir output
mv final/clang+llvm-"$LLVM_RELEASE"-"$1"-apple-darwin21.0.tar.xz output/
