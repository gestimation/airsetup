expect_one_dated_initial_dir <- function(parent) {
  dirs <- list.dirs(parent, full.names = FALSE, recursive = FALSE)
  matched <- dirs[grepl("^initial_[0-9]{8}$", dirs)]

  expect_length(matched, 1L)
  expect_true(dir.exists(file.path(parent, matched)))

  invisible(matched)
}

expect_airsetup_default_structure <- function(path) {
  expected_ai_dirs <- file.path(
    path,
    "ai_project",
    c(
      "source",
      "ai_visible_data",
      "ai_output",
      "r_output",
      "qc",
      "log",
      "agent_control"
    )
  )
  expect_true(all(dir.exists(expected_ai_dirs)))

  expect_one_dated_initial_dir(file.path(path, "ai_project", "source"))
  expect_one_dated_initial_dir(file.path(path, "ai_project", "ai_visible_data"))

  expect_true(file.exists(file.path(path, "ai_project", "AGENTS.md")))
  expect_true(file.exists(file.path(path, "ai_project", "QC_STATUS.md")))

  agent_control_dir <- file.path(path, "ai_project", "agent_control")
  expect_true(dir.exists(agent_control_dir))
  expect_true(file.exists(file.path(agent_control_dir, "AGENT_CONTROL_INDEX.md")))
  expect_true(file.exists(file.path(agent_control_dir, "QC_SKILL_CONTEXT.md")))
  expect_true(file.exists(file.path(agent_control_dir, "QC_SKILL_M11SEMANTIC.md")))
  expect_true(file.exists(file.path(agent_control_dir, "QC_SKILL_PLAN.md")))
  expect_true(file.exists(file.path(agent_control_dir, "QC_SKILL_SAP.md")))
  expect_true(file.exists(file.path(agent_control_dir, "QC_SKILL_RESULT.md")))
  expect_false(dir.exists(file.path(path, "ai_project", "skills")))
}

test_that("default airsetup creates split project with skills but no independent QC agent", {
  path <- tempfile("airsetup-")
  airsetup(path)

  expect_true(dir.exists(file.path(path, "ai_project")))
  expect_true(dir.exists(file.path(path, "r_project")))
  expect_airsetup_default_structure(path)

  expect_true(dir.exists(file.path(path, "r_project", "ai_hidden_data")))
  expect_one_dated_initial_dir(file.path(path, "r_project", "ai_hidden_data"))
  expect_false(dir.exists(file.path(path, "r_project", "r_scripts")))
  expect_false(dir.exists(file.path(path, "r_project", "r_output")))
  expect_true(file.exists(file.path(path, "r_project", ".gitignore")))
  expect_true(file.exists(file.path(path, "r_project", "README_DO_NOT_SHARE_WITH_AI.md")))

  expect_false(dir.exists(file.path(path, "ai_project", "agent_specs")))
  expect_false(dir.exists(file.path(path, "ai_project", "qc", "review")))
  expect_false(file.exists(file.path(path, "ai_project", "log", "QC_REVIEW_LOG.md")))

  expect_false(dir.exists(file.path(path, "ai_project", "source", "initial")))
  expect_false(dir.exists(file.path(path, "ai_project", "ai_visible_data", "initial")))
  expect_false(dir.exists(file.path(path, "r_project", "ai_hidden_data", "initial")))
})

test_that("split FALSE creates ai_project but not r_project", {
  path <- tempfile("airsetup-")
  airsetup(path, split = FALSE)

  expect_true(dir.exists(file.path(path, "ai_project")))
  expect_false(dir.exists(file.path(path, "r_project")))
  expect_airsetup_default_structure(path)
})

test_that("skills FALSE does not create skills folder", {
  path <- tempfile("airsetup-")
  airsetup(path, skills = FALSE)

  expect_true(dir.exists(file.path(path, "ai_project")))
  expect_true(dir.exists(file.path(path, "r_project")))
  expect_true(dir.exists(file.path(path, "ai_project", "agent_control")))
  expect_true(file.exists(file.path(path, "ai_project", "agent_control", "AGENT_CONTROL_INDEX.md")))
  expect_false(file.exists(file.path(path, "ai_project", "agent_control", "QC_SKILL_CONTEXT.md")))
  expect_false(dir.exists(file.path(path, "ai_project", "skills")))
  expect_false(dir.exists(file.path(path, "ai_project", "source", "skills")))
})

test_that("qc_agent TRUE creates independent QC agent scaffold and gate rules", {
  path <- tempfile("airsetup-")
  airsetup(path, qc_agent = TRUE)

  expect_false(dir.exists(file.path(path, "ai_project", "agent_specs")))
  expect_true(file.exists(file.path(path, "ai_project", "agent_control", "WORKFLOW_AGENT.md")))
  expect_true(file.exists(file.path(path, "ai_project", "agent_control", "QC_AGENT.md")))
  expect_true(dir.exists(file.path(path, "ai_project", "qc", "review")))
  expect_true(file.exists(file.path(path, "ai_project", "qc", "review", "QC_REVIEW_REPORT.md")))
  expect_true(file.exists(file.path(path, "ai_project", "qc", "review", "QC_DECISION.md")))
  expect_true(file.exists(file.path(path, "ai_project", "log", "QC_REVIEW_LOG.md")))
  expect_true(file.exists(file.path(path, "ai_project", "log", "DECISION_LOG.md")))

  agents <- paste(readLines(file.path(path, "ai_project", "AGENTS.md"), warn = FALSE), collapse = "\n")
  workflow <- paste(readLines(file.path(path, "ai_project", "agent_control", "WORKFLOW_AGENT.md"), warn = FALSE), collapse = "\n")
  qc_agent <- paste(readLines(file.path(path, "ai_project", "agent_control", "QC_AGENT.md"), warn = FALSE), collapse = "\n")
  decision <- paste(readLines(file.path(path, "ai_project", "qc", "review", "QC_DECISION.md"), warn = FALSE), collapse = "\n")

  expect_match(agents, "APPROVE_NEXT_STEP", fixed = TRUE)
  expect_match(agents, "final R code generation", fixed = TRUE)
  expect_match(workflow, "Do not proceed to final R code generation", fixed = TRUE)
  expect_match(workflow, "qc/review/QC_DECISION.md", fixed = TRUE)
  expect_false(grepl("ai_project/qc/review/QC_DECISION.md", workflow, fixed = TRUE))
  expect_match(workflow, "ai_output/", fixed = TRUE)
  expect_false(grepl("ai_project/ai_output/", workflow, fixed = TRUE))
  expect_match(qc_agent, "REQUEST_REVISION", fixed = TRUE)
  expect_match(qc_agent, "Do not directly overwrite Workflow agent outputs", fixed = TRUE)
  expect_match(qc_agent, "qc/review/QC_REVIEW_REPORT.md", fixed = TRUE)
  expect_match(qc_agent, "qc/review/QC_DECISION.md", fixed = TRUE)
  expect_false(grepl("ai_project/qc/", qc_agent, fixed = TRUE))
  expect_false(grepl("ai_project/ai_output/", qc_agent, fixed = TRUE))
  expect_match(decision, "Gate: Plan gate", fixed = TRUE)
  expect_match(decision, "Decision: REQUEST_REVISION", fixed = TRUE)
  expect_match(decision, "Approved scope:", fixed = TRUE)
  expect_match(decision, "Conditions or blocking issues:", fixed = TRUE)
})

test_that("airsetup_demo creates project, optional QC agent, skills, and bundled demo materials", {
  path <- tempfile("airsetup-demo-")
  report <- airsetup_demo(path, qc_agent = TRUE)

  expect_s3_class(report, "data.frame")
  expect_true(all(c("file", "path", "status", "overwritten") %in% names(report)))
  expect_true(any(report$file == "QC_SKILL_CONTEXT.md"))
  expect_true(any(report$file == "demodata.rds"))
  expect_true(any(report$file == "definition_demodata.txt"))

  initial <- initial_dir_name()
  visible_data <- file.path(path, "ai_project", "ai_visible_data", initial, "demodata.rds")
  hidden_data <- file.path(path, "r_project", "ai_hidden_data", initial, "demodata.rds")
  definition <- file.path(path, "ai_project", "source", initial, "definition_demodata.txt")

  expect_true(file.exists(visible_data))
  expect_true(file.exists(hidden_data))
  expect_true(file.exists(definition))
  expect_true(file.exists(file.path(path, "ai_project", "agent_control", "QC_AGENT.md")))

  expect_equal(nrow(readRDS(visible_data)), 3L)
  expect_equal(nrow(readRDS(hidden_data)), 502L)

  definition_text <- paste(readLines(definition, warn = FALSE), collapse = "\n")
  expect_match(definition_text, "prostate cancer trial", fixed = TRUE)
  expect_match(definition_text, "dtime", fixed = TRUE)
  expect_match(definition_text, "status", fixed = TRUE)

  agents <- paste(readLines(file.path(path, "ai_project", "AGENTS.md"), warn = FALSE), collapse = "\n")
  expect_match(agents, "generated by Codex should be written in Japanese", fixed = TRUE)
})

test_that("airsetup_demo can skip skills and preserves demo materials by default", {
  path <- tempfile("airsetup-demo-")
  airsetup_demo(path, skills = FALSE)

  initial <- initial_dir_name()
  visible_data <- file.path(path, "ai_project", "ai_visible_data", initial, "demodata.rds")
  saveRDS(data.frame(custom = 1), visible_data)

  report <- airsetup_demo(path, skills = FALSE, overwrite = FALSE)

  expect_false(any(report$file == "QC_SKILL_CONTEXT.md"))
  expect_true(dir.exists(file.path(path, "ai_project", "agent_control")))
  expect_true(file.exists(file.path(path, "ai_project", "agent_control", "AGENT_CONTROL_INDEX.md")))
  expect_false(file.exists(file.path(path, "ai_project", "agent_control", "QC_SKILL_CONTEXT.md")))
  expect_false(dir.exists(file.path(path, "ai_project", "skills")))
  expect_false(dir.exists(file.path(path, "ai_project", "source", "skills")))
  expect_true(any(report$path == file.path("ai_project", "ai_visible_data", initial, "demodata.rds") & report$status == "skipped"))
  expect_equal(names(readRDS(visible_data)), "custom")

  overwritten <- airsetup_demo(path, skills = FALSE, overwrite = TRUE)
  expect_true(any(overwritten$path == file.path("ai_project", "ai_visible_data", initial, "demodata.rds") & overwritten$status == "overwritten"))
  expect_equal(nrow(readRDS(visible_data)), 3L)
})

test_that("overwrite behavior preserves existing files by default", {
  path <- tempfile("airsetup-")
  airsetup(path, split = FALSE, skills = FALSE, qc_agent = TRUE)

  agents <- file.path(path, "ai_project", "AGENTS.md")
  qc_status <- file.path(path, "ai_project", "QC_STATUS.md")
  decision <- file.path(path, "ai_project", "qc", "review", "QC_DECISION.md")

  writeLines("custom agents", agents)
  writeLines("custom qc", qc_status)
  writeLines("custom decision", decision)

  airsetup(path, split = FALSE, skills = FALSE, qc_agent = TRUE, overwrite = FALSE)
  expect_equal(readLines(agents, warn = FALSE), "custom agents")
  expect_equal(readLines(qc_status, warn = FALSE), "custom qc")
  expect_equal(readLines(decision, warn = FALSE), "custom decision")

  airsetup(path, split = FALSE, skills = FALSE, qc_agent = TRUE, japanese = TRUE, overwrite = TRUE)
  expect_identical(
    readLines(agents, warn = FALSE),
    agents_md_template(japanese = TRUE, qc_agent = TRUE, split = FALSE, skills = FALSE)
  )
  expect_identical(readLines(qc_status, warn = FALSE), qc_status_template())
  expect_identical(readLines(decision, warn = FALSE), qc_decision_template())
})

test_that("AGENTS.md records shared rules and English output language by default", {
  path <- tempfile("airsetup-")
  airsetup(path, split = FALSE, skills = FALSE)

  agents <- readLines(file.path(path, "ai_project", "AGENTS.md"), warn = FALSE)
  text <- paste(agents, collapse = "\n")

  expect_identical(
    agents,
    agents_md_template(japanese = FALSE, qc_agent = FALSE, split = FALSE, skills = FALSE)
  )
  expect_match(text, "## Project Map", fixed = TRUE)
  expect_match(text, "`source/initial_YYYYMMDD/`", fixed = TRUE)
  expect_match(text, "`ai_visible_data/initial_YYYYMMDD/`", fixed = TRUE)
  expect_match(text, "`../r_project/ai_hidden_data/`, when split project structure is used", fixed = TRUE)
  expect_match(text, "`ai_output/`", fixed = TRUE)
  expect_match(text, "`r_output/`", fixed = TRUE)
  expect_match(text, "`agent_control/`", fixed = TRUE)
  expect_match(text, "Detailed agent role definitions and QC skill instructions are stored here.", fixed = TRUE)
  expect_match(text, "`QC_SKILL_*.md` files are created here when `skills = TRUE`.", fixed = TRUE)
  expect_match(text, "Separate facts written in source documents", fixed = TRUE)
  expect_match(text, "Do not silently assume treatment-group coding", fixed = TRUE)
  expect_match(text, "Workflow agent deliverables belong under `ai_output/`", fixed = TRUE)
  expect_match(text, "QC agent deliverables belong under `qc/`", fixed = TRUE)
  expect_match(text, "If independent QC agent mode is enabled (`qc_agent = TRUE`)", fixed = TRUE)
  expect_match(text, "## Output Language", fixed = TRUE)
  expect_match(text, "generated by Codex should be written in English", fixed = TRUE)

  expect_false(grepl("generated by Codex should be written in Japanese", text, fixed = TRUE))
  expect_false(grepl(paste0("`source/", "init", "ial/`"), text, fixed = TRUE))
  expect_false(grepl(paste0("`ai_visible_data/", "init", "ial/`"), text, fixed = TRUE))
})

test_that("AGENTS.md records Japanese narrative output language when requested", {
  path <- tempfile("airsetup-")
  airsetup(path, split = FALSE, skills = FALSE, japanese = TRUE)

  agents <- readLines(file.path(path, "ai_project", "AGENTS.md"), warn = FALSE)
  text <- paste(agents, collapse = "\n")

  expect_identical(
    agents,
    agents_md_template(japanese = TRUE, qc_agent = FALSE, split = FALSE, skills = FALSE)
  )
  expect_match(text, "## Output Language", fixed = TRUE)
  expect_match(text, "generated by Codex should be written in Japanese", fixed = TRUE)
  expect_match(text, "R scripts, source code, machine-readable tables", fixed = TRUE)
  expect_false(grepl("generated by Codex should be written in English", text, fixed = TRUE))
})

test_that("logical arguments must be single TRUE or FALSE values", {
  path <- tempfile("airsetup-")

  expect_error(airsetup(path, split = NA), "split.*TRUE or FALSE")
  expect_error(airsetup(path, skills = c(TRUE, FALSE)), "skills.*TRUE or FALSE")
  expect_error(airsetup(path, qc_agent = "yes"), "qc_agent.*TRUE or FALSE")
  expect_error(airsetup(path, japanese = NA), "japanese.*TRUE or FALSE")
  expect_error(airsetup(path, overwrite = NA), "overwrite.*TRUE or FALSE")
})

test_that("QC_STATUS.md is generated as a minimal root status file", {
  path <- tempfile("airsetup-")
  airsetup(path, split = FALSE, skills = FALSE)

  qc_status <- readLines(file.path(path, "ai_project", "QC_STATUS.md"), warn = FALSE)
  text <- paste(qc_status, collapse = "\n")

  expect_identical(qc_status, qc_status_template())
  expect_equal(qc_status[1], "# QC_STATUS.md")
  expect_match(text, "## R Package QC", fixed = TRUE)
  expect_match(text, "cifmodeling", fixed = TRUE)
  expect_match(text, "CRAN listing checked; availability/runtime not checked", fixed = TRUE)
  expect_match(text, "## QC Items", fixed = TRUE)
  expect_match(text, "No QC items have been registered yet.", fixed = TRUE)
})

test_that("split r_project scaffold protects hidden data", {
  path <- tempfile("airsetup-")
  airsetup(path, skills = FALSE)

  gitignore <- file.path(path, "r_project", ".gitignore")
  readme <- file.path(path, "r_project", "README_DO_NOT_SHARE_WITH_AI.md")

  expect_true(file.exists(gitignore))
  expect_true(any(readLines(gitignore, warn = FALSE) == "ai_hidden_data/"))

  expect_true(file.exists(readme))
  readme_text <- paste(readLines(readme, warn = FALSE), collapse = "\n")
  expect_match(readme_text, "Do not share this folder with AI", fixed = TRUE)
  expect_match(readme_text, "ai_hidden_data/", fixed = TRUE)
  expect_match(readme_text, "ai_hidden_data/initial_YYYYMMDD/", fixed = TRUE)
  expect_match(readme_text, "../ai_project/ai_output/", fixed = TRUE)
  expect_match(readme_text, "../ai_project/r_output/", fixed = TRUE)

  expect_true(dir.exists(file.path(path, "r_project", "ai_hidden_data")))
  expect_false(dir.exists(file.path(path, "r_project", "r_scripts")))
  expect_false(dir.exists(file.path(path, "r_project", "r_output")))
  expect_one_dated_initial_dir(file.path(path, "r_project", "ai_hidden_data"))
  expect_false(dir.exists(file.path(path, "r_project", "ai_hidden_data", "initial")))
  expect_false(dir.exists(file.path(path, "r_project", "data")))
  expect_false(dir.exists(file.path(path, "r_project", "programs")))
  expect_false(dir.exists(file.path(path, "r_project", "config")))
  expect_false(dir.exists(file.path(path, "r_project", "outputs")))
})

test_that("aircheck reports missing and found selected items", {
  path <- tempfile("airsetup-")
  dir.create(path)

  report <- aircheck(path, split = TRUE, skills = TRUE, qc_agent = TRUE)
  expect_s3_class(report, "data.frame")
  expect_true(all(c("item", "type", "path", "exists", "required", "message") %in% names(report)))
  expect_true(any(!report$exists))

  airsetup(path, qc_agent = TRUE)
  report2 <- aircheck(path, split = TRUE, skills = TRUE, qc_agent = TRUE)

  expect_true(all(report2$exists))
  expect_true("ai_project/source" %in% report2$item)
  expect_true("ai_project/source/initial_YYYYMMDD" %in% report2$item)
  expect_true("ai_project/ai_visible_data" %in% report2$item)
  expect_true("ai_project/ai_visible_data/initial_YYYYMMDD" %in% report2$item)
  expect_true("ai_project/ai_output" %in% report2$item)
  expect_true("ai_project/r_output" %in% report2$item)
  expect_true("ai_project/agent_control/AGENT_CONTROL_INDEX.md" %in% report2$item)
  expect_true("ai_project/agent_control/QC_SKILL_CONTEXT.md" %in% report2$item)
  expect_true("ai_project/agent_control/WORKFLOW_AGENT.md" %in% report2$item)
  expect_true("ai_project/qc/review/QC_DECISION.md" %in% report2$item)
  expect_true("r_project/ai_hidden_data" %in% report2$item)
  expect_false("r_project/r_scripts" %in% report2$item)
  expect_false(paste0("r_project/", "r_output") %in% report2$item)

  expect_false("ai_project/source/initial" %in% report2$item)
  expect_false("ai_project/ai_visible_data/initial" %in% report2$item)
  expect_false("r_project/ai_hidden_data/initial" %in% report2$item)
})

test_that("aircheck can check ai-only structure without optional scaffolds", {
  path <- tempfile("airsetup-")
  airsetup(path, split = FALSE, skills = FALSE)

  report <- aircheck(path, split = FALSE, skills = FALSE, qc_agent = FALSE)

  expect_true(all(report$exists))
  expect_true(all(grepl("^ai_project/", report$path)))
  expect_false(any(grepl("^r_project/", report$path)))
  expect_false(any(grepl(paste0("source/", "skills"), report$path, fixed = TRUE)))
  expect_false(any(grepl("ai_project/skills", report$path, fixed = TRUE)))
  expect_true("ai_project/agent_control" %in% report$item)
  expect_true("ai_project/agent_control/AGENT_CONTROL_INDEX.md" %in% report$item)
  expect_false(any(grepl("QC_SKILL_", report$path, fixed = TRUE)))
  expect_true("ai_project/source" %in% report$item)
  expect_true("ai_project/source/initial_YYYYMMDD" %in% report$item)
  expect_true("ai_project/ai_visible_data" %in% report$item)
  expect_true("ai_project/ai_visible_data/initial_YYYYMMDD" %in% report$item)
  expect_true("ai_project/AGENTS.md" %in% report$item)
  expect_true("ai_project/QC_STATUS.md" %in% report$item)
})

test_that("mode argument is removed from public function signatures", {
  expect_false("mode" %in% names(formals(airsetup)))
  expect_false("mode" %in% names(formals(aircheck)))
})

test_that("qc_agent templates include Plan gate enforcement", {
  path <- tempfile("airsetup-")
  airsetup(path, qc_agent = TRUE)
  agents <- readLines(file.path(path, "ai_project", "AGENTS.md"))
  workflow <- readLines(file.path(path, "ai_project", "agent_control", "WORKFLOW_AGENT.md"))

  expect_true(any(grepl("Plan gate", agents)))
  expect_true(any(grepl("APPROVE_NEXT_STEP", agents)))
  expect_true(any(grepl("final R code generation", workflow)))
  expect_false(any(grepl("ai_project/qc/review", workflow, fixed = TRUE)))
})

test_that("mode argument is removed", {
  expect_error(
    do.call(airsetup, c(list(tempdir()), stats::setNames(list("split"), "mode"))),
    "unused argument|mode"
  )
})
