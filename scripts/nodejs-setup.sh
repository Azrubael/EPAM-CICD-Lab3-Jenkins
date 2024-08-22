#!/bin/bash

sudo apt update

sudo apt install -y curl
curl -O https://nodejs.org/dist/v7.8.0/node-v7.8.0-linux-x64.tar.xz
tar -xf node-v7.8.0-linux-x64.tar.xz
sudo mv node-v7.8.0-linux-x64 /usr/local/node
sudo ln -s /usr/local/node/bin/node /usr/local/bin/node
sudo ln -s /usr/local/node/bin/npm /usr/local/bin/npm
echo ""
echo "Node version:"
node -v
echo ""
echo "NPM version:"
npm -v
