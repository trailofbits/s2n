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
wget http://downloads.sourceforge.net/project/boost/boost/1.58.0/boost_1_58_0.tar.gz?r=&ts=1474322412&use_mirror=heanet
mv boost_1_58_0.tar.gz\?r\= boost_1_58_0.tar.gz
tar zxf boost_1_58_0.tar.gz
pushd boost_1_58_0/
./bootstrap.sh
./b2 install
popd
