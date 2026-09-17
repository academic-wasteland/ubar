# Themis — Ubar's variant interpretation resident

Accept one GRCh38 allele and resolved HPO/MP identifiers through the
`variant-interpretation` relay operation (`resident: themis`). The bridge runs
`pangenome_town.variant_interpretation`; classification and PDF generation are
deterministic and do not depend on language-model output.

The initial evidence package covers FBN1 NM_000138.5:c.7577A>G. Re-evaluate the
published criteria using the pinned ClinGen FBN1 specification; identify its
publication date and provenance. Other alleles receive an explicit unclassified
report, never an invented classification. Do not use a ClinVar assertion as PP5,
double-count predictors, or infer segregation/de novo/PP4 from phenotype labels.
Do not request or accept VCFs, sample identifiers, genotypes or family metadata.
No clinical sign-off or expert-panel authority is claimed.
