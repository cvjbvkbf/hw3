#!/bin/bash
set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

case "$1" in
  build_generator)
    echo -e "${GREEN}Building generator image...${NC}"
    docker build -t data-generator -f Dockerfile.generator .
    ;;

  run_generator)
    mkdir -p data
    echo -e "${GREEN}Running generator container...${NC}"
    docker run --rm -v "$(pwd)/data:/data" data-generator /data
    echo -e "${GREEN}Generated data/data.csv${NC}"
    ;;

  create_local_data)
    mkdir -p local_data
    echo -e "${GREEN}Generating CSV locally...${NC}"
    python generate.py local_data
    echo -e "${GREEN}Created local_data/data.csv${NC}"
    ;;

  build_reporter)
    echo -e "${GREEN}Building reporter image...${NC}"
    docker build -t data-reporter -f Dockerfile.reporter .
    ;;

  run_reporter)
    if [ ! -f data/data.csv ]; then
      echo -e "${RED}Error: data/data.csv not found. Run './run.sh run_generator' first.${NC}"
      exit 1
    fi
    mkdir -p data
    echo -e "${GREEN}Running reporter container...${NC}"
    docker run --rm -v "$(pwd)/data:/data" data-reporter
    echo -e "${GREEN}Generated data/report.html${NC}"
    ;;

  structure)
    echo -e "${GREEN}Project structure:${NC}"
    find . -not -path "*/\.*" -not -path "*/data/*" -not -path "*/local_data/*" | sort | sed 's/[^/]*\//|-- /g;s/|-- //'
    ;;

  clear_data)
    echo -e "${GREEN}Clearing data/ directory...${NC}"
    rm -f data/*.csv data/*.html 2>/dev/null || true
    echo -e "${GREEN}Done. data/ is empty.${NC}"
    ;;

  inside_generator)
    echo -e "${GREEN}Contents of /data from inside generator container:${NC}"
    docker run --rm -v "$(pwd)/data:/data" data-generator ls -la /data
    ;;

  inside_reporter)
    echo -e "${GREEN}Contents of /data from inside reporter container:${NC}"
    docker run --rm -v "$(pwd)/data:/data" data-reporter ls -la /data
    ;;

  *)
    echo "Usage: $0 {build_generator|run_generator|create_local_data|build_reporter|run_reporter|structure|clear_data|inside_generator|inside_reporter}"
    exit 1
    ;;
esac
