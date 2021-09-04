#!/bin/bash

set -e

cmake -S "." --preset "${1}"
echo 'BUILD_SUCCESSFUL' || (echo 'BUILD_FAILED' && false)
