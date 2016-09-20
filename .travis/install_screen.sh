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
sudo apt-get install libapron libapron-dev libapron-ocaml-dev 
# need cudd yices and boost, export path in invoke script

echo "Installing boost"
wget -O boost.tar.gz "http://downloads.sourceforge.net/project/boost/boost/1.58.0/boost_1_58_0.tar.gz?r=&ts=1474322412&use_mirror=heanet"
tar zxf boost.tar.gz
pushd boost_1_58_0/
./bootstrap.sh
sudo ./b2 -m0 install
popd
