#!/usr/bin/env python3

import configparser
import hashlib
import os
import pathlib
import subprocess
import sys
import urllib
from urllib.parse import urlparse
from urllib.request import urlopen

version_only = False
for arg in sys.argv:
    if arg == "-v":
        version_only = True
        sys.argv.remove("-v")
        break

if len(sys.argv) < 2:
    print("ERROR: invalid usage")
    sys.exit(1)

config = configparser.ConfigParser()
try:
    with open(sys.argv[1], 'r') as f:
        config.read_file(f)
except Exception as e:
    print(f"ERROR: ({str(e)})")
    sys.exit(1)

archive_extensions = ['.tar.bz', 'tar.gz', '.tar.xz', '.zip']

def process(string, version):
    return string.replace('[VERSION]', version)

def process_section(section):
    version = config[section]['version']
    if version_only:
        print(f"{version}")
        return
    output = process(os.path.basename(urlparse(config[section]['url']).path), version)
    already_valid = False
    if os.path.isfile(output):
        print(f"INFO: checking checksum for cached {section}...", end='')
        with open(output, 'rb') as f:
            contents = f.read()
            if hashlib.sha512(contents).hexdigest() == config[section]['sha512']:
                already_valid = True
                print(" OK")
            else:
                print(f" FAILED, redownloading")
        if not already_valid:
            pathlib.Path(output).unlink()

    if not already_valid:
        print(f"INFO: downloading {section}...", end='')
        url = process(config[section]['url'], version)
        try:
            with urlopen(url) as r:
                contents = r.read()
        except Exception as e:
            print(f" FAILED ({str(e)})")
            sys.exit(1)
        if hashlib.sha512(contents).hexdigest() != config[section]['sha512']:
            print(" FAILED (checksum mismatch)")
            sys.exit(1)
        with open(output, 'wb') as f:
            f.write(contents)
        print(" OK")

    archive = False
    for extension in archive_extensions:
        if output.endswith(extension):
            archive = True
            break

    if archive:
        args = ['bsdtar', '-xf', output]
        if 'remove_components' in config[section]:
            args.append('--strip-components')
            args.append(config[section]['remove_components'])
        if 'pattern' in config[section]:
            args.append('-s')
            args.append(process(config[section]['pattern'], version))
        code = subprocess.run(args).returncode
        if code != 0:
            sys.exit(code)

if len(sys.argv) == 2:
    for section in config.sections():
        process_section(section)
    sys.exit(0)
for section in sys.argv[2:]:
    process_section(section)
