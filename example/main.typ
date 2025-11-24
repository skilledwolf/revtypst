#import "@local/revtypst:0.1.0": revtypst
//#import "@preview/quick-maths:0.1.0"
#import "@preview/physica:0.9.4": *
#import "@preview/unify:0.7.0": unit,num,qty,numrange,qtyrange
#import "@preview/glossy:0.7.0": init-glossary

#show: revtypst.with(
  paper-size: "us-letter",
  // Paper title
  title: [
    Theory of magnetoroton bands in moiré materials
  ],
  // Optional heading for the abstract: none => "Abstract", false => hide, or custom content
  abstract-title: false,
  // Bibliography heading (set to none to suppress)
  bibliography-title: none,
  // Author list
  authors: (
    (name: "Bishoy M. Kousa", at: "ut"),
    (name: "Nicolás Morales-Durán", at: ("ut", "flatiron")),
    (name: "Tobias M. R. Wolf", at: "ut"),
    (name: "Eslam Khalaf", at: "harvard"),
    (name: "Allan H. MacDonald", at: "ut"),
  ),
  affiliations: (
    ut: "Department of Physics, The University of Texas at Austin, Austin, Texas 78712, USA",
    flatiron: "Center for Computational Quantum Physics, Flatiron Institute, New York, New York 10010, USA",
    harvard: "Department of Physics, Harvard University, Cambridge, Massachusetts 02138, USA",
  ),
  // Optional author footnotes keyed by symbol names used in the author list (note: ("equalContrib"), etc.)
  authorNotes: (),
  // Funding note (optional, comment out if not applicable)
  // funding: "Work supported by ...",
  // Paper abstract
  abstract: [
    We examine how the magnetoroton collective modes of fractional quantum Hall (FQH) states are altered by external periodic potentials. Our theory is based on a combination of single-mode-approximations for the excitations with Laughlin state three-point correlation functions. Our analysis applies to FQH states in graphene with a hexagonal boron nitride (hBN) substrate and also to fractional Chern insulator (FCI) states in twisted MoTe#sub[2] bilayers. We predict experimentally testable trends in the THz absorption characteristics of FCI and FQH states and estimate the external potential strength at which a soft-mode phase transition occurs between FQH and charge density wave (CDW) states. 
  ],
  // Optional acknowledgments section (shown before references if provided)
  acknowledgment: [
    The Flatiron Institute is a division of the Simons Foundation. We acknowledge HPC resources provided by the Texas Advanced Computing Center at The University of Texas at Austin. This work was supported by a Simons Foundation Collaborative Research Grant, by Robert A. Welch Foundation Grant F–2112, and in part by NSF PHY–2309135 to the Kavli Institute for Theoretical Physics (KITP) and by NSF MRSEC DMR–2308817 through the Center for Dynamics and Control of Materials. B.M.K. acknowledges the hospitality of the Flatiron Institute during part of this work.
  ],
  // Toggle a light layout grid overlay for debugging
  show-grid: false,
  // --- REVTeX-like options ---
  journal: "aps",            // "aps" or "aip" (bibliography style)
  layout: "reprint",         // "preprint", "reprint", "twocolumn", "onecolumn"
  affiliation-style: "auto", // "auto", "superscript", "plain"
  aps-journal: "physrev",    // "physrev" (default) or "prl" for PRL-like headings
  date: datetime.today().display(),     // dynamic today; use datetime.today().format(...) to customize
  pacs: [03.65.Yz, 42.50.Ct], // example PACS codes
  keywords: (
    "magnetoroton dispersion",
    "moire materials",
    "fractional Chern insulator"
  ),
  show-pacs: false,
  show-keywords: false,
  preprint-id: none,
)

// Abbreviations
#show: init-glossary.with((
  FQH: "fractional Quantum Hall",
  FCI: "fractional Chern insulator",
  CDW: "charge density wave",
  hBN: "hexagonal boron nitride",
  SMA: "single-mode approximation"
))

#h(1em)
==== Introduction---
The interplay between strong magnetic fields and periodic potentials in the quantum physics of two-dimensional electrons has been a subject of enduring interest since Hofstadter’s 1976 discovery @hofstadter1976energy of the butterfly pattern of gaps in the energy spectrum of a square-lattice tight-binding model. The Hofstadter butterfly was until recently mostly a theoretical curiosity @Claro_Wannier_hexagonal @Claro_Square @MacDonald_Square @MacDonald_Hexagonal because of the impossibility of applying magnetic fields on the scale of flux quanta per surface unit cell to natural crystals. Recently, however, the longer periods of moire materials @Dean_Hofstadter @Geim_Hofstadter @TBG_Hofstadter @andrei2021marvels have made direct studies of excitation gaps at relevant magnetic field scales a reality, and in doing so have made it clear @xie2021fractional @Kometter_Hofstadter that interactions—which produce additional magnetic-field–dependent gaps—often play a major role. In this context, the recent observation of FCI states @KaiSun_FCI @Neupert_FCI @DasSarma_Sun_FCI @Sheng_FCI @Bernevig_Regnault_FCI @Bernevig_Regnault_FCI_2 in tMoTe#sub[2] @FCI_Experiment1 @FCI_Experiment2 @FCI_Transport1 @FCI_Transport2 and in rhombohedral graphene aligned with hexagonal boron nitride @lu2024fractional has added an exciting new element to studies of the interplay between topological order @wen1995topological and lattice translational symmetry. Fractionalized ground states in moire systems are in the same universality class as the Laughlin state @Laughlin, so one would expect their long-wavelength, low-energy neutral excitations to be similar to the magnetorotons of FQH systems @GMP @GMP2. However, the presence of discrete translation symmetry should modify the collective excitations and enrich their behavior, giving rise to noticeable differences that lead to experimentally observable consequences.

In this Letter we investigate the simplest example of the interplay between periodic potentials, interaction-induced excitation gaps, and strong magnetic fields by examining how the neutral excitations of the gapped Laughlin FQH state evolve when a periodic potential is added to the Hamiltonian. The external potential mixes the magnetoroton @GMP @GMP2 excitations and folds their dispersion into the Brillouin zone defined by the periodicity. We find that magnetoroton mixing is governed by the equal-time three-point correlation function of the Laughlin state, which we evaluate using Monte Carlo simulations. As the periodic potential is made stronger, the minimum of the lowest magnetoroton band decreases, suggesting a soft-mode instability of the Laughlin state toward a competing Wigner crystal state that has an integer (with Chern number $C=0$ or $1$) rather than a fractional quantum Hall effect. The periodic potential also mixes moire reciprocal lattice vector magnetoroton excitations into the ground state, and as recognized previously @Fengcheng_MoireAssisted, by doing so makes the THz range intra-Landau-level excitations infrared active. Here we show that the coupling with THz radiation is strongly enhanced when the periodic potential’s primitive reciprocal lattice vectors align with the undisturbed system’s magnetoroton dispersion minimum, as illustrated in @fig1.

#figure(
  image("fig1.jpg", width: 85%),
  caption: [
    Magnetoroton band THz absorption as a function of the ratio of the magnetic length to the moire period, in units of $λ^2 (e^2/4ħ) ν$ where $λ$ is the periodic potential strength and $nu$ is the LL filling factor [cf. @eq:conductivity_approx]. A system of interest can be adjusted to the strong absorption regime either by varying the magnetic field or by varying the moire period. In tMoTe#sub[2] fractional quantum anomalous Hall states the THz absorption is weak but can be strengthened by applying an external magnetic field. The absorption is maximized when the number of flux quanta per unit cell $Φ_(u.c.) ≈ 2.82$, which is realized at magnetic field $B ≈ 15T$ for a 30 nm moire.
  ]
) <fig1>

Our theory applies most naturally to fractional quantum Hall states in the $N=0$ Landau level of graphene @Kim_Graphene_LL1 @Kim_Graphene_LL2 with a moire pattern induced either by alignment to hBN @young_blg_hbn or by a twist between hBN layers @zhao2021universal @woods2021charge @kim2024electrostatic in the substrate. It also applies to the fractional Chern insulator tMoTe#sub[2] @FCI_Experiment1 @FCI_Experiment2 @FCI_Transport1 @FCI_Transport2, since its layer-pseudospin Berry phases can be represented @AdiabaticAproximation1 @AdiabaticAproximation2 by an effective magnetic field with one flux quantum per moire unit cell 
#footnote[FQH states are sometimes referred to as FCI states whenever a periodic external potential is present. In this manuscript we reserve the term FCI for states in which the quantum Hall effect survives to zero magnetic field.]. Our work emphasizes the intimate relationship between FCI and FQH states and explains the wide range of twist angles over which FCI states are observed in tMoTe#sub[2].

==== Magnetoroton bands---
We consider the Landau levels generated by a constant magnetic field $B_0$ in the presence of a weak periodic potential $V(bold(r))$. The cyclotron gap is given by $hbar omega_c = e B_0\/m$, where $e$ and $m$ are the electron’s charge and mass. We assume that the cyclotron gap is the largest energy scale so that the low-energy physics is well approximated by projecting to the lowest Landau level (LLL).

When electronic interactions are included, the many-body Hamiltonian in the LLL with the periodic potential is

$
H = H_0 + V(bold(r)) = 1/(2A) sum_(bold(q)) V_(bold(q)) overline(rho)_(bold(q)) overline(rho)_(-bold(q)) + sum_(bold(G)) lambda_(bold(G)) overline(rho)_(bold(G))
$ <eq:MB_Hamiltonian>

In <eq:MB_Hamiltonian> the Coulomb potential $V_(bold(q))$, the system area $A$, and the projected density operator $overline(rho)_(bold(q))$ are defined as in the original work. The reciprocal lattice vectors $bold(G)$ and their corresponding coefficients $lambda_(bold(G))$ set the shape and strength of the potential. (Higher harmonics are suppressed by the magnetic form factor $e^(-|bold(G)|^2 ell^2/4)$, with ell the magnetic length.) We consider a C6-symmetric potential so that all six first-shell Fourier coefficients are equal and real; we denote them by $λ$, taken as a perturbative parameter.

We focus on filling $nu = 1\/3$ of the LLL—the simplest FQH state. In this case the $λ = 0$ ground state, $ket(Psi_0)$, is in the Laughlin universality class. When the periodic potential is added perturbatively, the state remains a good approximation despite mixing of Landau levels (a subleading effect when $hbar omega_c$ is large). Within the LLL the potential couples states differing by a reciprocal lattice vector, i.e. $ket(Psi_(bold(q)))$ and $ket(Psi_(bold(q)+bold(G)))$. Although this correction is small for the ground state, it is more prominent for the excitations @Fengcheng_MoireAssisted. The low-energy neutral excitations (for $λ = 0$) are described by the single-mode approximation (SMA) @GMP @GMP2:
$
ket(Psi_(bold(q))) = 1/sqrt(overline(S)_(bold(q)) N) overline(rho)_(bold(q)) ket(Psi_0), quad Delta_(bold(q)) = overline(f)_(bold(q))/overline(S)_(bold(q))
$ <eq:SMA>
where the projected oscillator strength is defined in <eq:oscillator_strength> and the projected structure factor is 
$
overline(S)_(bold(q)) = 1/N expval(overline(rho)_(bold(q))^dagger overline(rho)_(bold(q))) = S_(bold(q)) - (1 - e^(-q^2 ell^2\/2))
$ <eq:projected_structure_factor>

Furthermore, the magnetoroton gap can be computed using the GMP algebra
$
[overline(rho)_(bold(q)), overline(rho)_(bold(k))] = (e^(q^* k ell^2\/2) - e^(k^* q ell^2\/2)) overline(rho)_(bold(q)+bold(k))
$
with $q = q_x + i q_y$.

To study the effect of $λ != 0$, we expand the Hamiltonian in the SMA basis:
$
(h_(bold(q)))_(bold(G),bold(G')) = Delta_(bold(q)+bold(G)) δ_(bold(G),bold(G')) + λ ( expval(overline(rho)_(bold(q)+bold(G))^dagger overline(rho)_(bold(G)-bold(G')) overline(rho)_(bold(q)+bold(G'))) )/(N sqrt(overline(S)_(bold(q)+bold(G)) overline(S)_(bold(q)+bold(G')))
$ <eq:matrix_elements>

Here $bold(q)$ is restricted to the Brillouin zone, $bold(G)-bold(G')$ belongs to the first shell, and $Delta_(bold(q))$ is as in <eq:SMA>. (See Ref.~@Supplemental for details.) The magnetoroton bands are obtained by diagonalizing $h_(bold(q))$ across the Brillouin zone.

The off-diagonal terms in @eq:matrix_elements involve the three-point correlation function of the Laughlin state (projected to the LLL), which is related to the unprojected function by
$
expval( overline(rho)_(bold(q)_1)^dagger overline(rho)_(bold(q)') overline(rho)_(bold(q)_2) )_0 =
expval( overline(rho)_(bold(q)_1)^dagger rho_(bold(q)') rho_(bold(q)_2) )_0
- F( α^(q_1)_(q') + α^(q_1)_(q_2) + α^(-q')_(q_2))  \
- delta S_(bold(q)_2) F( α^(q_2)_(q') )
- delta S_(bold(q)_1-bold(q)_2) F( α^(q_1)_(q_2) )
- delta S_(bold(q)_1) F( α^(-q')_(q_2) )
$ <eq:Projected_Threepoint>
with $bold(q)' = bold(q)_1 - bold(q)_2$, $delta S_(bold(q)) = S_(bold(q)) - 1$, $F(α) = 1 - e^(-α\/2)$, and $α^(q_1)_(q_2) = q_1^* q_2 ell^2$. Equation <eq:Projected_Threepoint> generalizes <eq:projected_structure_factor> to the three-body case (see Ref.~@Supplemental). In practice we obtain the equal-time three-point distribution function via Monte Carlo sampling of Laughlin-state positions @Toby_Structurefactor, then use <eq:Projected_Threepoint> to compute the projected three-point function in @eq:matrix_elements. These are the two main technical elements of our work. Typical magnetoroton band results are shown in @fig:MR_Bandstructure.

#figure(
  image("MR_PhaseDiagram.svg", width: 100%),
  caption: [
    (a) Lowest energy magnetoroton band for $0 < λ < λ_c^+$, where $λ_c$ is the critical value for the FCI–CDW transition. (b) Line cut of the magnetoroton dispersion for several values of $lambda' = λ\/(e^2/(epsilon ell))$ along a path in the Brillouin zone. The magnetoroton minima, at the bold(κ)/bold(κ)' points, become negative for $λ > λ_c^+$ or $λ < λ_c^-$, indicating an instability of the Laughlin-like state. (c) The magnetoroton gap Delta as a function of $λ$ (bottom axis) and, for the tMoTe#sub[2] case, the deviation $delta θ$ of the twist angle theta from the magic angle theta_m (top axis). Insets show the potential-minima symmetry for positive and negative $λ$.
  ]
) <fig:MR_Bandstructure>

==== THz conductivity---
A simple expression for the THz intra‑band conductivity, derived in Ref.~@Fengcheng_MoireAssisted, is

$
Re sigma(omega) approx e^2/(4 ħ) ν sum_(bold(G)) bold(G)^2 ell^2 (|lambda_bold(G)|^2)/(Delta_bold(G)) overline(S)_bold(G) delta(ħ omega - Delta_bold(G))
$ <eq:conductivity_approx>

Here, $bold(G)$ is a first-shell reciprocal lattice vector and $ν = n_e\/n_(LL)$, with $n_e = N\/A$ and $n_(LL) = 1\/(2π ell^2)$. This equation was used to produce @fig1.

It is derived by taking the long-wavelength limit of the dynamic structure factor
$
S(bold(q), epsilon) approx sum_(bold(G)) abs((lambda_(bold(G)) expval( overline(rho)_(bold(q)+bold(G))^dagger overline(rho)_(bold(q)) overline(rho)_(bold(G)))_0)/(N Delta_(bold(G)) sqrt(overline(S)_bold(q)+bold(G))))^2 delta(epsilon - Delta_(bold(q)+bold(G)))
$ <eq:dynamicS> 
and noting that, since no dipole-allowed transitions exist in the LLL,
$
(expval( overline(rho)_(bold(q)+bold(G))^dagger overline(rho)_(bold(q)) overline(rho)_(bold(G)) )_0)/(N overline(S)_bold(q)+bold(G)) approx i ell^2 (bold(q) times bold(G)) dot hat(z)
$ <eq:3pt_approx>

Line traces of typical $sigma(omega)$ results are shown in @fig:cond.

#figure(
  image("fig3_3.svg", width: 100%),
  caption: [
    (a) Optical conductivity Re sigma(omega) computed from @eq:conductivity_approx for different values of $s$ (defined by $(bold(G) ell)^2 = s^2 4π\/sqrt(3)$, with $s = 1$ corresponding to one flux quantum per unit cell as in tMoTe#sub[2]). (a) Comparison of conductivity curves computed using @eq:3pt_approx (solid lines) and Monte Carlo three-point functions (dashed lines) along with @eq:dynamicS for various flux quanta per unit cell $Phi_(u.c.)$. (b) Projected structure factor for the Laughlin state ($nu = 1\/3$) from MC-fitted coefficients @GMP. The black dashed line shows $|bold(G)|$ for one flux quantum per unit cell; the red dashed line shows |bold(G)| for three flux quanta per unit cell (near the roton minimum). (c) Magnetoroton dispersion for the Laughlin state at $nu = 1\/3$, where the structure factor maximum corresponds to the roton minimum, suggesting a competing CDW state.
  ]
) <fig:cond>

Some of us @Toby_Structurefactor have previously argued that the magnetorotons of tMoTe#sub[2] FCI states are optically dark. In @eq:conductivity_approx this is evident because for one flux quantum per unit cell, $ |bold(G)|^2 ell^2 = 4π\/sqrt(3) approx 7.3,$ and at this large wavevector $overline(S)_bold(G) approx 0$ (see @fig:cond). Thus, even for a relatively strong external potential the optical conductivity remains small. However, if the period of the external potential (or the magnetic field) is tuned so that it coincides with the structure-factor peak, magnetorotons become accessible to THz spectroscopy – as shown in @fig1.
#footnote[In @fig1 the delta function is approximated by a Lorentzian, e.g. $delta(x) approx epsilon^2\/(π(x^2+epsilon^2))$ with $epsilon = 0.005$.]

For tMoTe#sub[2] the effective and applied magnetic fields are parallel, so the field required to bring the magnetoroton minimum into alignment with the moire reciprocal lattice vector must supply approximately $1.7$ flux quanta per cell—requiring fields of order $100$ T for typical moire periods. In contrast, for the $N = 0$ Landau levels of graphene aligned to hBN the strongest effective periodic potential occurs for a moire period $a_M approx 14$~nm, where THz coupling is maximized at $B approx 68$~T (still rather high). We therefore conclude that the optimal strategy for enabling THz studies of magnetorotons is to form a long-period t-hBN moire in the dielectric stack @zhao2021universal @woods2021charge @kim2024electrostatic. For example, a $30$~nm moire period reduces the required magnetic field to about $B approx 15$~T.

==== Discussion---
Even though the low-energy excitations of FQH systems are normally optically dark, they have been observed via inelastic light scattering @Pinczuk_MRM1 @Pinczuk_MRM2 @Pinczuk_MRM3 @Pinczuk_MRM4 @MRM_vonKlitzing @Pinczuk_LightScattering. Away from the long-wavelength chiral graviton limit @Chiral_Gravitons, the light-scattering mechanism is not well understood but is believed to be disorder activated, yielding a signal proportional to the magnetoroton density of states. Here we have shown that a periodic potential makes the magnetoroton modes optically active. At laboratory magnetic fields the optimal period for an external potential aimed at THz spectroscopy is approximately $30$ nm. Such periodic potentials have been realized using t-hBN (see, e.g., *Reference?*) or via patterned gate dielectrics @forsythe2018band @Cano_PatternedDielectric, among other techniques. We believe that recent progress with van der Waals heterojunction devices now brings THz optical probes of FQH and FCI collective modes within reach.

The single-mode approximation (SMA) we employ is valid when only one collective mode at each wavevector couples strongly to external perturbations. Although the SMA accurately describes Laughlin states for moderate $bold(q)$ values @GMP @GMP2, it breaks down at large $bold(q)$ where the lowest excitations are fractional particle–hole pairs with very small oscillator strengths. In that limit the SMA energy represents an oscillator-strength–weighted average over a continuum of excitations, yet it still captures the weak mixing induced by large reciprocal lattice vectors on the lowest magnetoroton band.

The framework developed here --- based on the SMA and the evaluation of equal-time three-point correlation functions --- is complementary to other numerical approaches @Repellin_MRM @KaiSun_MRM1 @KaiSun_MRM2 @ChongWang_MRM_ED @MRM_DMRG1 @Hyperdeterminants @Fengcheng_MoireAssisted @Toby_Structurefactor @Debanjan_Structurefactor. As presented it applies to $ν = 1\/m$ Laughlin states, but it could be extended to other FQH states (e.g. those in the Jain sequence @Ajit_GMP1 @Ajit_GMP2) using composite fermion exciton pictures @KamillaJain1 @KamillaJain2. Our conclusion --- that patterning on the $30$~nm scale enables THz probes of FQH collective modes --- should hold for a wide range of FQH states with rich, not fully understood excitation spectra.


#bibliography("refs.bib")
