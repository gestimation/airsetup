# SAP QC technical reference

SAP QC reviews a clinical-trial statistical analysis plan (SAP) for
statistical specification, supporting evidence, cross-document
consistency, and R implementation readiness. It combines general checks
with a summarized 55-item SAP checklist and supplementary checks
informed by ICH M11 and E9(R1).

[Return to the QC skills
guide](https://gestimation.github.io/airsetup/articles/qc-skills.md)

[Japanese
version](https://gestimation.github.io/airsetup/articles/qc-sap-jp.md)

## Purpose and scope

SAP QC evaluates four axes separately:

1.  SAP internal completeness
2.  Cross-document consistency
3.  Statistical specification readiness
4.  R implementation readiness

Checklist counts are a descriptive inventory, not a score, pass rate, or
approval threshold. SAP QC is not a substitute for regulatory compliance
review, formal SAP approval, clinical review, or review by the
responsible statistician.

## Entry criteria

An identifiable SAP or SAP draft is required. Record its filename,
version, and date.

| Input | Requirement |
|----|----|
| SAP or SAP draft | Required |
| Protocol and amendment history | Required for cross-document consistency |
| `M11SEMANTIC_MAP.md` | Optional; used as evidence when available |
| CRF, data definition, or analysis-data specification | Required for variable-level R readiness |
| Mock tables, figures, and listings | Recommended for output review |

Internal SAP review can proceed without a protocol, but cross-document
consistency is then `Cannot assess`. SAP QC does not recreate a complete
`M11SEMANTIC_MAP.md`.

## When to use it

- After drafting and before finalizing an SAP
- After a protocol amendment
- Before preparing R programming specifications
- Before judging whether results follow the SAP
- When organizing versions, evidence, and unresolved SAP items

Use [PLAN
QC](https://gestimation.github.io/airsetup/articles/qc-plan.md) for a
general analysis plan. Use [M11 SEMANTIC
QC](https://gestimation.github.io/airsetup/articles/qc-m11semantic.md)
first when trial semantics must be organized across documents.

## Materials and evidence

Review the SAP, protocol and amendment history, `M11SEMANTIC_MAP.md`,
CRFs and data definitions, analysis-dataset specifications, mock
outputs, and relevant data-management materials as available.

Distinguish content supported by the protocol or another source,
statistical detail defined only in the SAP, inconsistencies,
unverifiable content, and reviewer or AI proposals. Do not fill
study-specific gaps from general practice.

Study-specific findings identify a SAP section, table, page, concise
relevant wording, or another traceable source location. Cross-document
judgments cite both sources. Proposed replacement text or analysis
options are labeled `Proposed - not source-specified or approved`.

## Primary review domains

### Document control

Review the SAP title, study identifier, version, date,
authoring/review/approval status, revision history and rationale,
corresponding protocol version, and timing relative to unblinding and
database lock.

### Study objectives and design

Review primary, secondary, and exploratory objectives; design and
treatment groups; randomization and stratification; control, blinding,
duration, and assessment schedule; and alignment of objectives,
endpoints, and analyses.

### Estimand

For each primary clinical question, review Population, Treatment
condition, Variable (endpoint), intercurrent events and strategies, and
Population-level summary. Do not assign an intercurrent-event strategy
when it is not supported by a source.

### Analysis sets

Review definitions of Randomized, Safety, FAS, ITT, PPS, and other sets;
inclusion and exclusion rules; randomized versus actual treatment;
important protocol deviations; and analyses performed in each set.

### Endpoints and derivations

Review primary, secondary, safety, and exploratory endpoints; source
variables; assessment times; units; formulas; baseline and change
definitions; visit windows; multiple measurements; missing data;
unscheduled visits; and mapping to mock outputs.

### Statistical methods

Review primary models and effect measures, covariates and strata,
reference categories, confidence intervals, tests and alpha, model
assumptions and estimation, nonconvergence handling, descriptive rules,
and time origins, events, and censoring for time-to-event analyses.

### Missing data

Review missingness definitions, primary-analysis handling, imputation
methods and conditions, auxiliary variables, models, seeds, assumptions,
and links to sensitivity analyses.

### Sensitivity and supplementary analyses

Identify the primary-analysis assumption being examined, the changed
condition, population, variables, model, comparator, and interpretation
if results differ.

### Multiplicity and interim analyses

Review multiplicity families and methods, test sequence, gatekeeping and
alpha allocation, interim timing and purpose, analyst and access
controls, stopping rules, alpha spending, and independent-committee
responsibilities.

### Safety analyses

Review the safety population and treatment classification, adverse-event
period, severity and causality, TEAE definition,
laboratory/vital-sign/ECG summaries, events of special interest, deaths,
serious adverse events, and discontinuations.

### Sample size

Review the link to the primary hypothesis, calculation method, effect
and variance or event assumptions, dropout, alpha, power, allocation,
multiplicity, interim analysis, noninferiority margins, and supporting
sources.

### Outputs and reproducibility

Review output identifiers and purposes, populations, groups,
denominators, time points, statistics, digits, units, footnotes,
missing-value displays, software and versions, seeds, logs,
traceability, and handoff to R implementation.

## The 55-item checklist

The checklist is a cross-domain completeness framework. The standard
report summarizes domain results and items requiring action rather than
mechanically listing all items. Produce the full matrix when requested.
Prioritize the impact of important missing specifications over checklist
completion counts.

## Checklist status values

| Status | Application |
|----|----|
| `Addressed` | The SAP explicitly addresses the item and a source location can be cited |
| `Partially addressed` | Relevant text exists but required analysis detail is incomplete |
| `Not addressed` | The SAP was reviewed and the item could not be located |
| `Unclear` | Relevant text exists but has no unique interpretation |
| `Inconsistent` | Statements conflict within the SAP or across supplied materials |
| `Cannot assess` | Required material is unavailable, unreadable, or out of scope |
| `Not applicable` | Non-applicability is supported by documents or design |

Assign issue severity separately as `Critical`, `Major`, `Minor`, or
`Note`. Do not use `Not applicable` without evidence. Distinguish an
absent SAP statement (`Not addressed`) from an unavailable basis for
judgment (`Cannot assess`).

## Decision rules

- Do not mark an affected axis `Ready` when Critical issues concern
  analysis sets, primary endpoints, primary estimands, primary analyses,
  or missing-data handling.
- A Major issue normally makes the affected axis `Partially ready` or
  `Not ready`.
- If sources for cross-document consistency are unavailable, mark that
  axis `Cannot assess` while judging internal completeness separately.
- Do not determine the overall judgment from checklist counts alone.
- Judge SAP completeness and R implementation readiness separately.
- Do not replace study-specific omissions with convention or external
  knowledge.

## Decision to proceed to R coding

At minimum, the analysis population, primary endpoint, treatment groups,
analysis time, statistical method, missing-data handling, comparison
direction, and output specification must be implementable. If only
common import or preprocessing work can proceed, separate confirmed
specifications from provisional proposals and do not treat resulting
analyses as final.

## Output file

``` text
ai_project/qc/sap-qc-001.md
```

Retain earlier reports and increase the number for later reviews. The
standard `Clinical SAP QC Report` contains Review scope, Readiness
summary, Clinical SAP checklist summary, Items requiring attention, AI
assumption risks, User decisions required, Recommended next step, and a
`QC_STATUS.md` update note.

Readiness is recorded for each of the four axes as `Ready`,
`Partially ready`, `Not ready`, or `Cannot assess`. The attention table
contains `Item`, `Status`, `Severity`, `Evidence`,
`Statistical or R impact`, and `Required resolution`. A requested full
matrix uses `Item`, `Status`, `Evidence`, `Finding`, and
`Required resolution`.

## Decision example

``` text
Item: 20 Analysis sets
Status: Partially addressed
Severity: Major
Evidence: SAP 6.1, "FAS includes randomized participants"
Finding: Exclusion criteria and treatment-classification rules are missing.
Statistical or R impact: The FAS flag and treatment variable cannot be derived uniquely.
Required resolution: Confirm exclusion criteria and the randomized/actual-treatment rule.
```

## Review limitations

SAP QC assesses statistical specifications, evidence, consistency, and
implementation readiness. It does not certify complete regulatory
compliance, formal SAP approval, optimal statistical methods, or
complete correctness of code and results.
