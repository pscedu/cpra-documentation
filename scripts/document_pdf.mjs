// Extract Mermaid diagrams as PDFs.
// Requires pdfcrop (Fedora package: texlive-pdfcrop)

import fs from "fs/promises";
import { mdToPdf }  from "md-to-pdf";
import { run } from "@mermaid-js/mermaid-cli";

await fs.mkdir("pdf", {recursive: true});

let doc = (await fs.readFile("MP2029.md")).toString();

await run(`MP2029.md`, `pdf/temp.svg`, {
  puppeteerConfig: {headless: 1},
  quiet: true
});

const mermaidPattern = new RegExp("```mermaid([^`]+)```", "m");
let svgIdx = 1;
let svgName;
let svg;

while (doc.match(mermaidPattern)) {
  svgName = `pdf/temp-${svgIdx}.svg`;
  svg = (await fs.readFile(svgName)).toString();
  doc = doc.replace(mermaidPattern, svg);
  await fs.unlink(svgName);
  svgIdx++;
}

const pdf = await mdToPdf({ content: doc }, {
  body_class: "markdown-body",
  launch_options: {
    headless: "new",
  },
  pdf_options: {
    format: "Letter",
    margin: "1in"
  },
  stylesheet: [
    "node_modules/github-markdown-css/github-markdown.css",
    "style/markdown-pdf.css"
  ]
});

await fs.writeFile("pdf/mp2029-technical-requirements.pdf", pdf.content);
