#!/bin/sh

# This is intentionally pinned to a specific commit in order to allow
# checksum verification.
curl -O https://raw.githubusercontent.com/Homebrew/install/de786ec51ca86d12de92ad4300ad72d3e209b1da/uninstall.sh
[ "$(shasum -a 512 uninstall.sh)" != "$(cat homebrew-uninstall-script-checksum.txt)" ] && exit 1
chmod +x uninstall.sh
sudo ./uninstall.sh --force

sudo rm -rf /opt/homebrew
sudo rm -rf /usr/local/Homebrew
sudo rm -rf /usr/local/Caskroom
sudo rm -rf /usr/local/bin/brew

# Since we just removed CMake, let's add it back.
CMAKE_RELEASE="$(cat cmake-release.txt)"
curl -O -L https://github.com/Kitware/CMake/releases/download/v"$CMAKE_RELEASE"/cmake-"$CMAKE_RELEASE"-macos10.10-universal.tar.gz
[ "$(shasum -a 512 cmake-$CMAKE_RELEASE-macos10.10-universal.tar.gz)" != "$(cat cmake-checksum.txt)" ] && exit 1
tar -xf cmake-"$CMAKE_RELEASE"-macos10.10-universal.tar.gz
sudo cp -r cmake-"$CMAKE_RELEASE"-macos10.10-universal/CMake.app/Contents/bin/* /usr/local/bin/
sudo cp -r cmake-"$CMAKE_RELEASE"-macos10.10-universal/CMake.app/Contents/share/* /usr/local/share/

# Remove additional Python versions
sudo rm -rf /Library/Frameworks/Python.framework
