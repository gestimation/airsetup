# Data from a prostate cancer trial in Byer & Green (1980)

Anonymized data from a randomized clinical trial of prostate cancer
published in Byer & Green (1980).

## Usage

``` r
data(prostate)
```

## Format

A data frame with 502 observations and 18 variables, including:

- dtime:

  Follow-up time in months.

- status:

  Event status ("alive", "dead - prostatic ca", "dead - other ca",
  "dead - heart or vascular", "dead - cerebrovascular").

- rx:

  Treatment assignment to diethylstilbestrol (DES) or a placebo.

- age:

  Age at baseline (years).

- wt:

  Weight in pounds.

- pf:

  Performance status.

- hx:

  History of cardiovascular disease.

- sbp:

  Systolic blood pressure.

- dbp:

  Diastolic blood pressure.

- ekg:

  Electrocardiogram category.

- hg:

  Hemoglobin level.

- sz:

  Size of the primary tumor.

- sg:

  Stage/grade of disease.

- ap:

  Serum acid phosphatase.

- bm:

  Bone metastases indicator.

- stage:

  Clinical stage.

- sdate:

  Start date.

- patno:

  Patient number.

## Source

Byer, D. P. & Green, S. B. (1980), 'Prognostic variables for survival in
a randomized comparison of treatments for prostatic cancer', Bulletin du
Cancer 67, 477-488

## Details

The dataset records follow-up for cause of death together with treatment
assignment and baseline characteristics. It is used in the package
documentation to illustrate stratified cumulative incidence analyses.

## Examples

``` r
data(prostate)
#> Warning: data set 'prostate' not found
head(prostate)
#> Error: object 'prostate' not found
```
