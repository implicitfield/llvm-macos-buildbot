#!/bin/sh

set -eu

./fetch_dependencies.py downloads.ini uninstall.sh

chmod +x uninstall.sh
sudo ./uninstall.sh --force

sudo rm -rf /opt/homebrew
sudo rm -rf /usr/local/Homebrew
sudo rm -rf /usr/local/Caskroom
sudo rm -rf /usr/local/bin/brew

# Remove additional Python versions
sudo rm -rf /Library/Frameworks/Python.framework
