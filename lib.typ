/*
 * revtypst template, Copyright (c) 2025 Tobias Wolf <public@wolft.net>
 *
 * Based on the JACoW Typst template [https://github.com/eltos/accelerated-jacow/], Copyright (c) 2024 Philipp Niedermayer (github.com/eltos)
 */

#import "@preview/numbly:0.1.0": numbly

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
#let shouldSkipAffSuperscripts(authors, aff_keys) = {
  if authors.len() == 1 {
    true
  } else if aff_keys.len() == 1 {
    true
  } else {
    false
  }
}

// Format the inline author block (name + affiliation sup + star-based notes/emails).
#let format-author-names(authors, aff_keys, mergedStuff) = {
  let skipAff = shouldSkipAffSuperscripts(authors, aff_keys)
  let n = authors.len()
  let out = ""

  for (i, a) in authors.enumerate() {
    // Insert commas or "and"
    if n == 2 and i == 1 {
      out += " and "
    } else if n > 2 {
      if i == n - 1 {
        out += ", and "
      } else if i > 0 {
        out += ", "
      }
    }

    // Always add name
    out += a.name

    // Accumulate superscripts
    let sups = ()

    // 1) affiliation numbering if not skipping
    if not skipAff {
      let affNums = a.affiliation.map(aff => str(indexOf(aff_keys, aff, 0) + 1))
      sups += affNums
    }

    // 2) notes
    if "note" in a.keys() {
      let these = if type(a.note) == str { (a.note,) } else { a.note }
      for key in these {
        // The star index is the position of ("note", key) in mergedStuff
        let idx = indexOf(mergedStuff, ("note", key), 0) + 1
        sups += (starNumber(idx),)
      }
    }

    // 3) email
    if "email" in a.keys() {
      let idx = indexOf(mergedStuff, ("email", a.email), 0) + 1
      sups += (starNumber(idx),)
    }

    // Turn sups into a single superscript
    if sups.len() == 1 {
      out += super([$#sups.at(0)$])
    } else if sups.len() > 1 {
      out += super(sups.join(", "))
    }
  }

  out
}

// Format the affiliation lines
#let format-affiliations(aff_keys, affiliations, skip) = {
  set text(size: 9pt, weight: "regular")
  if skip {
    // If skipping, no numbering
    for aff in aff_keys {
      [_#affiliations.at(aff)_]
      v(-2pt)
    }
  } else {
    // Otherwise, number them
    for aff in aff_keys {
      let num = indexOf(aff_keys, aff, 0) + 1
      [#super($num$)_#affiliations.at(aff)_]
      v(-2pt)
    }
  }
}

// For optional sub-numbering of headings up to a max level
#let number-until-with(max-level, schema) = (..numbers) => {
  if numbers.pos().len() <= max-level {
    numbering(schema, ..numbers)
  }
}

// Just a small utility for double lines
#let doubleline = {
  line(length: 100%, stroke: 0.5pt)
  v(-4pt)
  line(length: 100%, stroke: 0.5pt)
  v(-6pt)
}


// === MAIN TEMPLATE STARTS ===

#let revtypst(
  title: none,
  authors: (),
  affiliations: (:),
  abstract: none,
  funding: none,
  acknowledgment: none,
  authorNotes: (:),  // dictionary noteKey => noteText
  paper-size: "us-letter",
  abstract-title: none,
  bibliography-title: "References",
  show-grid: false,
  body,
) = {

  // ------------------------------------------------
  // 1) SANITIZE AUTHOR DATA
  // ------------------------------------------------
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

  // ------------------------------------------------
  // 2) CREATE AFFILIATION ORDER
  // ------------------------------------------------
  let aff_keys = ()
  for a in authors {
    for aff in a.affiliation {
      if not (aff in aff_keys) {
        aff_keys += (aff,)
      }
    }
  }

  // ------------------------------------------------
  // 3) GATHER NOTE KEYS & EMAILS => MERGE
  // ------------------------------------------------
  let notesUsed = gatherNoteKeys(authors)  // e.g. ("equalContrib", "deceased", ...)
  let emailsUsed = gatherEmails(authors)   // e.g. ("someone@somewhere", ...)

  // Build a single list of items: 
  //   [("note", "equalContrib"), ("note", "deceased"), ..., ("email", "someone@somewhere"), ...]
  let mergedStuff = ()
  for key in notesUsed {
    mergedStuff += (("note", key),)
  }
  for e in emailsUsed {
    mergedStuff += (("email", e),)
  }

  // We'll store them in a global state for printing pre-bibliography
  let mergedState = state("notes-emails-list", mergedStuff)

  // ------------------------------------------------
  // 4) PAGE + FONT SETTINGS
  // ------------------------------------------------
  set page(columns: 2, numbering: "1", 
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
    ..if show-grid {
      (background: [
        // optional debugging grid
      ])
    }
  )
  set columns(gutter: 0.25in)

  // Adjust text families as desired
  set text(font: "TeX Gyre Termes", size: 10pt)
  show math.equation: set text(font: "TeX Gyre Termes Math")
  show link: set text(rgb(0,0,139))
  show ref: set text(rgb(0,0,139))
  set par(spacing: 0.65em, leading: 0.5em)

  // references
  set math.equation(numbering: "(1)")

  set ref(supplement: it => {
    if it.func() == figure and it.kind == image {
      "Fig."
    } else if it.func() == table {
      "Table"
    } else {
      it.supplement
    }
  })

  show ref: it => {
    let eq = math.equation
    let el = it.element
    if el != none and el.func() == eq {
      // Override equation references
      link(el.location(), [Eq.~#numbering(
        el.numbering,
        ..counter(eq).at(el.location())
      )])
    } else {
      it
    }
  }

  // ------------------------------------------------
  // 5) FOOTNOTES FOR TITLE
  // ------------------------------------------------
  // For any optional "funding" or so
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

  // ------------------------------------------------
  // 6) TITLE BLOCK
  // ------------------------------------------------
  place(
    top + center,
    scope: "parent",
    float: true,
    {
      set align(center)
      set par(justify: false)
      set text(hyphenate: false)

      // Title
      text(size: 12pt, weight: "bold", [
        #(title)
        #if funding != none { titlefootnote(funding) }
      ])
      v(8pt)

      // Determine affiliation-superscript skipping
      let skip = shouldSkipAffSuperscripts(authors, aff_keys)

      // Authors
      text(size: 10pt, [
        #format-author-names(authors, aff_keys, mergedStuff)
      ])
      v(0pt)

      // Affiliations
      format-affiliations(aff_keys, affiliations, skip)
    }
  )

  // Title footnotes
  context{
    for (symbol, text) in footnotes.get() {
      place(footnote(numbering: it => "", {super(symbol) + sym.space.med + text}))
    }
  }

  // ------------------------------------------------
  // 7) ABSTRACT
  // ------------------------------------------------
  set par(first-line-indent: (amount: 1em, all: true), justify: true)
  if abstract != none {  
    place(
      top + left,
      float: true,
      scope: "parent",
      clearance: 0em,
      {
        block(inset: (left:0.75in,right:0.75in), {
          set text(size: 9pt, weight: "regular")
          abstract
        })
      }
    )
  }
  place(
    top + left,
    float: true,
    scope: "parent",
    clearance: 3.0em,
    { }
  )

  // ------------------------------------------------
  // 8) MAIN CONTENT STYLING
  // ------------------------------------------------
  set par(first-line-indent: (amount: 1em), justify: true)

  // set heading(numbering: "I.A")
  set heading(numbering: numbly(
    "{1:I}", // use {level:format} to specify the format
    "{2:A}", // if format is not specified, arabic numbers will be used
    "{3:1}", // here, we only want the 3rd level
    ""
  ))

  show heading.where(level: 1): it => {
    set align(center)
    set text(size: 9pt, weight: "bold", style: "normal", hyphenate: false)
    block(
      above: 2em,
      below: 1em,
      [#counter(heading).display(it.numbering). #upper[#it.body]]
    )
  }

  show heading.where(level: 2): it => {
    set align(center)
    set text(size: 9pt, weight: "bold", style: "normal", hyphenate: false)
    block(
      above: 2em,
      below: 1em,
      [#counter(heading).display(it.numbering). #it.body]
    )
  }

  show heading.where(level: 3): it => {
    set align(center)
    set text(size: 9pt, weight: "regular", style: "italic", hyphenate: false)
    block(
      above: 1.5em,
      below: 1em,
      [#counter(heading).display(it.numbering). #it.body]
    )
  }

  show heading.where(level: 4): it => {
    v(6pt)
    set text(size: 10pt, weight: "regular", style: "italic")
    // h(1em) 
    it.body
  }

  // Lists
  show list: set list(indent: 1em)

  // Figures
  show figure: set figure(placement: auto, gap: 1em)
  show figure.where(kind: image): set figure(supplement: [Fig.])
  show figure.where(kind: table): set figure(numbering: "I")
  show figure.where(kind: table): set figure.caption(position: top, separator: [. ])
  show figure.where(kind: table): set text(size: 9pt)

  show figure.caption: it => {
    align(left, {
      set text(size: 9pt)
      [
        #h(1.3em) #upper[#it.supplement]~
        #context it.counter.display(it.numbering)
        #it.separator 
        #it.body
      ]
    })
  }

  // Tables
  show table: set table(stroke: none)

  // Equations
  set figure.caption(separator: [. ])
  set math.equation(numbering: "(1)")
  show math.equation: it => {
    if it.block and not it.has("label") [
      #counter(math.equation).update(v => v - 1)
      #math.equation(it.body, block: true, numbering: none)#label("")
    ] else {
      it
    }  
  }

  // ------------------------------------------------
  // 9) BIBLIOGRAPHY + NOTES/EMAILS
  // ------------------------------------------------
  let bib_state = state("bib-called", false)

  set bibliography(title: none, style: "american-physics-society")

  show bibliography: it => {

    // Mark that we've called bibliography
    bib_state.update(bib-called => true)

    if acknowledgment != none {
      [==== Acknowledgment. 
      #acknowledgment]
    }

    // Now the references heading + items
    v(1em)
    align(center, line(length: 70%, stroke: 0.5pt))
    v(1em)

    set text(size: 9pt)

    // Pull the merged list from the global state
    let merged = mergedState.get()

    // If there's anything in merged, print them before references
    if merged.len() > 0 {
      set text(size: 9pt, weight: "regular")

      // We'll do an itemized list with star-based numbering
      // Each item is either ("note", key) or ("email", addr)
      // 
      // NOTE: I wonder if we should have precomputed the merged list? 
      //       It might allow us to put reference links in the author block
      //       by using element.location(), i.e., link(element.location(), ...)
      //       in the author block
      enum(body-indent:0.25em, numbering: x => starNumber(x+1), 
        ..for (i, entry) in merged.enumerate() {
          let (kind, value) = entry
          let out = none
          if kind == "note" {
            out = text(authorNotes.at(default: value,value))
          } else if kind == "email" {
            // Print as a mailto: link
            out = link("mailto:" + value)
          } else {
            panic("Unknown kind in merged list")
          }
          (out,)
        }
      ) 
      v(0.5em)
      
    }

    show link: it => text(font: "DejaVu Sans Mono", size: 7.2pt, it)
    it  // bibliography items
  }

  body

  context if not (bib_state.get()) {
    // If bibliography wasn't called, we should call it now
    bibliography(())
  }
}
