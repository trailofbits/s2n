#!/bin/bash

set -e

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
    sudo apt-add-repository "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.8 main" -y
    sudo apt-get update -q 
    sudo apt-get install --force-yes -y clang-3.8 lldb-3.8 
    sudo apt-get clean
    sudo apt-get autoremove 
fi


# First, install bear
mkdir -p bear/build

wget -O Bear-2.2.0.tar.gz https://github.com/rizsotto/Bear/archive/2.2.0.tar.gz
tar xfz Bear-2.2.0.tar.gz --strip-components=1 -C bear

pushd bear/build
cmake .. -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
make 
make install
popd

git clone https://${GH_TOKEN}@github.com/trailofbits/screen.git
pushd screen
./build.sh
popd

