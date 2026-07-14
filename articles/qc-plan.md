# PLAN QC technical reference

PLAN QC evaluates whether a general analysis plan or coding
specification can be translated into R code without inferring
study-specific requirements.

[Return to the QC skills
guide](https://gestimation.github.io/airsetup/articles/qc-skills.md)

[Japanese
version](https://gestimation.github.io/airsetup/articles/qc-plan-jp.md)

## Purpose and scope

PLAN QC determines whether data extraction, variable derivation,
statistical processing, and output generation are uniquely defined when
the plan is converted into an R implementation specification. It
evaluates **implementation readiness, internal consistency,
traceability, and the risk of unapproved assumptions**, not prose
quality.

Apply PLAN QC to general analysis plans or coding specifications. Use
SAP QC for a clinical-trial SAP, and return to CONTEXT QC when the
analysis purpose or data semantics remain unresolved.

## Entry criteria

| Input | Requirement |
|----|----|
| Analysis plan or coding specification | Required; the reviewed version must be identifiable |
| Analysis request or CONTEXT QC | Recommended for checking purpose and assumptions |
| Data definition or variable list | Normally required for R implementation readiness |
| Output specification or mock shell | Required for output implementation readiness |
| `QC_STATUS.md` | Optional; used to follow unresolved items |

## When to use it

- After drafting a plan for descriptive statistics, cross-tabulations,
  epidemiologic research, or registry research
- After specifying an exploratory analysis
- Before R coding
- When an implementer identifies ambiguity
- When RESULT QC identifies an incomplete plan

Use [SAP QC](https://gestimation.github.io/airsetup/articles/qc-sap.md)
rather than PLAN QC for a clinical-trial SAP.

## Review scope

- Analysis purpose and hypotheses
- Population and analysis unit
- Endpoints and variables
- Analysis time points and time definitions
- Statistical methods and models
- Missing-data handling
- Subgroup and sensitivity analyses
- Output specifications
- R implementation and packages
- Known constraints, assumptions, and unresolved items

When CONTEXT QC or `QC_STATUS.md` is available, check consistency with
the plan.

## Primary review domains

### 1. Analysis purpose

- What will be described, compared, estimated, or predicted?
- Are primary, supplementary, and exploratory analyses distinguished?
- Are comparison direction and interpretation targets explicit?

### 2. Population and analysis unit

- Can inclusion and exclusion criteria be implemented?
- Is the analysis unit—one row per participant or observation, for
  example—explicit?
- Are repeated observations, multiple events, and clustering addressed?
- Are denominators and analysis-population flags defined?

### 3. Endpoints and variables

- Are columns or derivation sources identified?
- Are units, categories, reference values, and assessment times
  explicit?
- Are formulas, windows, priorities, and tie-breaking rules specified?
- Are baseline and change-from-baseline definitions explicit?

### 4. Time-related specifications

For time-to-event or longitudinal analyses, review the time origin,
event definition, censoring rules, competing events, assessment period,
visit windows, and priority for same-day events. Ambiguity can produce
different results even when code runs successfully.

### 5. Statistical methods

- Is a method specified for each purpose and endpoint?
- Are effect measures, confidence intervals, tests, and one- or
  two-sided inference explicit?
- Are model formulas, covariates, stratification factors, and
  interactions defined?
- Are reference categories and comparison directions unique?
- Are model assumptions and diagnostics required?

“Perform a regression analysis” does not identify the model,
distribution, link, covariates, or estimand.

### 6. Missing data

Review missing-value definitions and codes, complete-case or imputation
rules, the stage at which records are excluded, reporting of missingness
and analysis counts, and the need for sensitivity analysis.

### 7. Subgroup and sensitivity analyses

Determine whether analyses are prespecified or exploratory; define
subgroup variables and categories; distinguish within-group estimation
from interaction testing; address multiplicity; and identify differences
from the primary analysis.

### 8. Output specifications

Specify output types, rows, columns, groups, time points, statistics,
counts, denominators, missing-value displays, digits, units, confidence
intervals, p-values, titles, footnotes, abbreviations, destinations, and
filenames.

### 9. R implementation

Review responsibilities for import and preprocessing, intended functions
or packages, package availability and versions, random seeds, logs,
[`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html), and
destinations for intermediate and final outputs. Do not claim that a
named package is installed or executable without verification.

## Implementation-readiness judgment

| Status | Application |
|----|----|
| `Ready` | Implementation requires no study-specific inference |
| `Mostly ready` | Implementation can proceed after limited clarification or minor correction |
| `Partially ready` | Some work can proceed, but important specifications remain unresolved |
| `Not ready` | Important omissions or inconsistencies should block implementation |
| `Cannot assess` | The plan or related material is insufficient |
| `Not applicable` | The next step does not apply to the task |

When only part of the plan is ready, distinguish the permitted
implementation scope from work that must remain on hold.

## AI assumption risks

Do not let the AI infer the population or exclusion criteria, endpoint
derivations, time origin, event and censoring rules, missing-data
handling, model formula, adjustment variables, reference category,
comparison direction, subgroup definitions, or table denominators and
formats.

Any suggested option must be separated from plan-defined facts and
recorded as requiring user approval.

## Decision rules and evidence requirements

Evaluate implementation readiness against at least three conditions:

1.  **Uniqueness**: independent implementers would produce the same
    principal extraction, derivations, models, and outputs.
2.  **Traceability**: each specification maps to an analysis purpose,
    variable definition, or output requirement.
3.  **Executability**: inputs, processing order, package constraints,
    and destinations are identifiable.

Use `OK`, `Needs clarification`, `Problem`, `Cannot assess`, or
`Not applicable` for each domain. Do not label an implementation as
`Ready` when it depends on a Critical or Major issue.

`Evidence` identifies plan sections, table numbers, variables, formulas,
mock-shell identifiers, user decisions, or referenced CONTEXT QC issue
IDs. External knowledge or general practice is not evidence for a
study-specific requirement.

## Output file

``` text
ai_project/qc/plan-qc-001.md
```

Use sequential numbers for later reviews and retain earlier reports. The
standard report contains 12 sections: Skill information, Overall
judgment, Readiness by next step, Materials reviewed, Domain assessment,
Issues, Cannot-assess items, AI assumption risks, Required clarification
questions, Recommended next actions, Quick assessment, and Handoff.

The Issues table contains `ID`, `Severity`, `Issue`, `Evidence`, and
`Recommended action`, including the affected process or output when
implementation is blocked.

## Decision examples

### `Ready`

``` text
Endpoint and variable clarity: OK
Evidence: Section 3.2 "Primary outcome" in plan.md; SBP_BL and SBP_W12 in definition.csv
Assessment: The primary endpoint is SBP_W12 - SBP_BL, in mmHg; do not derive it when either value is missing.
R implementation readiness: Ready
```

### `Not ready`

``` text
Method clarity: Problem
Issue: The plan only states "compare the groups"; effect measure, model, and adjustment variables are unspecified.
Severity: Major
Impact: The model formula and primary estimate cannot be implemented uniquely.
R implementation readiness: Not ready
```

## Review limitations

PLAN QC evaluates plan clarity and R implementation readiness. It does
not guarantee that the selected method is optimal, that code or
calculations are correct, or that scientific conclusions are valid.
