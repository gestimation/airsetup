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
    "log"
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

agents_md_template <- function(japanese = FALSE) {
  if (!is.logical(japanese) || length(japanese) != 1L || is.na(japanese)) {
    stop("`japanese` must be TRUE or FALSE.", call. = FALSE)
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
    "  - Treat this folder as read-only. Codex must not overwrite, move, or delete",
    "    source materials.",
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
    "- `../r_project/ai_hidden_data/`",
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
    "  - an analysis-data version that reads from `../r_project/ai_hidden_data/`.",
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
    "  `../r_project/ai_hidden_data/`.",
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
    "## R Script Generation Rules",
    "",
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
    "  `../r_project/ai_hidden_data/` directly is prohibited.",
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
    "- Codex must not inspect `../r_project/ai_hidden_data/` to prepare, revise,",
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
    "- Codex must not inspect `../r_project/ai_hidden_data/` to decide which R",
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

  c(base, sap_rule, language_rule)
}

validate_japanese <- function(japanese) {
  if (!is.logical(japanese) || length(japanese) != 1L || is.na(japanese)) {
    stop("`japanese` must be TRUE or FALSE.", call. = FALSE)
  }
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
    "No QC items have been registered yet."
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
#' @param mode Project layout mode. `"split"` creates sibling `ai_project` and
#'   `r_project` folders. `"ai_only"` creates only `ai_project`.
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
#' airsetup(
#'   path = project_dir,
#'   mode = "split",
#'   japanese = FALSE,
#'   overwrite = FALSE
#' )
#'
#' aircheck(project_dir, mode = "split")
#'
#' ai_only_dir <- file.path(tempdir(), "airsetup_ai_only_example")
#' airsetup(ai_only_dir, mode = "ai_only", japanese = TRUE)
#' aircheck(ai_only_dir, mode = "ai_only")
#'
#' @export
airsetup <- function(path, mode = c("split", "ai_only"), japanese = FALSE, overwrite = FALSE) {
  if (!is.character(path) || length(path) != 1L || !nzchar(path)) {
    stop("`path` must be a non-empty string.", call. = FALSE)
  }
  mode <- match.arg(mode)
  validate_japanese(japanese)

  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  create_ai_project_structure(
    file.path(path, "ai_project"),
    japanese = japanese,
    overwrite = overwrite
  )

  if (identical(mode, "split")) {
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
airsetup_demo <- function(path, japanese = TRUE, skills = TRUE, overwrite = FALSE) {
  if (!is.character(path) || length(path) != 1L || !nzchar(path)) {
    stop("`path` must be a non-empty string.", call. = FALSE)
  }
  validate_japanese(japanese)
  if (!is.logical(skills) || length(skills) != 1L || is.na(skills)) {
    stop("`skills` must be TRUE or FALSE.", call. = FALSE)
  }
  if (!is.logical(overwrite) || length(overwrite) != 1L || is.na(overwrite)) {
    stop("`overwrite` must be TRUE or FALSE.", call. = FALSE)
  }

  airsetup(path, mode = "split", japanese = japanese, overwrite = overwrite)

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
      file = "data_definition_demodata.txt",
      path = file.path("ai_project", "source", initial, "data_definition_demodata.txt"),
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
#' @param overwrite Logical. If `TRUE`, overwrite generated files that already
#'   exist.
#'
#' @return Invisibly returns the normalized AI project path.
#' @noRd
create_ai_project_structure <- function(path, japanese = FALSE, overwrite = FALSE) {
  validate_japanese(japanese)
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  for (dir in required_dirs()) {
    dir.create(file.path(path, dir), recursive = TRUE, showWarnings = FALSE)
  }

  create_ai_initial_dirs(path)

  create_agents_md(path, japanese = japanese, overwrite = overwrite)
  create_qc_status_md(path, overwrite = overwrite)

  invisible(normalizePath(path, winslash = "/", mustWork = TRUE))
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

#' Create project AGENTS.md instructions
#'
#' @param path Project directory.
#' @param japanese Logical. If `TRUE`, generated `AGENTS.md` instructs Codex to
#'   write narrative output documents in Japanese by default. If `FALSE`, it
#'   instructs Codex to use English by default.
#' @param overwrite Logical. If `TRUE`, overwrite an existing `AGENTS.md`.
#'
#' @return Invisibly returns the `AGENTS.md` path.
#' @noRd
create_agents_md <- function(path, japanese = FALSE, overwrite = FALSE) {
  validate_japanese(japanese)
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  out <- file.path(path, "AGENTS.md")
  write_if_allowed(out, agents_md_template(japanese = japanese), overwrite = overwrite)
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
#' @param mode Project layout mode to check. `"split"` checks sibling
#'   `ai_project` and `r_project` folders. `"ai_only"` checks only
#'   `ai_project`.
#'
#' @return A data.frame with columns `item`, `type`, `path`, `exists`,
#'   `required`, and `message`.
#'
#' @examples
#' project_dir <- file.path(tempdir(), "aircheck_example")
#' airsetup(project_dir, mode = "split")
#' aircheck(project_dir, mode = "split")
#'
#' @export
aircheck <- function(path, mode = c("split", "ai_only")) {
  if (!is.character(path) || length(path) != 1L || !nzchar(path)) {
    stop("`path` must be a non-empty string.", call. = FALSE)
  }

  mode <- match.arg(mode)

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

  if (identical(mode, "split")) {
    r_items <- file.path("r_project", c(".gitignore", "README_DO_NOT_SHARE_WITH_AI.md"))
    r_types <- rep("file", length(r_items))

    r_full <- file.path(path, r_items)
    r_exists <- file.exists(r_full)

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

  rownames(out) <- NULL
  out
}
