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

echo "installing dependancies for pagai"
sudo apt-get install libapron libapron-dev libapron-ocaml-dev libz3-gmp
# need cudd yices and boost, export path in invoke script
