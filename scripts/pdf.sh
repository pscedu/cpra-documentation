#!/bin/bash

# Download the GitHub Markdown TOC tool.
mkdir -p bin
[ ! -f bin/gh-md-toc ] && wget -O bin/gh-md-toc https://raw.githubusercontent.com/ekalinin/github-markdown-toc/master/gh-md-toc
chmod +x bin/gh-md-toc

# Compile all MP2029 documents into a single file.
cat mp2029/technical_requirements.md > pdf/mp2029.md
printf "\n\n" >> pdf/mp2029.md
cat ../cpra.mp.data/docs/index.md >> pdf/mp2029.md
printf "\n\n" >> pdf/mp2029.md
sed 's/# CPRA Master Plan Data/# Reading and Writing Model Data/g' ../cpra.mp.data/README.md >> pdf/mp2029.md
printf "\n\n" >> pdf/mp2029.md
cat mp2029/model_data_storage.md >> pdf/mp2029.md
printf "\n\n" >> pdf/mp2029.md
cat mp2029/implementation.md >> pdf/mp2029.md
printf "\n\n" >> pdf/mp2029.md

# Add table of contents.
./bin/gh-md-toc pdf/mp2029.md > pdf/mp2029-toc.md
printf "\n\n" >> pdf/mp2029-toc.md
cat pdf/mp2029.md >> pdf/mp2029-toc.md

# Convert to PDF.
node ./scripts/document_pdf.mjs pdf/mp2029-toc.md pdf/mp2029.pdf
rm pdf/mp2029.md pdf/mp2029-toc.md