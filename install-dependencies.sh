#!/bin/sh
set -eu
CMAKE_RELEASE="$(cat cmake-release.txt)"
curl -O -L https://github.com/Kitware/CMake/releases/download/v"$CMAKE_RELEASE"/cmake-"$CMAKE_RELEASE"-macos10.10-universal.tar.gz
[ "$(shasum -a 512 cmake-$CMAKE_RELEASE-macos10.10-universal.tar.gz)" != "$(cat cmake-checksum.txt)" ] && exit 1
tar -xf cmake-"$CMAKE_RELEASE"-macos10.10-universal.tar.gz
sudo cp -r cmake-"$CMAKE_RELEASE"-macos10.10-universal/CMake.app/Contents/bin/* /usr/local/bin/
sudo cp -r cmake-"$CMAKE_RELEASE"-macos10.10-universal/CMake.app/Contents/share/* /usr/local/share/

NINJA_RELEASE="$(cat ninja-release.txt)"
curl -O -L https://github.com/ninja-build/ninja/releases/download/v"$NINJA_RELEASE"/ninja-mac.zip
[ "$(shasum -a 512 ninja-mac.zip)" != "$(cat ninja-checksum.txt)" ] && exit 1
bsdtar -xf ninja-mac.zip
sudo cp ninja /usr/local/bin
