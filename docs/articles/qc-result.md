# RESULT QC technical reference

RESULT QC reviews tables, figures, estimates, model outputs, execution
logs, and result narratives produced after analysis in R. It assesses
alignment with the plan, numerical internal consistency, correspondence
with code and logs, presentation, interpretation, and traceability.

[Return to the QC skills
guide](https://gestimation.github.io/airsetup/articles/qc-skills.md)

[Japanese
version](https://gestimation.github.io/airsetup/articles/qc-result-jp.md)

## Purpose and scope

RESULT QC determines whether results are consistent with the plan, code,
execution record, and narrative interpretation within the available
evidence. Internal-consistency review, code correspondence, rerunning,
and independent recalculation are distinct verification depths.

RESULT QC does not automatically include independent review of all code
or reprogramming of the statistical analysis. Do not describe work as
reproduced or independently verified unless those operations were
performed.

## Entry criteria

At least one table, figure, model output, log, or result narrative is
required. Each stronger judgment requires its corresponding input.

| Judgment | Required input |
|----|----|
| Presentation and internal consistency | Table, figure, or model output |
| Conformance to plan | Result plus analysis plan or SAP |
| Correspondence with code | Result plus R script |
| Execution status | Result plus execution log |
| Rerun | Data, code, and execution environment |
| Independent recalculation | Data, independent specification, and independent code |

## Verification depth

| Level | Review performed | Main limitation |
|----|----|----|
| 1 | Internal consistency of tables, figures, and text | Generation process cannot be verified |
| 2 | Correspondence with the plan or SAP | Actual code implementation cannot be verified |
| 3 | Static correspondence with code and logs | Identical regeneration is not demonstrated |
| 4 | Rerun using the supplied code | The code itself is not independent |
| 5 | Recalculation from an independent specification and code | Depends on source-data and independent-specification accuracy |

Report the actual materials reviewed and operations performed, not
merely the highest possible level suggested by available files.

## When to use it

- After creating tables, graphs, regression models, survival analyses,
  or competing-risk analyses
- After producing an R Markdown or Quarto report
- After an AI agent drafts result text
- Before drafting a paper or report result section
- Before transferring results to collaborators
- When assessing warnings, errors, or the need for reanalysis

``` text
Analysis plan or SAP
    ↓
R script
    ↓
Analysis execution in R
    ↓
RESULT QC
    ↓
Correction and reanalysis when required
    ↓
Report or manuscript
    ↓
Human statistical review
```

## Review targets

Review descriptive, cross-tabulation, and baseline tables; group
comparisons and models; survival and competing-risk outputs; estimates,
confidence intervals, and p-values; subgroup, sensitivity, and safety
analyses; R scripts, console output, and logs; R Markdown or Quarto
reports; and drafted interpretations.

Review the generating code, execution record, plan, and dataset
information when available—not only the displayed result.

## Materials and assessable scope

| Material supplied | Main assessable scope |
|----|----|
| Tables or figures only | Internal consistency, presentation, labels, interpretation |
| Results plus plan | Conformance to planned outputs |
| Results plus R code | Apparent correspondence between code and result |
| Results plus code and logs | Warnings, errors, and execution state |
| Data plus code and environment | Stronger reproducibility check |
| Independent verification code | Numerical comparison by independent recalculation |

A table alone may support checks of displayed internal consistency, but
not proof that it was generated from the correct data and code.

## Six review domains

### 1. Conformance to planned outputs

Review analysis population, endpoint and time point, comparison groups,
method and effect measure, confidence intervals and p-values, adjustment
and stratification variables, subgroup and sensitivity analyses, output
type, and classification as primary, sensitivity, or supplementary.

For example, presenting only PPS results when FAS is specified for the
primary analysis is a plan inconsistency.

### 2. Numerical internal consistency

Review overall and group counts, exclusions, numerators, denominators,
percentages, row and column totals, missing counts, event and censoring
counts, model-specific analysis counts, and rounding differences.

Identify whether a percentage denominator is all participants,
nonmissing participants, or evaluable participants. Record recalculation
formulas, display precision, and rounding rules. Use a
specification-defined tolerance when available; do not invent a
tolerance during QC.

### 3. Estimates, confidence intervals, and p-values

Review estimate direction and reference group, effect measure and scale,
confidence level, whether the estimate lies within its interval, broad
consistency with the p-value, transformed versus original scales, and
adjusted versus unadjusted results.

An estimate outside its displayed interval requires review of
presentation, scale transformation, comparison direction, or
transcription.

### 4. Correspondence with code and logs

Trace the input dataset, filters and analysis flags, grouping and
reference categories, variable derivations, missing-data handling, model
formula and covariates, confidence-interval method, packages, labels,
and output files.

An “adjusted for age and sex” label is inconsistent if the model formula
contains neither variable. Logs should be checked for errors, warnings,
record counts, exclusions, R and package versions, random seeds,
convergence, singularity, separation, collinearity, and relevant model
assumptions.

The existence of code is not by itself evidence that the displayed
output was generated by that code.

### 5. Clarity of tables and figures

For tables, review title, population, groups, row and column labels,
denominator, units, time points, missingness, estimates, reference
categories, abbreviations, footnotes, and digits.

For figures, review title, axes, units, groups and legends, confidence
intervals, time points, risk sets, censoring marks, and estimation
method. Distinguish a cumulative incidence function from
`1 - Kaplan–Meier` when competing risks exist.

For model outputs, identify variables, categories and references,
adjustment, effect measures, analysis counts, events, covariates, and
units.

### 6. Interpretation and traceability

Check that text matches numbers, effect direction and units are correct,
uncertainty is acknowledged, nonsignificance is not equated with no
difference, association is not described as causation, exploratory
findings are not presented as confirmatory, and subgroup heterogeneity
is not inferred from separate significance tests.

Confirm traceability to dataset and version, data-cut date, plan
version, scripts, logs, R and package versions, outputs, limitations,
and unresolved items.

## RESULT QC versus code QC

RESULT QC evaluates correspondence between results and code. It is not
an independent review of every branch and exception in the code. Without
independent code and recalculation from source data, do not treat it as
independent numerical verification.

## AI assumption risks

| Missing information | Possible AI assumption | Main impact |
|----|----|----|
| Denominator | Use the displayed total | Percentage meaning may change |
| R code | Assume values were computed correctly | Calculation errors cannot be assessed |
| Execution log | Assume successful completion | Warnings and errors cannot be assessed |
| Group direction | Use the first group as reference | Effect direction may be wrong |
| Study design | Describe an association causally | Results may be overinterpreted |

Record unavailable information rather than infer it.

## Decision rules and evidence requirements

Use `OK`, `Needs clarification`, `Problem`, `Cannot assess`, or
`Not applicable` for each domain.

- A mismatch in the primary population, group labels, endpoint, or model
  is normally Critical or Major.
- Do not mark reporting or interpretation `Ready` when a primary model
  has not converged or an interpretation-relevant warning is unresolved.
- If code or logs are unavailable, use `Cannot assess` for those domains
  and do not infer computational accuracy.
- Presentation-only issues may be Minor or Note depending on impact.
- Distinguish issues requiring reanalysis from those resolved by
  presentation or text changes.

`Evidence` identifies table or figure numbers, cells or row labels,
model names, output filenames, script names and processing labels,
warnings, plan sections, and recalculation formulas. Reference long logs
or [`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html) in
separate files rather than pasting them into the report.

## Output file

``` text
ai_project/qc/result-qc-001.md
```

Use sequential numbers for later reviews and retain earlier reports. The
standard report contains Skill information, Overall judgment, Readiness
by next step, Materials reviewed, Domain assessment, Issues,
Cannot-assess items, AI assumption risks, Required clarification
questions, Recommended next actions, Quick assessment, and Handoff to
next workflow step.

The Issues table contains `ID`, `Severity`, `Issue`, `Evidence`, and
`Recommended action`. When reanalysis is required, specify the changed
process, the rerun scope, and outputs invalidated by the change.

## Actions after QC

| Finding | Main action |
|----|----|
| Variable, row unit, or population unclear | Return to CONTEXT QC |
| General analysis specification unclear | Return to PLAN QC |
| Clinical-trial statistical specification unclear | Return to SAP QC |
| Code and result disagree | Review the R script |
| Code, data, or conditions changed | Rerun the analysis in R |
| Values are correct but presentation is incomplete | Revise the table or figure |
| Result narrative is inappropriate | Revise the narrative |

## Decision examples

### Internal-consistency issue

``` text
ID: M-001
Severity: Major
Issue: The percentage for Treatment A in Table 2 does not match the displayed numerator and denominator.
Evidence: Table 2, "Any adverse event": 18/60, displayed as 25.0%; 18/60 = 30.0%.
Recommended action: Review the aggregation code, transcription, and denominator definition; regenerate Table 2.
```

### Limitation of review scope

``` text
Domain: Code and log consistency
Status: Cannot assess
Missing information: R script and execution log used to generate Table 2
Why needed: Population extraction, denominator, warnings, and the actual generation process cannot be verified.
```

## Review limitations

RESULT QC alone cannot establish source-data accuracy, complete
correctness of all R code, independent reproducibility of every
calculation, optimal statistical methods, complete SAP conformance, or
final scientific validity. Record the assessed scope and unresolved
items, then hand them off for correction or human review.
