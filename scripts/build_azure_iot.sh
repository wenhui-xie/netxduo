#! /bin/bash

$(dirname `realpath $0`)/../test/cmake/azure_iot/run.sh build all
cd $(dirname $0)/../test/cmake/azure_iot/build/default_build_coverage
for i in `find . -name "*.a"`; do arm-none-eabi-size --totals $i; echo ""; done