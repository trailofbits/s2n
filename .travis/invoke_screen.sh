#!/bin/bash

set -e

DB=$1
START_SYM=$2
echo "Starting invoke of screen"
cat screen/python/comp_db_generate.py
python3 screen/python/comp_db_generate.py -o ./build.sh -l screen/build/llvm ${DB} generate

/bin/bash ./build.sh > /dev/null

python3 screen/python/comp_db_generate.py -o - -l screen/build/llvm ${DB} dump
LIB=$(python3 screen/python/comp_db_generate.py -o - -l screen/build/llvm ${DB} dump)
LIB=./lib/libs2n.bc
echo Built lib: $LIB
LIB_PATH=$(dirname ${LIB})

time ./screen/build/llvm/bin/opt \
  -load screen/build/lib/screen.so -screen \
  -screen-output screen_output.txt \
  -screen-start-symbol ${START_SYM} ${LIB} -o ${LIB_PATH}/xformed.bc

echo "cat screen_output.txt"
cat screen_output.txt


pushd ./screen/pagai2
echo "Fetching pagai's external dependancies"
./fetch_externals.sh
export CUDD_PATH=./external/cudd
export YICES_PATH=./external/yices
export Z3_PATH=./external/z3
export BOOST_ROOT=./external/boost
cmake . 
make
popd

PAGAI_BC="./screen/build/llvm/bin/llvm-link -o pagai_lib.bc " 
grep -l -r -i screen_start ./ | grep ".c" | grep -Ev './screen/|screen.|util-linux' | ( while read -r line ; do PAGAI_BC="$PAGAI_BC ${line%?}bc"; done 
echo "$PAGAI_BC"
eval $PAGAI_BC )
echo "time ./screen/pagai2/src/pagai -i pagai_lib.bc --output-bc-v2 ${LIB} || true"
time ./screen/pagai2/src/pagai -i pagai_lib.bc --output-bc-v2 ${LIB} || true
echo "PAGAI RUN FINISHED"
time ./screen/build/llvm/bin/opt \
  -load screen/build/lib/range.so -invariant_analysis -invariant-debug\
  -invariant-output invariant_output.txt \
  ${LIB} -o ${LIB_PATH}/xformed.bc 

# Python3.5 should have just been installed for a different depency
python3 -m ensurepip --user
python3 -m pip install --user boto3
echo "cat invariant_output.txt"
cat invariant_output.txt
echo "${TRAVIS_COMMIT}"
echo "python3 ./screen/python/submit_results.py -c ${TRAVIS_COMMIT} -p trailofbits/s2n -k 2a47f0fa600a405cdc5d4ac1fc310b6d screen_output.txt invariant_output.txt"
python3 ./screen/python/submit_results.py -c ${TRAVIS_COMMIT} -p trailofbits/s2n -k 2a47f0fa600a405cdc5d4ac1fc310b6d screen_output.txt invariant_output.txt
