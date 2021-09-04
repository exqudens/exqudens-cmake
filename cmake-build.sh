#!/bin/bash

set -e

cmake -S "." --preset "${1}"
cmake --build --preset "${1}" --target "exqudens-cmake-cpp-test-executable"
echo 'BUILD_SUCCESSFUL' || (echo 'BUILD_FAILED' && false)
