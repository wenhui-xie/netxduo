#!/bin/bash

cd $(dirname $0)

# if threadx repo does not exist, clone it
[ -d ../test/cmake/threadx ] || git clone https://github.com/azure-rtos/threadx.git ../test/cmake/threadx --depth 1