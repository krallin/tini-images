#!/bin/bash
set -o errexit
set -o nounset

./src/autogen.sh
pushd autogen

for dir in *; do
  pushd "$dir"
  echo "Building ${dir}"
  docker build .
  popd
done


