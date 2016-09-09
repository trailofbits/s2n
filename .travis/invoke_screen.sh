#!/bin/bash

set -e

DB=$1
START_SYM=$2

cat screen/python/comp_db_generate.py

python3 screen/python/comp_db_generate.py -o ./build.sh -l screen/build/llvm ${DB} generate

/bin/bash ./build.sh > /dev/null

python3 screen/python/comp_db_generate.py -o - -l screen/build/llvm ${DB} dump
LIB=$(python3 screen/python/comp_db_generate.py -o - -l screen/build/llvm ${DB} dump)
echo Built lib: $LIB
LIB_PATH=$(dirname ${LIB})

time ./screen/build/llvm/bin/opt \
  -load screen/build/lib/screen.so -screen \
  -screen-output screen_output.txt \
  -screen-start-symbol ${START_SYM} ${LIB} -o ${LIB_PATH}/xformed.bc || true

# TODO run pagai on bc, assuming on linux and this build works on travis's 14.04 
wget https://sourceforge.net/projects/boost/files/boost/1.58.0/boost_1_58_0.tar.gz/download
tar zxf download
cd  boost_1_58_0
./bootstrap.sh --exec-prefix=/usr/local --libdir=/usr/lib/x86_64-linux-gnu --includedir=/usr/lib/x86_64-linux-gnu --with-libraries=atomic,date_time,exception,filesystem,iostreams,locale,program_options,regex,signals,system,test,thread,timer,log
./b2
sudo ./b2 install
cd ..
# Install Z3
wget "https://github.com/Z3Prover/z3/archive/29606b5179f76783ffb0c2ca0ed9d614847064b3.tar.gz" -O z3-29606b5179f76783ffb0c2ca0ed9d614847064b3.tar.gz
tar zxf z3-29606b5179f76783ffb0c2ca0ed9d614847064b3.tar.gz 
cd z3-29606b5179f76783ffb0c2ca0ed9d614847064b3
CXX=clang++ CC=clang python scripts/mk_make.py
cd build
make
sudo make install
cd ../../
./screen/pagai/linux_src/pagai -h
time ./screen/pagai/linux_src/pagai -i ${LIB} --output-bc-v2 ${LIB} || true

time ./screen/build/llvm/bin/opt \
  -load screen/build/lib/range.so -invariant_analysis -invariant-debug\
  -invariant-output invariant_output.txt \
  ${LIB} -o ${LIB_PATH}/xformed.bc || true

# Python3.5 should have just been installed for a different depency
python3 -m ensurepip --user
python3 -m pip install --user boto3
echo "cat screen_output.txt"
echo "cat invariant_output.txt"
cat screen_output.txt
cat invariant_output.txt
echo "${TRAVIS_COMMIT}"
echo "python3 ./screen/python/submit_results.py -c ${TRAVIS_COMMIT} -p trailofbits/s2n -k 2a47f0fa600a405cdc5d4ac1fc310b6d screen_output.txt invariant_output.txt"
python3 ./screen/python/submit_results.py -c ${TRAVIS_COMMIT} -p trailofbits/s2n -k 2a47f0fa600a405cdc5d4ac1fc310b6d screen_output.txt invariant_output.txt
