/*
 * stellar-revtex template, Copyright (c) 2025 Tobias Wolf <public@wolft.net>
 *
 * inspired by the JACoW Typst template [https://github.com/eltos/accelerated-jacow/], Copyright (c) 2024 Philipp Niedermayer (github.com/eltos)
 */

#import "@preview/numbly:0.1.0": numbly

// Keep a handle to the original footnote element so we can override it
// inside the template without losing normal footnotes.
#let _stellar_real_footnote = footnote

// State to track if the user wants a visible "APPENDIX" header
#let _stellar_show_appendix_heading = state("stellar-revtex-show-appendix-heading", false)


// -------------------------------
// 1. Helper Functions
// -------------------------------

// A utility to locate `element` in `list` starting at index `i`.
#let indexOf(list, element, i) = {
  if list.len() == 0 {
    panic("Element not found")
  } else if list.at(0) == element {
    i
  } else {
    indexOf(list.slice(1), element, i + 1)
  }
}

// Produce star-based numbering: 1 => "*", 2 => "**", 3 => "***", etc.
#let starNumber(i) = numbering("*", i)

// Returns a list of unique note keys (strings) in order of first appearance
#let gatherNoteKeys(authors) = {
  let used = ()
  for a in authors {
    if "note" in a.keys() {
      // a.note might be a single string or a tuple
      let these = if type(a.note) == str { (a.note,) } else { a.note }
      for key in these {
        if not (key in used) {
          used += (key,)
        }
      }
    }
  }
  used
}

// Returns a list of unique emails in order of first appearance
#let gatherEmails(authors) = {
  let emails = ()
  for a in authors {
    if "email" in a.keys() {
      let e = a.email
      if not (e in emails) {
        emails += (e,)
      }
    }
  }
  emails
}

// Decide whether to skip affiliation superscripts
#let shouldSkipAffSuperscripts(authors, aff_keys, affiliation-style) = {
  let everyoneSharesAffs = {
    if authors.len() == 0 { true } else {
      let first = authors.at(0).affiliation
      let same = true
      for (i, a) in authors.enumerate() {
        if i != 0 and a.affiliation != first {
          same = false
        }
      }
      same
    }
  }

  if affiliation-style == "superscript" {
    false
  } else if affiliation-style == "plain" {
    true
  } else {
    aff_keys.len() == 1 or authors.len() <= 1 or everyoneSharesAffs
  }
}

#let smallerTextSize(base) = if base >= 11pt { base - 2pt } else { base - 1pt }

#let mergedNoteLabelName(idx) = "stellar-revtex-note-" + str(idx)

// Format the inline author block
#let format-author-names(authors, aff_keys, mergedStuff, affiliation-style) = {
  let skipAff = shouldSkipAffSuperscripts(authors, aff_keys, affiliation-style)
  let n = authors.len()
  let out = ""

  for (i, a) in authors.enumerate() {
    if n == 2 and i == 1 {
      out += " and "
    } else if n > 2 {
      if i == n - 1 {
        out += ", and "
      } else if i > 0 {
        out += ", "
      }
    }
    out += a.name
    let sups = ()
    if not skipAff {
      let affNums = a.affiliation.map(aff => str(indexOf(aff_keys, aff, 0) + 1))
      sups += affNums
    }
    if "note" in a.keys() {
      let these = if type(a.note) == str { (a.note,) } else { a.note }
      for key in these {
        let idx = indexOf(mergedStuff, ("note", key), 0) + 1
        let dest = label(mergedNoteLabelName(idx))
        sups += (link(dest, starNumber(idx)),)
      }
    }
    if "email" in a.keys() {
      let idx = indexOf(mergedStuff, ("email", a.email), 0) + 1
      let dest = label(mergedNoteLabelName(idx))
      sups += (link(dest, starNumber(idx)),)
    }
    if sups.len() == 1 {
      out += super(sups.at(0))
    } else if sups.len() > 1 {
      out += super(sups.join(", "))
    }
  }
  out
}

#let format-affiliations(aff_keys, affiliations, skip, layout, aff-size) = {
  set text(size: aff-size, weight: "regular")
  if skip {
    for aff in aff_keys {
      [_#affiliations.at(aff)_]
      v(-2pt)
    }
  } else {
    for aff in aff_keys {
      let num = indexOf(aff_keys, aff, 0) + 1
      [#super(str(num))_ #affiliations.at(aff)_]
      v(-2pt)
    }
  }
}

#let appendix(body) = {
  // Separate appendix from preceding content
  v(2em)

  // Add an "Appendix" heading (visible or hidden) so it appears in the outline
  context {
    if _stellar_show_appendix_heading.get() {
      heading(level: 1, numbering: none, outlined: true)[Appendix]
    } else {
      place(hide(heading(level: 1, numbering: none, outlined: true)[Appendix]))
    }
  }

  // Reset heading counter so appendix headings start fresh (A, A.1, ...)
  counter(heading).update(0)
  set heading(numbering: (..nums) => {
    let vals = nums.pos()
    if vals.len() == 1 { numbering("A", ..vals) }
    else if vals.len() == 2 { numbering("A.1", ..vals) }
    else { numbering("A.1.a", ..vals) }
  })
  set heading(supplement: [Appendix])

  // Reset equation counter ONCE for the whole appendix
  // and give equations simple labels (A1), (A2), ...
  counter(math.equation).update(0)
  set math.equation(numbering: n => "(A" + str(n) + ")")

  body
}



// === MAIN TEMPLATE STARTS ===

#let stellar-revtex(
  title: none,
  authors: (),
  affiliations: (:),
  abstract: none,
  funding: none,
  acknowledgment: none,
  authorNotes: (:), 
  paper-size: "us-letter",
  abstract-title: none,
  bibliography-title: "References",
  bibliography-file: none,
  font-size: none,
  journal: "aps",
  layout: "reprint",
  affiliation-style: "auto",
  date: none,
  pacs: none,
  keywords: none,
  show-pacs: true,
  show-keywords: true,
  show-appendix-heading: false,
  preprint-id: none,
  aps-journal: "physrev",
  body
) = {

  _stellar_show_appendix_heading.update(show-appendix-heading)
  let is-prl = aps-journal == "prl"

  let body-font-size = {
    if font-size != none {
      let fs = if type(font-size) == int { font-size*1pt } else { font-size }
      if not (fs == 10pt or fs == 11pt or fs == 12pt) {
        panic("stellar-revtex: font-size must be 10pt, 11pt, or 12pt.")
      }
      fs
    } else if layout == "preprint" or layout == "onecolumn" {
      12pt
    } else {
      10pt
    }
  }
  let small-font-size = smallerTextSize(body-font-size)
  let title-font-size = if body-font-size >= 11pt { body-font-size + 1pt } else { body-font-size + 2pt }

  for a in authors.filter(a => "names" in a.keys()) {
    for name in a.remove("names") {
      authors.insert(-1, (name: name, ..a))
    }
  }
  authors = authors.map(a => {
    if "by" in a.keys() { a.insert("name", a.remove("by")) }
    if "at" in a.keys() { a.insert("affiliation", a.remove("at")) }
    if type(a.affiliation) == str { 
      a.insert("affiliation", (a.remove("affiliation"),))
    }
    if "name" in a.keys() {
      a.insert("name", a.name.trim(" "))
    }
    a
  })
  authors = authors.filter(a => "name" in a.keys())

  let aff_keys = ()
  for a in authors {
    for aff in a.affiliation {
      if not (aff in aff_keys) {
        aff_keys += (aff,)
      }
    }
  }

  let notesUsed = gatherNoteKeys(authors)
  let emailsUsed = gatherEmails(authors)

  let mergedStuff = ()
  for key in notesUsed {
    mergedStuff += (("note", key),)
  }
  for e in emailsUsed {
    mergedStuff += (("email", e),)
  }

  let mergedState = state("notes-emails-list", mergedStuff)

  set page(
    columns: if layout == "reprint" or layout == "twocolumn" { 2 } else { 1 },
    numbering: "1",
    header: if layout == "preprint" {
      align(right)[#title]
    } else {
      none
    },
    ..if paper-size == "a4" {
      (paper: "a4", margin: (top: 37mm, bottom: 19mm, x: 20mm))
    } else if paper-size in ("letter", "us-letter") {
      (paper: "us-letter", margin: (y: 0.75in, left: 0.75in, right: 0.75in))
    } else if paper-size == "jacow" {
      (width: 21cm, height: 11in, margin: (x: 20mm, y: 0.75in))
    } else if paper-size == "test" {
      (width: 21cm, height: auto, margin: (x: 20mm, y: 0.75in))
    } else {
      panic("Unsupported paper-size, use 'a4', 'us-letter' or 'jacow'!")
    },
  )
  set columns(gutter: if layout == "reprint" or layout == "twocolumn" { 0.25in } else { 0pt })

  set text(
    font: ("Times New Roman", "TeX Gyre Termes"),
    size: body-font-size,
  )
  show math.equation: set text(font: (
  "TeX Gyre Termes Math", 
  "STIX Two Math", 
  "XITS Math", 
  "New Computer Modern Math"
))
  show link: set text(rgb(0,0,139))
  show ref: set text(rgb(0,0,139))
  set par(
    spacing: if layout == "preprint" or layout == "onecolumn" { 1em } else { 0.65em },
    leading: if layout == "preprint" or layout == "onecolumn" { 0.8em } else { 0.5em },
  )

  set math.equation(numbering: "(1)")

  set ref(supplement: it => {
    if it != none and it.func() == figure and it.kind == image {
      [Fig.]
    } else if it != none and (
      (it.func() == figure and it.kind == table) or
      it.func() == table
    ) {
      [Table]
    } else {
      it.supplement
    }
  })

  show ref: it => {
      let eq = math.equation
      let el = it.element

      if el != none and el.func() == eq {
        // Handle equations with parentheses and links
        box(link(el.location(), numbering(
          el.numbering,
          ..counter(eq).at(el.location())
        )))
      } else if el != none {
        // Handle other cross-references (Figures, Tables) by boxing them
        // to keep the number attached to the label.
        box(it)
      } else {
        // This path handles citations (el == none). 
        // We explicitly DO NOT box them to allow the CSL processor 
        // to group them correctly (e.g., [1-3]).
        it
      }
    }

  let titlenotenumbering(i) = {
    if i < 6 { ("*", "#", "§", "¶", "‡").at(i - 1) }
    else { (i - 4)*"*" }
  }

  let footnotes = state("titlefootnotes", (:))
  footnotes.update(footnotes => (:))
  let titlefootnote(text) = {
    footnotes.update(footnotes => {
      footnotes.insert(titlenotenumbering(footnotes.len()+1), text)
      footnotes
    })
    h(0pt, weak: true)
    context{super(footnotes.get().keys().at(-1))}
  }

  show footnote.entry: set align(left)
  show footnote.entry: set par(hanging-indent: 0.57em)
  set footnote.entry(
    indent: 0em,
    separator: [
      #set align(left)
      #line(length: 40%, stroke: 0.5pt)
    ]
  )

  if preprint-id != none {
    place(
      top + right,
      scope: "parent",
      float: true,
      {
        set text(size: small-font-size)
        set align(right)
        if type(preprint-id) == str {
          [#preprint-id]
        } else {
          preprint-id
        }
      }
    )
  }

  place(
    top + center,
    scope: "parent",
    float: true,
    {
      set align(center)
      set par(justify: false)
      set text(hyphenate: false)

      text(size: title-font-size, weight: "bold", [
        #(title)
        #if funding != none { titlefootnote(funding) }
      ])
      v(8pt)

      let skip = shouldSkipAffSuperscripts(authors, aff_keys, affiliation-style)
      text(
        size: body-font-size,
        [
          #format-author-names(authors, aff_keys, mergedStuff, affiliation-style)
        ]
      )
      v(0pt)
      format-affiliations(aff_keys, affiliations, skip, layout, small-font-size)

      if date != none {
        v(4pt)
        text(size: small-font-size, style: "italic", [#date])
      }
    }
  )

  context {
    for (symbol, text) in footnotes.get() {
      place(_stellar_real_footnote(
        numbering: it => "",
        { super(symbol) + sym.space.med + text }
      ))
    }
  }

  set par(first-line-indent: (amount: 0em, all: true), justify: true)
  if abstract != none {  
    place(
      top + left,
      float: true,
      scope: "parent",
      clearance: 0em,
      {
        block(inset: (left:0.75in,right:0.75in), {
          set text(size: small-font-size, weight: "regular")
          if abstract-title != false {
            set align(left)
            set text(weight: "bold")
            [#if abstract-title == none { [Abstract] } else { abstract-title }]
            set text(weight: "regular")
            v(0.5em)
          }
          abstract
          if pacs != none and show-pacs {
            v(0.75em)
            set text(size: small-font-size)
            [PACS numbers: #pacs]
          }
          if keywords != none and show-keywords {
            v(0.25em)
            set text(size: small-font-size)
            let kw = if type(keywords) == str { keywords } else { keywords.join(", ") }
            [Keywords: #kw]
          }
        })
      }
    )
  }
  place(top + left, float: true, scope: "parent", clearance: 3.0em, { })

  set par(first-line-indent: (amount: 1em), justify: true)

  let _main_heading_numbering = numbly(
    "{1:I}", "{2:A}", "{3:1}", ""
  )
  set heading(numbering: _main_heading_numbering)
  show outline.entry: it => if it.level >= 4 { none } else { it }

  show heading.where(level: 1): it => {
    set align(center)
    set text(size: small-font-size, weight: "bold", style: "normal", hyphenate: false)
    let is-appendix = (it.supplement == [Appendix])
    block(
      above: 2em,
      below: 1em,
      if is-prl [
        #upper[#it.body]
      ] else if is-appendix {
        // counter(math.equation).update(0)
        if it.numbering == none {
           [#upper[#it.body]]
        } else {
           let num = counter(heading).display(it.numbering)
           [Appendix #num. #sym.space.med #upper[#it.body]]
        }
      } else {
        if it.numbering == none [
          #upper[#it.body]
        ] else [
          #counter(heading).display(it.numbering). #upper[#it.body]
        ]
      }
    )
  }

  show heading.where(level: 2): it => {
    set align(center)
    set text(size: small-font-size, weight: "bold", style: "normal", hyphenate: false)
    block(
      above: 2em,
      below: 1em,
      if is-prl or it.numbering == none [
        #it.body
      ] else [
        #counter(heading).display(it.numbering). #it.body
      ]
    )
  }

  show heading.where(level: 3): it => {
    set align(center)
    set text(size: small-font-size, weight: "regular", style: "italic", hyphenate: false)
    block(
      above: 1.5em,
      below: 1em,
      if is-prl or it.numbering == none [
        #it.body
      ] else [
        #counter(heading).display(it.numbering). #it.body
      ]
    )
  }

  show heading.where(level: 4): it => {
    v(6pt)
    set text(size: body-font-size, weight: "regular", style: "italic")
    it.body
  }

  show list: set list(indent: 1em)
  show figure: set figure(placement: auto, gap: 1em)
  show figure.where(kind: image): set figure(supplement: [Fig.])
  show figure.where(kind: table): set figure(numbering: "I")
  show figure.where(kind: table): set figure.caption(position: top, separator: [.])
  show figure.where(kind: table): set text(size: small-font-size)
  set figure.caption(separator: [.])
  show figure.caption: it => {
    align(left, {
      set text(size: small-font-size)
      [
        #h(1.3em)
        #box([#upper[#it.supplement]~#it.counter.display(it.numbering)#it.separator])
        #sym.space.med
        #it.body
      ]
    })
  }
  show table: set table(stroke: none)
  set math.equation(numbering: "(1)")
  show math.equation: it => {
    if it.block and it.numbering != none and not it.has("label") [
      #counter(math.equation).update(v => v - 1)
      #math.equation(it.body, block: true, numbering: none)
    ] else {
      it
    }  
  }

  set bibliography(
    title: none,
    style: if journal == "aip" { "american-institute-of-physics" } else { "american-physics-society" },
  )

  show bibliography: it => {
    if acknowledgment != none {
      [==== Acknowledgments.
      #acknowledgment]
    }
    v(1em)

    if bibliography-title != none {
      align(center, {
        set text(size: small-font-size, weight: "bold", style: "normal", hyphenate: false)
        [#upper[#bibliography-title]]
      })
      v(0.5em)
    }
    align(center, line(length: 70%, stroke: 0.5pt))
    v(1em)
    set text(size: small-font-size)

    context {
      let merged = mergedState.get()
      if merged.len() > 0 {
        set text(size: small-font-size, weight: "regular")
        enum(body-indent: 0.25em, numbering: x => starNumber(x + 1),
          ..for (i, entry) in merged.enumerate() {
            let (kind, value) = entry
            let out = if kind == "note" { text(authorNotes.at(default: value, value)) } 
                      else { link("mailto:" + value) }
            ([#out #label(mergedNoteLabelName(i + 1))],)
          }
        )
        v(0.5em)
      }
    }

    show link: it => text(font: ("Courier New", "Consolas", "Menlo", "Liberation Mono"), size: 7.2pt, it)
    it
  }

  body

  // Bibliography is generated once at the end to avoid duplicate sources
  if bibliography-file != none {
    bibliography(bibliography-file)
  }
}
