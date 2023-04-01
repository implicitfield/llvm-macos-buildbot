#!/bin/sh

# This is intentionally pinned to a specific commit in order to allow
# checksum verification.
curl -O https://raw.githubusercontent.com/Homebrew/install/de786ec51ca86d12de92ad4300ad72d3e209b1da/uninstall.sh
[ "$(shasum -a 512 uninstall.sh)" != "$(cat homebrew-uninstall-script-checksum.txt)" ] && exit 1
chmod +x uninstall.sh
sudo ./uninstall.sh --force

sudo rm -rf /usr/local/Homebrew
sudo rm -rf /usr/local/Caskroom
sudo rm -rf /usr/local/bin/brew
