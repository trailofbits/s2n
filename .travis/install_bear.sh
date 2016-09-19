#!/bin/bash

# set -e

onerr() {
    echo "Errored"
}
trap onerr ERR

# First, install bear
mkdir -p bear/build

wget -O Bear-2.2.0.tar.gz https://github.com/rizsotto/Bear/archive/2.2.0.tar.gz
tar xfz Bear-2.2.0.tar.gz --strip-components=1 -C bear

pushd bear/build
cmake .. 
make 
make install
popd


