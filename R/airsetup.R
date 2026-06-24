#' airsetup: project setup for AI-assisted R workflows
#'
#' Lightweight project scaffolding for AI-assisted R analysis workflows.
#'
#' @keywords internal
"_PACKAGE"

required_dirs <- function() {
  c(
    "source",
    "source/initial",
    "ai_visible_data",
    "ai_visible_data/initial",
    "ai_output",
    "r_output",
    "qc",
    "log"
  )
}

required_files <- function() {
  c("AGENTS.md", "QC_STATUS.md")
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
    "  - Initial materials should be placed under `source/initial/`.",
    "  - Additional materials should be placed under `source/addition_YYYYMMDD/`.",
    "  - Treat this folder as read-only. Codex must not overwrite, move, or delete",
    "    source materials.",
    "",
    "- `ai_visible_data/`",
    "  - Stores dummy or visible data that Codex is allowed to inspect.",
    "  - Initial visible data should be placed under `ai_visible_data/initial/`.",
    "  - Additional visible data should be placed under",
    "    `ai_visible_data/addition_YYYYMMDD/`.",
    "  - Treat this folder as read-only. Codex may use it for column inspection,",
    "    script design, and dummy-data execution.",
    "  - This folder is append-only. Later additions do not replace earlier files.",
    "",
    "- `../r_project/ai_hidden_data/`",
    "  - Stores analysis data that Codex must not inspect directly.",
    "  - It is assumed to follow the same folder convention as visible data:",
    "    `initial/` for initial data and `addition_YYYYMMDD/` for additions.",
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
    "- Codex reviews `r_output/` for execution success, expected output files,",
    "  output structure, errors, warnings, unexpected values, and count mismatches.",
    "- QC evidence and QC decisions should be stored under `qc/` and tracked in",
    "  `QC_STATUS.md`.",
    "- Important decisions and investigation notes that affect later work may also be",
    "  recorded under `log/`.",
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

  c(base, language_rule)
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
create_r_project_scaffold <- function(path, overwrite = FALSE) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  for (dir in c("ai_hidden_data", "ai_hidden_data/initial")) {
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
      "- `ai_hidden_data/initial/`",
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

  if (identical(mode, "split")) {
    r_dirs <- file.path("r_project", c("ai_hidden_data", "ai_hidden_data/initial"))
    r_files <- file.path("r_project", c(".gitignore", "README_DO_NOT_SHARE_WITH_AI.md"))
    items <- c(items, r_dirs, r_files)
    types <- c(types, rep("folder", length(r_dirs)), rep("file", length(r_files)))
  }

  full <- file.path(path, items)
  exists <- ifelse(types == "folder", dir.exists(full), file.exists(full))

  data.frame(
    item = items,
    type = types,
    path = items,
    exists = exists,
    required = TRUE,
    message = ifelse(exists, "Found", "Missing required item"),
    stringsAsFactors = FALSE
  )
}
