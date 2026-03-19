#!/bin/sh
set -eu
./fetch_dependencies.py downloads.ini CMake Ninja
sudo cp -r CMake.app/Contents/bin/* /usr/local/bin/
sudo cp -r CMake.app/Contents/share/* /usr/local/share/
sudo cp ninja /usr/local/bin
