# stellar-revtex template

Typst template that emulates many REVTeX (APS) conventions, built on top of the
[JACoW Typst template](https://github.com/eltos/accelerated-jacow/).

## What's inside
- `lib.typ`: the template entrypoint (`stellar_revtex` + `appendix`).
- `template/main.typ`: minimal starter file.
- `example/main.typ`: longer scientific sample with figures, tables, bib, and glossaries.
- `typst.toml`: package metadata (`@local/stellar-revtex:0.1.0`).

## Quick start

### Render the bundled examples
```bash
typst c template/main.typ template.pdf
typst c example/main.typ example.pdf   # uses a few preview packages
```

### Use as a local package in your own project
1) Make sure the repo is available on Typst's local package path. On macOS:
```bash
mkdir -p "$HOME/Library/Application Support/typst/packages/local/stellar-revtex/0.1.0"
cp -R . "$HOME/Library/Application Support/typst/packages/local/stellar-revtex/0.1.0"
```
On Linux: `~/.local/share/typst/packages/local/stellar-revtex/0.1.0` (same layout on Windows under `%LOCALAPPDATA%\typst\packages\local\stellar-revtex\0.1.0`).

2) In your document (e.g. `paper.typ`) import and show the template:
```typst
#import "@local/stellar-revtex:0.1.0": stellar_revtex, appendix

#show: stellar_revtex.with(
  title: [Interesting Results],
  authors: ((name: "A. Author", at: "inst", email: "a@author.edu"),),
  affiliations: (inst: "Institute of Examples"),
  abstract: [One-line abstract.],
  layout: "reprint",          // "preprint", "reprint", "twocolumn", "onecolumn"
  affiliation-style: "auto",  // "auto", "superscript", "plain"
  aps-journal: "physrev",     // or "prl" for PRL-style headings
)

= First Section
Body text ...

#appendix(title: [Supplementary], lbl: "app:sup")
More details.
```

## Options reference (non-exhaustive)
- `paper-size`: `"us-letter"` (default) or `"a4"`.
- `layout`: `"preprint"` (12 pt, 1-col header), `"reprint"` (APS 2-col), `"twocolumn"`, `"onecolumn"`.
- `journal`: `"aps"` or `"aip"` (bibliography style); `aps-journal`: `"physrev"` or `"prl"` (heading styling).
- `affiliation-style`: `"auto"` (skip superscripts if only one affiliation), `"superscript"`, `"plain"`.
- `preprint-id`: string or content placed top-right (REVTeX `\preprint`).
- `abstract-title`: `none` (default "Abstract"), `false` (hide), or custom content; `bibliography-title` analogous.
- `funding`, `authorNotes`, `pacs`, `keywords`, `show-pacs`, `show-keywords` to mirror common REVTeX front-matter.
- Author fields: `name` (required), `at`/`affiliation` (string or tuple), optional `note` keys matching `authorNotes`, optional `email`, optional `orcid` (prints linked ORCID icon).
- `show-grid`: `true` overlays a light layout grid for debugging.
- Appendix helper: `#appendix(title: [...], lbl: "app:id")` auto letters appendices and resets equation numbering to (A1), (B1), ...

## Roadmap

*Formatting*
- [x] Mimic revtex title block, author block and abstract block
- [x] Affiliation block (grouped-address and superscript styles)
- [x] Fix edge cases for affiliation block (e.g., identical affiliations without superscripts)
- [x] Mimic revtex heading formats
- [x] Mimic figure and table caption format 

*Article options*
- [x] Two column
- [x] One column
- [ ] Font size options

*Environment*
- [ ] Implement `outline` fix (currently raises error due to headline definitions)
- [x] `Appendix` environment
- ~~[ ] Wide equations helper~~ _(not possible with current typst layout engine; known limitation)_

*Other*
- [x] Linking the superscripts in the author block to the corresponding end notes
- [ ] Option to automatically turn footnotes in the manuscript into bib entries (`footinbib`-like)

## License
GPL-3.0-only
