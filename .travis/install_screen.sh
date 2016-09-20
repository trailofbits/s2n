#!/bin/bash

# set -e

onerr() {
    echo "Errored"
}
trap onerr ERR

echo "Installing screen"
rm -rf screen
git clone https://${GH_TOKEN}@github.com/trailofbits/screen.git
pushd screen
./build.sh
popd

echo "Installing dependancies for pagai"
sudo apt-get install libapron libapron-dev libapron-ocaml-dev libmpfr-dev flex bison libncurses-dev libgmp3-dev zlib1g-dev
# need cudd yices and boost, export path in invoke script

