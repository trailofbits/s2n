#!/bin/bash

set -e

DB=$1
START_SYM=$2

cat screen/python/comp_db_generate.py

python3 screen/python/comp_db_generate.py -o ./build.sh -l screen/build/llvm ${DB} generate

/bin/bash ./build.sh # > /dev/null

python3 screen/python/comp_db_generate.py -o - -l screen/build/llvm ${DB} dump
LIB=$(python3 screen/python/comp_db_generate.py -o - -l screen/build/llvm ${DB} dump)
echo LIB: $LIB
LIB_PATH=$(dirname ${LIB})

./screen/build/llvm/bin/opt \
  -load screen/build/lib/screen.so -screen \
  -screen-output screen_output.txt \
  -screen-start-symbol ${START_SYM} ${LIB} -o ${LIB_PATH}/xformed.bc || true

# Python3.5 should have just been installed for a different depency
python3 -m ensurepip --user
python3 -m pip install --user boto3
python3 ./screen/python/submit_results.py -c ${TRAVIS_COMMIT} screen_output.txt
