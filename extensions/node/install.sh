#!/bin/bash
#
# Embeddable NodeJS installer 1.0.0
#
# Installs an embeddable NodeJS version.
#
# Requirements:
# - python3
# - git
#
# (c)2023 Harald Schneider - marketmix.com

echo "Fetching NodeEnv ..."
echo "Please enter your login password, to run sudo ..."
rm ~/.nodeenvrc
sudo rm -rf ~/.npm
mkdir _runtime >/dev/null
cd _runtime
pip3 install -e git+https://github.com/ekalinin/nodeenv.git#egg=nodeenv

echo
echo "Installing ..."
chmod +x src/nodeenv/nodeenv.py
python3 src/nodeenv/nodeenv.py nodejs

echo
echo "Cleaning ..."
rm -rf src

echo "Activating NodeEnv ..."
source ./nodejs/bin/activate

echo "Adding extension's requirements ..."
sudo ./nodejs/bin/npm install -g ws

echo
echo "Deactivating NodeEnv ..."
deactivate_node

echo "Ready to embed NodeJS :-)"
echo "Done."
