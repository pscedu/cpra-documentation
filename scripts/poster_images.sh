#!/bin/bash

# Generate poster images.
mkdir -p image
npx mmdc -i mp2023/technical_summary.md \
    -t neutral -c style/poster.json -b transparent -s 5 \
    -o image/poster.png