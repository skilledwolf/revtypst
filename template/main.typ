#import "@local/revtypst:0.1.0": revtypst
//#import "@preview/quick-maths:0.1.0"
#import "@preview/physica:0.9.4": *
#import "@preview/unify:0.7.0": unit,num,qty,numrange,qtyrange

#set text(lang: "en")

#show: revtypst.with(
  paper-size: "us-letter",
  title: [
    Minimal Typst Document Template
  ],
  authors: (
    (name: "John Doe", at: ("uniA","uniB"), note: ("equalContrib"), email:"expendable@planetexpress.fut"),
    (name: "Jane Doe", at: "uniA", note: ("equalContrib", "deceased")),
    (name: "Hubert J. Farnsworth", at: "uniA", email:"hj.farnsworth@planetexpress.fut"),
  ),
  affiliations: (
    uniA: "Department of Examples, Example University",
    uniB: "Department of Second Examples, Second Example University"
  ),
  authorNotes: (
    equalContrib: "These authors contributed equally to this work.", 
    deceased: "This author is deceased."
  ),
  abstract: [
    This is a minimal template showcasing a figure, an equation, and a reference citation.
    #lorem(100)
  ],
  acknowledgment: [
    We extend our heartfelt thanks to the magical computational spirits at the Celestial Compute Realm, whose enchanted resources powered our numerical adventures. Our work was buoyed by the generous backing of the Arcane Fund of Discovery, the Legendary Grant of Innovation, and a sprinkle of Serendipity Awards. Special thanks go to the whimsical halls of the Infinite Imagination Institute, where midnight epiphanies and caffeinated musings turned challenges into triumphs. To all the unseen forces of creativity and curiosity, we tip our hats in gratitude. 
  ]
)

= The first section <sec:intro>
@sec:intro is the first section of this document. It contains a figure, an equation, and a table. 

The amazing part is that we can just type and get it rendered live in the preview. We can easily type equations, like 
$
  integral_0^infinity f(x) dif x = C,
$
and they will be rendered beautifully and instantly. It makes LaTeX feel like a thing of the past.  

== The subsection of doom <sec:subsec>

#lorem(20)

=== The subsubsection of despair <sec:subsubsec>

==== Introduction.
This document is a minimal example to help you get started with Typst. We can cite references very easily from the same bibliography files as in LaTeX, see Ref.~@doe2023minimal. #lorem(90)

As illustrated in @fig:example, #lorem(200)

#figure(
  image("blue_marble.jpg", width: 8cm),
  placement: top,
  caption: [
    Behold the Blue Marble—a playful orb of swirling blues and wispy whites, where the cosmic dance of oceans and clouds inspires endless wonder. Taken from #link("https://visibleearth.nasa.gov/images/57723/the-blue-marble", "NASA's Visible Earth").
  ],
  scope: "column", // "parent" is double column, "column" is single column
) <fig:example>

And here is an important equation to illustrate how math typesetting, labeling and referencing works: 
$
E = m c^2 ,
$ <eq:energy-mass>
where $m$ is the mass and $c$ is the speed of light. In @eq:energy-mass, we note that #lorem(50)

For good measure, we probably want to show a table of data, see @tab:example. #lorem(150)

#figure(
  table(
  columns: (1fr, auto, auto),
  align: (left, center, center),
  stroke: (_, y) => (
          left: { 0pt },
          right: { 0pt },
          top: if y < 1 { stroke(1.5pt) } else if y == 1 { none } else { 0pt },
          bottom: if y < 1 { stroke(.5pt) } else { stroke(1.5pt) },
      ),
  inset: (i,j) => (
          left: { if i< 1 {0pt} else {8pt} },
          top: if j < 1 { 6pt } else if j == 1 {6pt} else { 0pt },
          bottom: if j < 1 { 6pt } else { 6pt },
  ),
  table.header(
    [Substance],
    [Subcritical °C],
    [Supercritical °C],
  ),
  [Hydrochloric Acid],
  [12.0], [92.1],
  [Sodium Myreth Sulfate],
  [16.6], [104],
  [Potassium Hydroxide],
  table.cell(colspan: 2)[24.7]
),
  placement: auto, // auto, top, bottom
  caption: [
    An example table with a simple caption. #lorem(30)
  ], 
  scope: "column", // "parent" is double column, "column" is single column
) <tab:example>


#lorem(200)

#lorem(100)



#bibliography("refs.bib")
