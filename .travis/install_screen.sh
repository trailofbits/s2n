#!/bin/bash

# set -e

# onerr() {
#     echo "Errored"
# }
# trap onerr ERR

# First, install bear
mkdir -p bear/build

wget -O Bear-2.2.0.tar.gz https://github.com/rizsotto/Bear/archive/2.2.0.tar.gz
tar xfz Bear-2.2.0.tar.gz --strip-components=1 -C bear

pushd bear/build
echo CC: $CC
echo CXX: $CXX
echo PATH: $PATH
clang -v
clang-3.8 -v 

cmake .. 
make 
make install
popd

git clone https://${GH_TOKEN}@github.com/trailofbits/screen.git
pushd screen
./build.sh
popd

