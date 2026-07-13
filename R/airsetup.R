#' airsetup: project setup for AI-assisted R workflows
#'
#' Lightweight project scaffolding for AI-assisted R analysis workflows.
#'
#' @keywords internal
"_PACKAGE"

initial_dir_name <- function(date = Sys.Date()) {
  paste0("initial_", format(as.Date(date), "%Y%m%d"))
}

has_dated_initial_dir <- function(path, parent) {
  target <- file.path(path, parent)
  if (!dir.exists(target)) return(FALSE)

  dirs <- list.dirs(target, full.names = FALSE, recursive = FALSE)
  any(grepl("^initial_[0-9]{8}$", dirs))
}

required_dirs <- function() {
  c(
    "source",
    "ai_visible_data",
    "ai_output",
    "r_output",
    "qc",
    "log",
    "agent_control"
  )
}

required_files <- function() {
  c("AGENTS.md", "QC_STATUS.md")
}

create_ai_initial_dirs <- function(path, date = Sys.Date()) {
  initial <- initial_dir_name(date)

  dirs <- c(
    file.path("source", initial),
    file.path("ai_visible_data", initial)
  )

  for (dir in dirs) {
    dir.create(file.path(path, dir), recursive = TRUE, showWarnings = FALSE)
  }

  invisible(dirs)
}

write_if_allowed <- function(path, lines, overwrite = FALSE) {
  if (file.exists(path) && !overwrite) return(FALSE)
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  writeLines(lines, path, useBytes = TRUE)
  TRUE
}

validate_flag <- function(value, name) {
  if (!is.logical(value) || length(value) != 1L || is.na(value)) {
    stop(sprintf("`%s` must be TRUE or FALSE.", name), call. = FALSE)
  }
  invisible(value)
}

agents_md_template <- function(japanese = FALSE,
                               qc_agent = FALSE,
                               split = TRUE,
                               skills = TRUE) {
  if (!is.logical(japanese) || length(japanese) != 1L || is.na(japanese)) {
    stop("`japanese` must be TRUE or FALSE.", call. = FALSE)
  }
  validate_flag(qc_agent, "qc_agent")
  validate_flag(split, "split")
  validate_flag(skills, "skills")

  hidden_data_header <- if (isTRUE(split)) {
    "- `../r_project/ai_hidden_data/`"
  } else {
    "- `../r_project/ai_hidden_data/`, when split project structure is used"
  }

  hidden_data_reference <- if (isTRUE(split)) {
    "`../r_project/ai_hidden_data/`"
  } else {
    "the split-project hidden-data area (`../r_project/ai_hidden_data/`, when split project structure is used)"
  }

  base <- c(
    "# AGENTS.md",
    "",
    "This file defines the shared working rules for Codex in this project. Do not",
    "create folder-specific `AGENTS.md` files unless the user explicitly asks for",
    "them. This root file is the default authority.",
    "",
    "## Project Map",
    "",
    "- `source/`",
    "  - Stores source specifications, reference documents, and original materials.",
    "  - Initial materials should be placed under `source/initial_YYYYMMDD/`.",
    "  - Additional materials should be placed under `source/addition_YYYYMMDD/`.",
    "  - Use this folder for protocols, SAPs, database definitions, and other",
    "    source materials. Do not place generated QC skill templates here.",
    "  - Treat this folder as read-only. Codex must not overwrite, move, or delete",
    "    source materials.",
    "",
    "- `agent_control/`",
    "  - Stores AI/agent control files.",
    "  - Detailed agent role definitions and QC skill instructions are stored here.",
    "  - `AGENT_CONTROL_INDEX.md` explains available agent-control files.",
    "  - `WORKFLOW_AGENT.md` and `QC_AGENT.md` are created here when",
    "    `qc_agent = TRUE`.",
    "  - `QC_SKILL_*.md` files are created here when `skills = TRUE`.",
    "  - Agent-control files such as skill templates belong under `agent_control/`.",
    "",
    "- `ai_visible_data/`",
    "  - Stores dummy or visible data that Codex is allowed to inspect.",
    "  - Initial visible data should be placed under `ai_visible_data/initial_YYYYMMDD/`.",
    "  - Additional visible data should be placed under",
    "    `ai_visible_data/addition_YYYYMMDD/`.",
    "  - Treat this folder as read-only.",
    "  - Codex may use it for column inspection and script design.",
    "  - Codex must not run generated R scripts by default, even against dummy",
    "    visible data, unless the user explicitly asks Codex to run them.",
    "  - This folder is append-only. Later additions do not replace earlier files.",
    "",
    hidden_data_header,
    "  - Stores analysis data that Codex must not inspect directly.",
    "  - It is assumed to follow the same folder convention as visible data:",
    "    `initial_YYYYMMDD/` for initial data and `addition_YYYYMMDD/` for additions.",
    "  - Codex must not list, open, copy, move, summarize, or otherwise inspect this",
    "    folder or its contents.",
    "  - R scripts may reference this folder by relative path for user-run analysis.",
    "",
    "- `ai_output/`",
    "  - Stores Codex-generated deliverables.",
    "  - Put R scripts, READMEs, check notes, helper scripts, and similar generated",
    "    files here.",
    "",
    "- `r_output/`",
    "  - Stores outputs from R scripts that the user runs manually.",
    "  - Codex may inspect this folder to validate whether scripts ran correctly.",
    "  - Codex should not overwrite user-generated R outputs unless the user",
    "    explicitly asks for it.",
    "",
    "- `qc/`",
    "  - Stores QC-specific materials such as review results, discrepancy notes,",
    "    temporary counts, and reconciliation materials.",
    "  - Keep QC materials separate from `source/`: `source/` is for specifications",
    "    and source/reference materials, while `qc/` is for verification work and",
    "    review results.",
    "  - Additional QC materials should be placed under `qc/addition_YYYYMMDD/`.",
    "  - Codex may use QC materials as the basis for script revisions, review lists,",
    "    and validation notes.",
    "  - Codex must not treat QC conclusions requiring human judgment as final",
    "    without user approval.",
    "  - QC agent deliverables belong under `qc/`. The QC agent must not directly",
    "    overwrite Workflow agent outputs.",
    "",
    "- `log/`",
    "  - Stores Codex work logs, investigation notes, decision traces, and execution",
    "    records.",
    "  - Deliverables belong in `ai_output/`; R outputs belong in `r_output/`; QC",
    "    materials belong in `qc/`.",
    "  - Files under `log/` are historical records. They may explain what happened,",
    "    but they are not the current project status unless `QC_STATUS.md` explicitly",
    "    refers to them.",
    "  - Log only decisions and context that affect later work. Detailed chronological",
    "    logs are optional.",
    "",
    "- `QC_STATUS.md`",
    "  - Tracks QC items and their current status.",
    "  - Keep it at the root of `ai_project/`.",
    "  - Codex should check it before any substantive work, including script",
    "    generation, review, validation, interpretation, and QC work.",
    "  - Codex should update it when QC status, implementation, validation,",
    "    data-assumption acceptance, or open questions change.",
    "  - When planned or used R packages affect reproducibility, script execution,",
    "    or method choice, record a concise package QC entry with package name,",
    "    role, CRAN status if checked, check performed, checked date, and notes.",
    "  - Because CRAN status and package versions can change, package QC entries",
    "    should include the date checked and should not be treated as current",
    "    unless rechecked for the active task.",
    "  - Store detailed `sessionInfo()`, package-version logs, and R console logs",
    "    under `log/`, `qc/`, or `r_output/` as appropriate; keep",
    "    `QC_STATUS.md` as the current-status summary with links to details.",
    "  - Use stable QC IDs such as `QC-001`.",
    "  - When QC-driven changes are reflected in scripts, record the QC ID, evidence,",
    "    implementation summary, validation result, and next action.",
    "",
    "## Workflow",
    "",
    "- Codex reads specifications and visible dummy data, then creates R scripts and",
    "  supporting files under `ai_output/`.",
    "- When applicable, Codex creates two versions of an R workflow:",
    "  - a dummy-data version that reads from `ai_visible_data/`;",
    paste0("  - an analysis-data version that reads from ", hidden_data_reference, "."),
    "- R scripts should use project-relative paths where possible.",
    "- When multiple data batches exist, scripts must not automatically assume that",
    "  the latest `addition_YYYYMMDD/` folder is approved for the current analysis.",
    "- Before using any `addition_YYYYMMDD/` folder, Codex must check",
    "  `QC_STATUS.md` to determine whether that addition is accepted into the",
    "  current analysis data assumption.",
    "- If the acceptance status is unclear, Codex should prepare code that can",
    "  include the addition, but should not treat it as the default analysis input",
    "  without user approval.",
    "- Even when creating analysis-data scripts, Codex must not inspect",
    paste0("  ", hidden_data_reference, "."),
    "- The user runs R scripts manually and places results under `r_output/`.",
    "- Codex must not run generated R scripts by default. If Codex believes an R",
    "  script should be run for debugging or validation, Codex must ask the user",
    "  for approval first.",
    "- Codex reviews `r_output/` for execution success, expected output files,",
    "  output structure, errors, warnings, unexpected values, and count mismatches.",
    "- QC evidence and QC decisions should be stored under `qc/` and tracked in",
    "  `QC_STATUS.md`.",
    "- Important decisions and investigation notes that affect later work may also be",
    "  recorded under `log/`.",
    "",
    "## Evidence and Assumption Separation",
    "",
    "- Separate facts written in source documents from candidate inferences,",
    "  unresolved issues, and implementation assumptions.",
    "- Do not silently assume treatment-group coding, endpoint-variable mapping,",
    "  analysis-set flags, visit coding, or missing-value coding.",
    "- When these items are unclear, write the uncertainty explicitly and ask for",
    "  clarification or prepare a draft that marks the assumption as unapproved.",
    "- Do not inspect hidden data without an explicit user instruction.",
    "",
    "## Agent Output Boundaries",
    "",
    "- Workflow agent deliverables belong under `ai_output/`.",
    "- QC agent deliverables belong under `qc/`.",
    "- The QC agent must not directly overwrite Workflow agent outputs.",
    "",
    "## R Script Generation Rules",
    "",
    "- If independent QC agent mode is enabled (`qc_agent = TRUE`), final R script",
    "  generation is allowed only after the Plan gate has been reviewed by the QC",
    "  agent and the QC agent records `APPROVE_NEXT_STEP` in",
    "  `qc/review/QC_DECISION.md`.",
    "- Codex-generated R scripts must be saved under `ai_output/`.",
    "- Codex must not create or modify R scripts under `scripts/` unless the user",
    "  explicitly requests it.",
    "- Codex should treat `ai_output/` as the normal location for generated",
    "  analysis scripts, helper scripts, READMEs, check notes, and validation",
    "  instructions.",
    "- Codex must not run generated R scripts by default. The normal workflow is:",
    "  Codex writes the script, the user runs it manually in R, and the user places",
    "  logs and outputs under `r_output/`.",
    "- Codex may inspect `r_output/` to check whether the script ran successfully,",
    "  whether expected files were created, whether output structures match the",
    "  script design, and whether errors, warnings, unexpected values, or count",
    "  mismatches occurred.",
    "- If Codex needs to run an R script for debugging or validation, Codex must",
    "  ask the user for approval first.",
    "- Generated R scripts must not assume that the current R working directory is",
    "  the project root. Interactive sessions, IDE run buttons, notebook chunks,",
    "  and line-by-line console execution may all start from different working",
    "  directories.",
    "- Generated R scripts should resolve input and output paths from an explicit",
    "  project root or from the script file location when that location is",
    "  available. If the project root cannot be determined, the script should stop",
    "  with a clear message telling the user how to set it explicitly.",
    "- Run notes for generated R scripts should include both a recommended",
    "  command-line execution pattern and an interactive-session fallback for",
    "  setting the project root explicitly. Keep these notes generic and avoid",
    "  embedding machine-specific absolute paths unless the user asks for them.",
    "- Avoid relying on bare relative paths for data inputs or outputs unless the",
    "  script first resolves the project root and constructs paths from that root.",
    "- If a script needs both a dummy-data version and an analysis-data version,",
    "  both versions should be generated under `ai_output/` with clear file names.",
    "- If variable creation requires fallback variables, proxy variables, handling",
    "  of missing source columns, interpretation of mismatches between the",
    "  specification and available data, or any domain/statistical judgment, Codex",
    "  must ask the user before treating that choice as final.",
    "- When Codex proposes a fallback or proxy implementation, it should document",
    "  the reason, source variables, affected output variables, and approval status",
    "  in a note under `ai_output/` or in `QC_STATUS.md` when QC tracking is being",
    "  used.",
    "",
    "## AI-Assisted QC",
    "",
    "- Codex may propose study-specific QC checkpoints based on the project context.",
    "- Proposed QC checkpoints should be recorded as candidates in `QC_STATUS.md`",
    "  unless the user asks for a lighter review.",
    "- Codex may assess risks, affected downstream tasks, and possible next actions.",
    "- Codex must distinguish AI risk assessment from user-approved QC decisions.",
    "- Codex must not mark human-judgment QC items as final without user approval.",
    "- If a QC item is critical, Codex may recommend blocking downstream work, but",
    "  the blocking decision should be confirmed by the user unless it is a purely",
    "  technical issue such as a missing file, execution error, or undefined object.",
    "",
    "## Human Approval",
    "",
    "- Codex must not independently decide to inspect production or hidden analysis",
    "  data.",
    "- Ask the user before making judgments that require human or domain approval,",
    "  including:",
    "  - statistical interpretation;",
    "  - inclusion or exclusion criteria;",
    "  - handling of missing values, outliers, or abnormal values;",
    "  - mismatches between specifications and data structure;",
    "  - acceptance of additional data batches into the current analysis assumption;",
    "  - any situation where the hidden analysis data would need to be inspected.",
    "- Inspecting, listing, moving, copying, summarizing, or otherwise using",
    paste0("  ", hidden_data_reference, " directly is prohibited."),
    "",
    "## Edit Boundaries",
    "",
    "- Codex-generated files should be created under `ai_output/` unless another",
    "  project rule or explicit user request says otherwise.",
    "- Do not edit existing source materials, visible data, R outputs, or QC source",
    "  materials unless the user explicitly asks for that specific change.",
    "- When QC evidence leads to script changes, record the basis and status in",
    "  `QC_STATUS.md`."
  )

  qc_agent_rule <- if (isTRUE(qc_agent)) {
    c(
      "",
      "## Independent QC Agent Plan Gate",
      "",
      "- Independent QC agent mode is enabled for this project.",
      "- The Workflow agent must not proceed to final R code generation until the",
      "  Plan gate has been reviewed by the QC agent and the QC agent records",
      "  `APPROVE_NEXT_STEP` in `qc/review/QC_DECISION.md`.",
      "- Before Plan gate approval, the Workflow agent may work on:",
      "  - context confirmation;",
      "  - M11SEMANTIC extraction;",
      "  - SAP or analysis-plan drafts;",
      "  - data requirements tables;",
      "  - endpoint map drafts;",
      "  - metadata inspection plans;",
      "  - pseudocode or algorithm explanations.",
      "- Before Plan gate approval, the Workflow agent must not create:",
      "  - final R analysis scripts;",
      "  - final endpoint derivation code;",
      "  - final analysis-set derivation code;",
      "  - final table or figure generation scripts;",
      "  - final statistical model implementations.",
      "- QC agent decisions must be one of `APPROVE_NEXT_STEP`,",
      "  `REQUEST_REVISION`, or `BLOCK`.",
      "- QC reviews must be saved under `qc/review/`, and decision records must",
      "  include Gate, Decision, Reviewer, Date, Approved scope, and Conditions or",
      "  blocking issues."
    )
  } else {
    c(
      "",
      "## Independent QC Agent Plan Gate",
      "",
      "- If independent QC agent mode is later added to this project, final R code",
      "  generation must wait until the QC agent records `APPROVE_NEXT_STEP` for",
      "  the Plan gate."
    )
  }

  sap_rule <- c(
    "",
    "## Statistical Analysis Plan and Analysis Decisions",
    "",
    "- Before substantive analysis script generation, review, validation,",
    "  interpretation, or QC work, Codex should check whether a Statistical",
    "  Analysis Plan or equivalent analysis specification is available under",
    "  `source/` or `ai_output/`.",
    "- If an SAP or equivalent analysis specification exists, Codex should use it",
    "  as the primary analysis-planning source. Codex must not overwrite, replace,",
    "  or rewrite the SAP unless the user explicitly asks for that change.",
    "- If no SAP or equivalent analysis specification exists, Codex should create",
    "  `ai_output/SAP.md` as a project-specific draft Statistical Analysis Plan",
    "  based on the available source materials, user instructions, visible data",
    "  structure, and the analysis context.",
    "- `ai_output/SAP.md` should not be a generic template. Codex should determine",
    "  the structure, headings, and level of detail from the project context.",
    "- If important information is unavailable, Codex should write explicit open",
    "  questions or uncertainty statements rather than silently filling in",
    "  assumptions.",
    "- When Codex makes analysis-planning judgments, interpretations, assumptions,",
    "  or proposed decisions that are not directly specified in the SAP, source",
    "  materials, or user instructions, Codex should record them in",
    "  `ai_output/SAP_DECISIONS.md`.",
    "- `SAP_DECISIONS.md` should distinguish source-specified decisions,",
    "  user-approved decisions, Codex interpretations, Codex proposals, and",
    "  unresolved questions.",
    "- Codex must not treat its own proposed SAP content, interpretations, or",
    "  analysis decisions as final user-approved decisions unless the user",
    "  explicitly approves them.",
    "- Codex must not revise planned analyses based on observed results in",
    "  `r_output/` unless the user explicitly requests or approves the change.",
    "  Such changes must be recorded as post hoc or revised decisions in",
    "  `SAP_DECISIONS.md`.",
    paste0("- Codex must not inspect ", hidden_data_reference, " to prepare, revise,"),
    "  or interpret SAP-related files.",
    "",
    "## Planned R Implementation in SAP",
    "",
    "- When drafting or revising an SAP or equivalent analysis specification,",
    "  Codex should include a section titled `Planned R implementation` when it",
    "  is useful for reproducibility, downstream code generation, validation, or",
    "  handoff to human analysts.",
    "- The `Planned R implementation` section should map each major planned",
    "  analysis to the expected R package and main R function or functions.",
    "- This section is implementation guidance. It must not be treated as a",
    "  substitute for the statistical method, estimand, endpoint definition,",
    "  analysis population, covariate specification, missing-data handling,",
    "  multiplicity strategy, or sensitivity analysis plan.",
    "- The SAP should make clear that the statistical method is the primary",
    "  analysis commitment. Specific R functions are planned or candidate",
    "  implementations unless the user, protocol, SAP, institution, or regulatory",
    "  requirement explicitly mandates them.",
    "- Use wording such as `planned`, `expected`, or `candidate` for R functions",
    "  unless the function choice is explicitly fixed.",
    "- For each major analysis, include the following columns when applicable:",
    "  - analysis item;",
    "  - endpoint or estimand, if useful for clarity;",
    "  - statistical method;",
    "  - planned R package;",
    "  - main R function or functions;",
    "  - purpose of use;",
    "  - validation notes, alternatives, or open questions.",
    "- Examples of appropriate entries include:",
    "  - Kaplan-Meier estimation: `survival::survfit()`;",
    "  - Cox proportional hazards model: `survival::coxph()`;",
    "  - logistic regression: `stats::glm(..., family = binomial)`;",
    "  - linear regression: `stats::lm()`;",
    "  - multiple imputation: `mice::mice()`, `mice::with()`, and `mice::pool()`;",
    "  - descriptive tables: `gtsummary::tbl_summary()` or",
    "    `tableone::CreateTableOne()`.",
    "- These examples are not a default analysis plan. Codex should choose entries",
    "  from the actual project context, SAP requirements, data structure, and user",
    "  instructions.",
    "- If a time-to-event, competing-risk, recurrent-event, longitudinal,",
    "  clustered-data, Bayesian, causal-inference, or other specialized method is",
    "  planned, Codex should identify the intended R implementation explicitly",
    "  rather than silently substituting a simpler familiar function.",
    "- If the appropriate R function is uncertain, Codex should write",
    "  `to be determined` and explain what information is needed to decide.",
    "- Codex must not choose or revise R functions based on observed analysis",
    "  results in `r_output/` unless the user explicitly approves a post hoc or",
    "  revised decision. Such changes must be recorded in `SAP_DECISIONS.md`.",
    paste0("- Codex must not inspect ", hidden_data_reference, " to decide which R"),
    "  functions should be listed in the SAP."
  )

  language_rule <- if (isTRUE(japanese)) {
    c(
      "",
      "## Output Language",
      "",
      "- Unless the user explicitly says otherwise, narrative output documents",
      "  generated by Codex should be written in Japanese.",
      "- This applies to READMEs, review notes, QC summaries, handoff notes, and",
      "  other prose documents.",
      "- This does not override formats or languages that are defined by the file",
      "  type, programming language, package convention, data schema, or explicit",
      "  user instruction.",
      "- R scripts, source code, machine-readable tables, column names, file names,",
      "  and externally specified terms should follow their required technical",
      "  conventions."
    )
  } else {
    c(
      "",
      "## Output Language",
      "",
      "- Unless the user explicitly says otherwise, narrative output documents",
      "  generated by Codex should be written in English.",
      "- This applies to READMEs, review notes, QC summaries, handoff notes, and",
      "  other prose documents.",
      "- This does not override formats or languages that are defined by the file",
      "  type, programming language, package convention, data schema, or explicit",
      "  user instruction.",
      "- R scripts, source code, machine-readable tables, column names, file names,",
      "  and externally specified terms should follow their required technical",
      "  conventions."
    )
  }

  c(base, qc_agent_rule, sap_rule, language_rule)
}

validate_japanese <- function(japanese) {
  validate_flag(japanese, "japanese")
  invisible(japanese)
}

output_language <- function(japanese = FALSE) {
  validate_japanese(japanese)
  if (isTRUE(japanese)) {
    "Japanese"
  } else {
    "English"
  }
}

output_language_rule <- function(japanese = FALSE) {
  validate_japanese(japanese)
  c(
    paste0("Default narrative output language: ", output_language(japanese), "."),
    "This language setting applies to prose documents generated by Codex, not to R scripts, source code, machine-readable data, fixed schemas, or explicitly specified terms."
  )
}

qc_status_template <- function() {
  c(
    "# QC_STATUS.md",
    "",
    "This file tracks QC items and their implementation status.",
    "",
    "## R Package QC",
    "",
    "Use this section to track R packages that are planned or used when they",
    "affect reproducibility, script execution, method choice, or downstream QC.",
    "Keep entries concise. Put detailed `sessionInfo()`, package-version logs,",
    "installation logs, and R console output under `log/`, `qc/`, or `r_output/`",
    "and link to them from the Notes column when useful.",
    "",
    "| Package | Role | Purpose | CRAN | Check performed | Checked on | Notes |",
    "|---|---|---|---|---|---|---|",
    "| cifmodeling | example planned | Competing-risk CIF visualization, for example `cifplot()` | Yes, example only | CRAN listing checked; availability/runtime not checked for this project | YYYY-MM-DD | Replace or remove this example before project-specific use. |",
    "",
    "`CRAN` and package availability can change. Record the actual check date for",
    "the active task, and use `Unknown` or `Not checked` when no check was done.",
    "",
    "## QC Items",
    "",
    "No QC items have been registered yet."
  )
}

workflow_agent_template <- function() {
  c(
    "# WORKFLOW_AGENT.md",
    "",
    "Role: prepare analysis context, planning outputs, and implementation drafts.",
    "",
    "## Output Boundary",
    "",
    "- Write Workflow agent deliverables under `ai_output/`.",
    "- Do not write QC agent review outputs.",
    "- Do not directly modify QC agent decisions.",
    "",
    "## Plan Gate Enforcement",
    "",
    "- Before final R code generation, check `qc/review/QC_DECISION.md`.",
    "- Do not proceed to final R code generation unless the QC agent decision for",
    "  the Plan gate is `APPROVE_NEXT_STEP`.",
    "",
    "## Allowed Before Plan Gate Approval",
    "",
    "- Context confirmation",
    "- M11SEMANTIC extraction",
    "- SAP or analysis-plan drafts",
    "- Data requirements table",
    "- Endpoint map draft",
    "- Metadata inspection plan",
    "- Pseudocode or algorithm explanation",
    "",
    "## Prohibited Before Plan Gate Approval",
    "",
    "- Final R analysis script creation",
    "- Final endpoint derivation code creation",
    "- Final analysis-set derivation code creation",
    "- Final table or figure generation script creation",
    "- Final statistical model implementation creation",
    "",
    "## Assumption Rules",
    "",
    "- Separate document facts, candidate inferences, unresolved issues, and",
    "  implementation assumptions.",
    "- Do not silently assume treatment-group coding, endpoint-variable mapping,",
    "  analysis-set flags, visit coding, or missing-value coding.",
    "- Do not inspect hidden data unless the user explicitly instructs it."
  )
}

qc_agent_template <- function() {
  c(
    "# QC_AGENT.md",
    "",
    "Role: independently review Workflow agent outputs and issue gate decisions.",
    "",
    "## Output Boundary",
    "",
    "- Write QC agent outputs under `qc/`.",
    "- Do not directly overwrite Workflow agent outputs under `ai_output/`.",
    "",
    "## Plan Gate Decision",
    "",
    "- Review the Workflow agent's Plan gate materials before final R code generation.",
    "- Issue exactly one of the following decisions:",
    "  - `APPROVE_NEXT_STEP`",
    "  - `REQUEST_REVISION`",
    "  - `BLOCK`",
    "- Save the review report to `qc/review/QC_REVIEW_REPORT.md`.",
    "- Save the decision to `qc/review/QC_DECISION.md`.",
    "",
    "## QC_DECISION.md Required Fields",
    "",
    "- Gate",
    "- Decision",
    "- Reviewer",
    "- Date",
    "- Approved scope",
    "- Conditions or blocking issues",
    "",
    "## Review Focus",
    "",
    "- Confirm that document facts, candidate inferences, unresolved issues, and",
    "  implementation assumptions are separated.",
    "- Check that treatment-group coding, endpoint-variable mapping, analysis-set",
    "  flags, visit coding, and missing-value coding are not silently assumed.",
    "- Confirm that hidden data were not inspected without explicit user instruction.",
    "- Confirm that final R code generation has not started before Plan gate approval."
  )
}

qc_review_report_template <- function() {
  c(
    "# QC_REVIEW_REPORT.md",
    "",
    "## Gate",
    "",
    "Plan gate",
    "",
    "## Reviewed Materials",
    "",
    "- Not yet reviewed.",
    "",
    "## Findings",
    "",
    "- Not yet reviewed.",
    "",
    "## Recommendation",
    "",
    "- Not yet reviewed."
  )
}

qc_decision_template <- function() {
  c(
    "# QC_DECISION.md",
    "",
    "Gate: Plan gate",
    "Decision: REQUEST_REVISION",
    "Reviewer: QC agent",
    "Date: YYYY-MM-DD",
    "Approved scope: Not approved yet.",
    "Conditions or blocking issues: Initial placeholder. Replace after QC review.",
    "",
    "Allowed decisions: APPROVE_NEXT_STEP, REQUEST_REVISION, BLOCK."
  )
}

qc_review_log_template <- function() {
  c(
    "# QC_REVIEW_LOG.md",
    "",
    "Use this log for concise QC review history and links to detailed review files.",
    "",
    "| Date | Gate | Decision | Review file | Notes |",
    "|---|---|---|---|---|"
  )
}

decision_log_template <- function() {
  c(
    "# DECISION_LOG.md",
    "",
    "Use this log for decisions that affect analysis planning, implementation,",
    "or workflow gating.",
    "",
    "| Date | Decision | Owner | Evidence or link | Notes |",
    "|---|---|---|---|---|"
  )
}

write_rds_if_allowed <- function(object, path, overwrite = FALSE) {
  if (file.exists(path) && !overwrite) return(FALSE)
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  saveRDS(object, path)
  TRUE
}

load_demo_prostate <- function() {
  env <- new.env(parent = emptyenv())

  loaded <- tryCatch(
    {
      utils::data("prostate", package = "airsetup", envir = env)
      exists("prostate", envir = env, inherits = FALSE)
    },
    error = function(e) FALSE
  )

  if (!loaded) {
    data_file <- system.file("data", "prostate.rda", package = "airsetup")
    if (!nzchar(data_file)) {
      data_file <- file.path("data", "prostate.rda")
    }
    if (!file.exists(data_file)) {
      stop("Could not find the bundled `prostate` demo data.", call. = FALSE)
    }

    load(data_file, envir = env)
  }

  if (!exists("prostate", envir = env, inherits = FALSE)) {
    stop("The bundled demo data did not contain an object named `prostate`.", call. = FALSE)
  }

  get("prostate", envir = env, inherits = FALSE)
}

load_demo_prostate_rd <- function() {
  rd <- tryCatch(
    tools::Rd_db(package = "airsetup")[["prostate.Rd"]],
    error = function(e) NULL
  )
  if (!is.null(rd)) return(rd)

  rd_file <- system.file("man", "prostate.Rd", package = "airsetup")
  if (!nzchar(rd_file)) {
    rd_file <- file.path("man", "prostate.Rd")
  }
  if (!file.exists(rd_file)) {
    stop("Could not find the bundled `prostate` documentation.", call. = FALSE)
  }

  tools::parse_Rd(rd_file)
}

write_demo_data_definition <- function(path, overwrite = FALSE) {
  if (file.exists(path) && !overwrite) return(FALSE)
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  tmp <- tempfile("airsetup-rd2txt-")
  on.exit(unlink(tmp), add = TRUE)
  tools::Rd2txt(load_demo_prostate_rd(), out = tmp)
  lines <- readLines(tmp, warn = FALSE)
  lines <- gsub(paste0(".", intToUtf8(8)), "", lines, perl = TRUE)
  writeLines(lines, path, useBytes = TRUE)
  TRUE
}

#' Set up an AI-assisted analysis project structure
#'
#' @param path Parent directory to create or update.
#' @param split Logical. If `TRUE`, create sibling `ai_project` and `r_project`
#'   folders. If `FALSE`, create only `ai_project`.
#' @param skills Logical. If `TRUE`, add QC skill templates under
#'   `ai_project/agent_control/`.
#' @param qc_agent Logical. If `TRUE`, add independent QC agent specifications
#'   and Plan gate review folders.
#' @param japanese Logical. If `TRUE`, generated `AGENTS.md` instructs Codex to
#'   write narrative output documents in Japanese by default. If `FALSE`, it
#'   instructs Codex to use English by default. This does not override scripts,
#'   source code, schemas, or explicit user instructions.
#' @param overwrite Logical. If `TRUE`, overwrite generated files that already
#'   exist.
#'
#' @return Invisibly returns the normalized parent path.
#'
#' @examples
#' project_dir <- file.path(tempdir(), "airsetup_example")
#'
#' airsetup(project_dir)
#' airsetup(project_dir, qc_agent = TRUE)
#' airsetup(project_dir, split = FALSE)
#' airsetup(project_dir, skills = FALSE)
#'
#' aircheck(project_dir)
#'
#' @export
airsetup <- function(path,
                     split = TRUE,
                     skills = TRUE,
                     qc_agent = FALSE,
                     japanese = FALSE,
                     overwrite = FALSE) {
  if (!is.character(path) || length(path) != 1L || !nzchar(path)) {
    stop("`path` must be a non-empty string.", call. = FALSE)
  }
  validate_flag(split, "split")
  validate_flag(skills, "skills")
  validate_flag(qc_agent, "qc_agent")
  validate_japanese(japanese)
  validate_flag(overwrite, "overwrite")

  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  create_ai_project_structure(
    file.path(path, "ai_project"),
    split = split,
    skills = skills,
    japanese = japanese,
    qc_agent = qc_agent,
    overwrite = overwrite
  )

  if (isTRUE(skills)) {
    airskill(path, overwrite = overwrite, quiet = TRUE)
  }

  if (isTRUE(split)) {
    create_r_project_scaffold(file.path(path, "r_project"), overwrite = overwrite)
  }

  invisible(normalizePath(path, winslash = "/", mustWork = TRUE))
}

#' Set up a demo AI-assisted analysis project
#'
#' `airsetup_demo()` is a beginner-friendly wrapper around [airsetup()]. It
#' creates the standard project structure, optionally adds QC skill templates
#' with [airskill()], and places bundled prostate cancer demo materials in the
#' initial data and source folders.
#'
#' @param path Parent directory to create or update.
#' @param japanese Logical. If `TRUE`, generated `AGENTS.md` instructs Codex to
#'   write narrative output documents in Japanese by default.
#' @param skills Logical. If `TRUE`, also run [airskill()] to add QC skill
#'   templates.
#' @param qc_agent Logical. If `TRUE`, add independent QC agent specifications
#'   and Plan gate review folders.
#' @param overwrite Logical. If `TRUE`, overwrite generated files and demo
#'   materials that already exist.
#'
#' @return A data frame with columns `file`, `path`, `status`, and
#'   `overwritten`.
#'
#' @examples
#' demo_dir <- file.path(tempdir(), "airsetup_demo_example")
#' airsetup_demo(demo_dir)
#' aircheck(demo_dir)
#'
#' @export
airsetup_demo <- function(path,
                          japanese = TRUE,
                          skills = TRUE,
                          qc_agent = FALSE,
                          overwrite = FALSE) {
  if (!is.character(path) || length(path) != 1L || !nzchar(path)) {
    stop("`path` must be a non-empty string.", call. = FALSE)
  }
  validate_japanese(japanese)
  validate_flag(skills, "skills")
  validate_flag(qc_agent, "qc_agent")
  validate_flag(overwrite, "overwrite")

  airsetup(
    path,
    split = TRUE,
    skills = FALSE,
    qc_agent = qc_agent,
    japanese = japanese,
    overwrite = overwrite
  )

  skill_report <- NULL
  if (isTRUE(skills)) {
    skill_report <- airskill(path, overwrite = overwrite, quiet = TRUE)
  }

  initial <- initial_dir_name()
  prostate <- load_demo_prostate()

  demo_files <- list(
    list(
      file = "demodata.rds",
      path = file.path("ai_project", "ai_visible_data", initial, "demodata.rds"),
      writer = function(out) write_rds_if_allowed(utils::head(prostate, 3L), out, overwrite = overwrite)
    ),
    list(
      file = "demodata.rds",
      path = file.path("r_project", "ai_hidden_data", initial, "demodata.rds"),
      writer = function(out) write_rds_if_allowed(prostate, out, overwrite = overwrite)
    ),
    list(
      file = "definition_demodata.txt",
      path = file.path("ai_project", "source", initial, "definition_demodata.txt"),
      writer = function(out) write_demo_data_definition(out, overwrite = overwrite)
    )
  )

  demo_report <- lapply(demo_files, function(spec) {
    out <- file.path(path, spec$path)
    existed <- file.exists(out)
    written <- spec$writer(out)

    data.frame(
      file = spec$file,
      path = spec$path,
      status = if (written && existed) {
        "overwritten"
      } else if (written) {
        "created"
      } else {
        "skipped"
      },
      overwritten = isTRUE(written && existed),
      stringsAsFactors = FALSE
    )
  })

  out <- do.call(rbind, demo_report)
  if (!is.null(skill_report)) {
    out <- rbind(skill_report, out)
  }

  rownames(out) <- NULL
  out
}

#' Create the AI-visible project folder
#'
#' @param path AI project directory.
#' @param japanese Logical. If `TRUE`, generated `AGENTS.md` instructs Codex to
#'   write narrative output documents in Japanese by default. If `FALSE`, it
#'   instructs Codex to use English by default.
#' @param split Logical. If `TRUE`, generated `AGENTS.md` describes the sibling
#'   `r_project` hidden-data area as part of the active scaffold.
#' @param skills Logical. If `TRUE`, generated `AGENTS.md` describes QC skill
#'   files under `agent_control/` as part of the active scaffold.
#' @param qc_agent Logical. If `TRUE`, create independent QC agent scaffolding.
#' @param overwrite Logical. If `TRUE`, overwrite generated files that already
#'   exist.
#'
#' @return Invisibly returns the normalized AI project path.
#' @noRd
create_ai_project_structure <- function(path,
                                        split = TRUE,
                                        skills = TRUE,
                                        japanese = FALSE,
                                        qc_agent = FALSE,
                                        overwrite = FALSE) {
  validate_flag(split, "split")
  validate_flag(skills, "skills")
  validate_japanese(japanese)
  validate_flag(qc_agent, "qc_agent")
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  for (dir in required_dirs()) {
    dir.create(file.path(path, dir), recursive = TRUE, showWarnings = FALSE)
  }

  create_ai_initial_dirs(path)

  create_agents_md(
    path,
    split = split,
    skills = skills,
    japanese = japanese,
    qc_agent = qc_agent,
    overwrite = overwrite
  )
  create_qc_status_md(path, overwrite = overwrite)
  create_agent_control_index(path, overwrite = overwrite)

  if (isTRUE(qc_agent)) {
    create_qc_agent_scaffold(path, overwrite = overwrite)
  }

  invisible(normalizePath(path, winslash = "/", mustWork = TRUE))
}

#' Create agent control index
#'
#' @param path AI project directory.
#' @param overwrite Logical. If `TRUE`, overwrite an existing index file.
#'
#' @return Invisibly returns the index path.
#' @noRd
create_agent_control_index <- function(path, overwrite = FALSE) {
  out <- file.path(path, "agent_control", "AGENT_CONTROL_INDEX.md")
  write_if_allowed(out, agent_control_index_template(), overwrite = overwrite)
  invisible(out)
}

#' Create the AI-hidden R execution scaffold
#'
#' @param path R project directory.
#' @param overwrite Logical. If `TRUE`, overwrite generated files that already
#'   exist.
#'
#' @return Invisibly returns the normalized R project path.
#' @noRd
create_r_project_scaffold <- function(path, overwrite = FALSE) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  initial <- initial_dir_name()

  for (dir in c("ai_hidden_data", file.path("ai_hidden_data", initial))) {
    dir.create(file.path(path, dir), recursive = TRUE, showWarnings = FALSE)
  }

  write_if_allowed(
    file.path(path, ".gitignore"),
    c(
      "ai_hidden_data/",
      "*.rds",
      "*.RData",
      "*.csv",
      "*.tsv",
      "*.xlsx",
      "*.sas7bdat"
    ),
    overwrite = overwrite
  )

  write_if_allowed(
    file.path(path, "README_DO_NOT_SHARE_WITH_AI.md"),
    c(
      "# Do not share this folder with AI",
      "",
      "This folder is intended for local human execution only.",
      "It may contain real or analysis data.",
      "Codex and other AI agents must not inspect this folder or its contents.",
      "",
      "The expected analysis data folder is:",
      "",
      "- `ai_hidden_data/`",
      "- `ai_hidden_data/initial_YYYYMMDD/`",
      "- `ai_hidden_data/addition_YYYYMMDD/` for later additions",
      "",
      "AI-generated scripts should generally live in `../ai_project/ai_output/`.",
      "User-run R outputs should generally be written to `../ai_project/r_output/`."
    ),
    overwrite = overwrite
  )

  invisible(normalizePath(path, winslash = "/", mustWork = TRUE))
}

#' Create independent QC agent scaffold
#'
#' @param path AI project directory.
#' @param overwrite Logical. If `TRUE`, overwrite generated files that already
#'   exist.
#'
#' @return Invisibly returns the normalized AI project path.
#' @noRd
create_qc_agent_scaffold <- function(path, overwrite = FALSE) {
  for (dir in c("agent_control", file.path("qc", "review"))) {
    dir.create(file.path(path, dir), recursive = TRUE, showWarnings = FALSE)
  }

  write_if_allowed(
    file.path(path, "agent_control", "WORKFLOW_AGENT.md"),
    workflow_agent_template(),
    overwrite = overwrite
  )
  write_if_allowed(
    file.path(path, "agent_control", "QC_AGENT.md"),
    qc_agent_template(),
    overwrite = overwrite
  )
  write_if_allowed(
    file.path(path, "qc", "review", "QC_REVIEW_REPORT.md"),
    qc_review_report_template(),
    overwrite = overwrite
  )
  write_if_allowed(
    file.path(path, "qc", "review", "QC_DECISION.md"),
    qc_decision_template(),
    overwrite = overwrite
  )
  write_if_allowed(
    file.path(path, "log", "QC_REVIEW_LOG.md"),
    qc_review_log_template(),
    overwrite = overwrite
  )
  write_if_allowed(
    file.path(path, "log", "DECISION_LOG.md"),
    decision_log_template(),
    overwrite = overwrite
  )

  invisible(normalizePath(path, winslash = "/", mustWork = TRUE))
}

#' Create project AGENTS.md instructions
#'
#' @param path Project directory.
#' @param japanese Logical. If `TRUE`, generated `AGENTS.md` instructs Codex to
#'   write narrative output documents in Japanese by default. If `FALSE`, it
#'   instructs Codex to use English by default.
#' @param qc_agent Logical. If `TRUE`, generated `AGENTS.md` includes active
#'   independent QC agent Plan gate rules.
#' @param split Logical. If `TRUE`, generated `AGENTS.md` describes the sibling
#'   `r_project` hidden-data area as part of the active scaffold.
#' @param skills Logical. If `TRUE`, generated `AGENTS.md` describes QC skill
#'   files under `agent_control/` as part of the active scaffold.
#' @param overwrite Logical. If `TRUE`, overwrite an existing `AGENTS.md`.
#'
#' @return Invisibly returns the `AGENTS.md` path.
#' @noRd
create_agents_md <- function(path,
                             japanese = FALSE,
                             qc_agent = FALSE,
                             split = TRUE,
                             skills = TRUE,
                             overwrite = FALSE) {
  validate_japanese(japanese)
  validate_flag(qc_agent, "qc_agent")
  validate_flag(split, "split")
  validate_flag(skills, "skills")
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  out <- file.path(path, "AGENTS.md")
  write_if_allowed(
    out,
    agents_md_template(
      japanese = japanese,
      qc_agent = qc_agent,
      split = split,
      skills = skills
    ),
    overwrite = overwrite
  )
  invisible(out)
}

#' Create project QC_STATUS.md
#'
#' @param path Project directory.
#' @param overwrite Logical. If `TRUE`, overwrite an existing `QC_STATUS.md`.
#'
#' @return Invisibly returns the `QC_STATUS.md` path.
#' @noRd
create_qc_status_md <- function(path, overwrite = FALSE) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  out <- file.path(path, "QC_STATUS.md")
  write_if_allowed(out, qc_status_template(), overwrite = overwrite)
  invisible(out)
}

#' Check an airsetup project structure
#'
#' @param path Parent project directory to check.
#' @param split Logical. If `TRUE`, check the sibling `r_project` scaffold.
#' @param skills Logical. If `TRUE`, check QC skill templates under
#'   `ai_project/agent_control/`.
#' @param qc_agent Logical. If `TRUE`, check independent QC agent scaffolding.
#'
#' @return A data.frame with columns `item`, `type`, `path`, `exists`,
#'   `required`, and `message`.
#'
#' @examples
#' project_dir <- file.path(tempdir(), "aircheck_example")
#' airsetup(project_dir)
#' aircheck(project_dir)
#'
#' @export
aircheck <- function(path, split = TRUE, skills = TRUE, qc_agent = FALSE) {
  if (!is.character(path) || length(path) != 1L || !nzchar(path)) {
    stop("`path` must be a non-empty string.", call. = FALSE)
  }

  validate_flag(split, "split")
  validate_flag(skills, "skills")
  validate_flag(qc_agent, "qc_agent")

  ai_items <- file.path("ai_project", c(required_dirs(), required_files()))
  ai_types <- c(rep("folder", length(required_dirs())), rep("file", length(required_files())))

  items <- ai_items
  types <- ai_types

  full <- file.path(path, items)
  exists <- ifelse(types == "folder", dir.exists(full), file.exists(full))

  out <- data.frame(
    item = items,
    type = types,
    path = items,
    exists = exists,
    required = TRUE,
    message = ifelse(exists, "Found", "Missing required item"),
    stringsAsFactors = FALSE
  )

  ai_initial_checks <- data.frame(
    item = c(
      "ai_project/source/initial_YYYYMMDD",
      "ai_project/ai_visible_data/initial_YYYYMMDD"
    ),
    type = c("folder", "folder"),
    path = c(
      "ai_project/source/initial_YYYYMMDD",
      "ai_project/ai_visible_data/initial_YYYYMMDD"
    ),
    exists = c(
      has_dated_initial_dir(file.path(path, "ai_project"), "source"),
      has_dated_initial_dir(file.path(path, "ai_project"), "ai_visible_data")
    ),
    required = c(TRUE, TRUE),
    stringsAsFactors = FALSE
  )

  ai_initial_checks$message <- ifelse(
    ai_initial_checks$exists,
    "Found dated initial folder",
    "Missing required dated initial folder"
  )

  out <- rbind(out, ai_initial_checks)

  agent_control_index <- file.path("ai_project", "agent_control", "AGENT_CONTROL_INDEX.md")
  agent_control_index_out <- data.frame(
    item = agent_control_index,
    type = "file",
    path = agent_control_index,
    exists = file.exists(file.path(path, agent_control_index)),
    required = TRUE,
    stringsAsFactors = FALSE
  )
  agent_control_index_out$message <- ifelse(
    agent_control_index_out$exists,
    "Found",
    "Missing required item"
  )
  out <- rbind(out, agent_control_index_out)

  if (isTRUE(skills)) {
    skill_items <- file.path(
      "ai_project",
      "agent_control",
      c(
        "QC_SKILL_CONTEXT.md",
        "QC_SKILL_PLAN.md",
        "QC_SKILL_RESULT.md",
        "QC_SKILL_M11SEMANTIC.md"
      )
    )
    skill_out <- data.frame(
      item = skill_items,
      type = rep("file", length(skill_items)),
      path = skill_items,
      exists = file.exists(file.path(path, skill_items)),
      required = TRUE,
      stringsAsFactors = FALSE
    )
    skill_out$message <- ifelse(skill_out$exists, "Found", "Missing required item")
    out <- rbind(out, skill_out)
  }

  if (isTRUE(split)) {
    r_items <- file.path(
      "r_project",
      c(
        "ai_hidden_data",
        ".gitignore",
        "README_DO_NOT_SHARE_WITH_AI.md"
      )
    )
    r_types <- c("folder", "file", "file")

    r_full <- file.path(path, r_items)
    r_exists <- ifelse(r_types == "folder", dir.exists(r_full), file.exists(r_full))

    r_out <- data.frame(
      item = r_items,
      type = r_types,
      path = r_items,
      exists = r_exists,
      required = TRUE,
      message = ifelse(r_exists, "Found", "Missing required item"),
      stringsAsFactors = FALSE
    )

    r_initial_checks <- data.frame(
      item = c(
        "r_project/ai_hidden_data",
        "r_project/ai_hidden_data/initial_YYYYMMDD"
      ),
      type = c("folder", "folder"),
      path = c(
        "r_project/ai_hidden_data",
        "r_project/ai_hidden_data/initial_YYYYMMDD"
      ),
      exists = c(
        dir.exists(file.path(path, "r_project", "ai_hidden_data")),
        has_dated_initial_dir(file.path(path, "r_project"), "ai_hidden_data")
      ),
      required = c(TRUE, TRUE),
      stringsAsFactors = FALSE
    )

    r_initial_checks$message <- ifelse(
      r_initial_checks$exists,
      "Found",
      "Missing required item"
    )

    out <- rbind(out, r_out, r_initial_checks)
  }

  if (isTRUE(qc_agent)) {
    qc_agent_items <- file.path(
      "ai_project",
      c(
        file.path("agent_control", "WORKFLOW_AGENT.md"),
        file.path("agent_control", "QC_AGENT.md"),
        file.path("qc", "review"),
        file.path("qc", "review", "QC_REVIEW_REPORT.md"),
        file.path("qc", "review", "QC_DECISION.md"),
        file.path("log", "QC_REVIEW_LOG.md"),
        file.path("log", "DECISION_LOG.md")
      )
    )
    qc_agent_types <- c(
      "file",
      "file",
      "folder",
      "file",
      "file",
      "file",
      "file"
    )
    qc_agent_full <- file.path(path, qc_agent_items)
    qc_agent_exists <- ifelse(qc_agent_types == "folder", dir.exists(qc_agent_full), file.exists(qc_agent_full))
    qc_agent_out <- data.frame(
      item = qc_agent_items,
      type = qc_agent_types,
      path = qc_agent_items,
      exists = qc_agent_exists,
      required = TRUE,
      stringsAsFactors = FALSE
    )
    qc_agent_out$message <- ifelse(qc_agent_out$exists, "Found", "Missing required item")
    out <- rbind(out, qc_agent_out)
  }

  rownames(out) <- NULL
  out
}
