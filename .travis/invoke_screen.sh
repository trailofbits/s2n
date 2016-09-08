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

./screen/build/llvm/bin/opt \
  -load screen/build/lib/screen.so -screen \
  -screen-output screen_output.txt \
  -screen-start-symbol ${START_SYM} ${LIB} -o ${LIB_PATH}/xformed.bc || true

# Python3.5 should have just been installed for a different depency
python3 -m ensurepip --user
python3 -m pip install --user boto3
echo "cat screen_output.txt"
cat screen_output.txt
echo "${TRAVIS_COMMIT}"
echo "python3 ./screen/python/submit_results.py -c ${TRAVIS_COMMIT} -p trailofbits/s2n -k 2a47f0fa600a405cdc5d4ac1fc310b6d screen_output.txt"
python3 ./screen/python/submit_results.py -c ${TRAVIS_COMMIT} -p trailofbits/s2n -k 2a47f0fa600a405cdc5d4ac1fc310b6d screen_output.txt
