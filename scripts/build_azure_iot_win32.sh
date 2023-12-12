#!/bin/bash

cd $(dirname $0)

# if threadx repo does not exist, clone it
[ -d ../test/cmake/threadx ] || git clone https://github.com/azure-rtos/threadx.git ../test/cmake/threadx --depth 1

cd ../test/cmake/azure_iot
mkdir build_win32
cd build_win32
cmake .. -A win32
cmake --build .