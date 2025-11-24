# revtypst template

**Paper template** derived from the [JACoW typst template](https://github.com/eltos/accelerated-jacow) and inspired by `revtex` (APS in particular).

## Roadmap

*Formatting*
- [x] Mimic revtex title block, author block and abstract block
- [x] Partially mimic affiliation block
- [ ] Fix missing edge cases for affiliation block (for example: two authors with identical affiliations should not render with superscripts, but currently do)
- [x] Mimic revtex heading formats
- [x] Mimic figure and table caption format 

*Article options*

- [x] Two column
- [ ] One column
- [ ] Font size options

*Environment*

- [ ] Implement `outline` fix (currently raises error due to headline definitions)
- [x] `Appendix` environment
- [ ] Wide equations helper
- [ ] Work out a way to get solid double line around tables 

*Other*
- [ ] Linking the superscripts in the author block to the corresponding end notes
- [ ] Implementing the option to automatically turn footnotes in the manuscript into bib entries (like the `footinbib` option in `revtex`)


## Usage

### Typst web app

If this template is published to the [typst.app](https://typst.app) Universe, you can:

1. Go to [typst.app](https://typst.app/app).
2. Search for the `revtypst` template.
3. Click **Start from template** to begin editing.

*(If the template is not yet on Universe, you can either manually upload the `.typ` file or create the project directly from the github link through the typst webb app)*

### Local installation

To use it locally in your own project:

1. Copy the `revtypst.typ` (and any supporting `.typ` files) into your project folder.
2. Create a `paper.typ` (or similarly named) entry file.
3. In `paper.typ`, import and show the template:
   ```typst
   #import "@local/revtypst:0.1.0": revtypst, appendix

   #show: revtypst.with(
     paper-size: "us-letter",
     title: [ Minimal Typst Document Template ],
     authors: (
       (name: "John Doe", at: ("uniA","uniB"), note: ("equalContrib"), email: "expendable@planetexpress.fut"),
       (name: "Jane Doe", at: "uniA", note: ("equalContrib", "deceased")),
       (name: "Hubert J. Farnsworth", at: "uniA", email: "hj.farnsworth@planetexpress.fut"),
     ),
     affiliations: (
       uniA: "Department of Examples, Example University",
       uniB: "Department of Second Examples, Second Example University"
     ),
     authorNotes: (
       equalContrib: "These authors contributed equally to this work.",
       deceased: "Deceased"
     ),
     abstract: [
       This is a minimal template showcasing a figure, an equation, 
       and a reference citation.
       #lorem(100)
     ]
   )

   = Section
   Some text ...

   columns(1)[ $ E = m c^2 $ ]

   #appendix[Extra derivations]
   $ H_\text{eff} = H_0 + \Sigma(\omega) $
   ```
