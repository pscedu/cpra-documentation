// Extract Mermaid diagrams as PDFs.
// Requires pdfcrop (Fedora package: texlive-pdfcrop)

import child_process from "node:child_process";
import fs from "fs/promises";
import { run } from "@mermaid-js/mermaid-cli";

await fs.mkdir("pdf", {recursive: true});

const readme = (await fs.readFile("README.md")).toString();
const mermaidPattern = new RegExp("#+ (.*)\n+```mermaid([^`]+)```", "mg");
const names = [];

// Extract Mermaid diagrams, and save them as MMDs
await Promise.all(Array.from(readme.matchAll(mermaidPattern)).map((match) => {
  const name = match[1]
  .toLowerCase()
  .replace(/\(.*\)/, "")
  .replace(/[^a-z0-9]+/, " ")
  .trim()
  .replace(/ +/g, "-");

  names.push(name);
  return fs.writeFile(`pdf/${name}.mmd`, match[2]);
}));

// Convert MMDs to PDFs
await Promise.all(names.map((name) => run(`pdf/${name}.mmd`, `pdf/${name}-full.pdf`, {
  puppeteerConfig: {headless: 1}
})));

// Remove MMDs
await Promise.all(names.map((name) => fs.unlink(`pdf/${name}.mmd`)));

// Crop PDFs to image
await Promise.all(names.map((name) => child_process.exec(
  `pdfcrop --margins 15 pdf/${name}-full.pdf pdf/${name}.pdf`)));

// Remove uncropped PDFs
await Promise.all(names.map((name) => fs.unlink(`pdf/${name}-full.pdf`)));