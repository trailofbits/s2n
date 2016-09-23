#!/bin/bash

# set -e

onerr() {
    echo "Errored"
}
trap onerr ERR

echo "Installing screen"
rm -rf screen
git clone https://${GH_TOKEN}@github.com/trailofbits/screen.git -b prebuild-deps 
pushd screen
cat python/comp_db_generate.py 
./build.sh
popd

echo "Installing dependancies for pagai"
sudo apt-get install libmpfr-dev libgmp3-dev zlib1g-dev flex bison libncurses-dev 
# need cudd yices and boost, export path in invoke script

