#!/bin/bash

case "$1" in
  build_generator)
    docker build -t data-generator -f Dockerfile.generator .
    ;;
  run_generator)
    mkdir -p data
    docker run --rm -v "$(pwd)/data:/data" data-generator /data
    ;;
  create_local_data)
    mkdir -p local_data
    python generate.py local_data
    ;;
esac
