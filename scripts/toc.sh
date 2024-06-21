#!/bin/bash

# Download the GitHub Markdown TOC tool
mkdir -p bin
[ ! -f bin/gh-md-toc ] && wget -O bin/gh-md-toc https://raw.githubusercontent.com/ekalinin/github-markdown-toc/master/gh-md-toc
chmod +x bin/gh-md-toc

# Root TOC
printf "# Coastal Master Plan Documentation\n\n" > README.md
printf "## [2023 Coastal Master Plan](mp2023/README.md)\n" >> README.md
bin/gh-md-toc \
    mp2023/technical_summary.md \
    mp2023/models.md >> README.md
printf "\n## [2029 Coastal Master Plan](mp2029/README.md)\n" >> README.md
bin/gh-md-toc \
    mp2029/technical_requirements.md \
    mp2029/model_data_storage.md \
    mp2029/implementation.md >> README.md

# MP2023 TOC
cd mp2023
printf "# 2023 Coastal Master Plan Documentation\n" > README.md
../bin/gh-md-toc \
    technical_summary.md \
    models.md >> README.md

# MP2029 TOC
cd ../mp2029
printf "# 2029 Coastal Master Plan Documentation\n" > README.md
../bin/gh-md-toc \
    technical_requirements.md \
    model_data_storage.md \
    implementation.md >> README.md
