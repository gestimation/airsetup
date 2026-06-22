test_that("split mode creates ai_project and minimal r_project", {
  path <- tempfile("airsetup-")
  create_agentic_project(path, mode = "split")

  expect_true(dir.exists(file.path(path, "ai_project")))
  expect_true(dir.exists(file.path(path, "r_project")))
  expect_true(dir.exists(file.path(path, "ai_project", "01_study_documentation_package", "source")))
  expect_false(dir.exists(file.path(path, "01_study_documentation_package")))
  expect_true(file.exists(file.path(path, "ai_project", "AGENTS.md")))
  expect_true(file.exists(file.path(path, "ai_project", "05_qc_package", "template", "checkpoint_definition_template.csv")))
  expect_true(file.exists(file.path(path, "ai_project", "03_statistical_analysis_package", "template", "software_inventory_template.csv")))
  expect_true(dir.exists(file.path(path, "ai_project", "06_analysis_execution", "datasets", "dummy")))
})

test_that("ai_only mode creates ai_project but not r_project", {
  path <- tempfile("airsetup-")
  create_agentic_project(path, mode = "ai_only")

  expect_true(dir.exists(file.path(path, "ai_project")))
  expect_false(dir.exists(file.path(path, "r_project")))
  expect_true(dir.exists(file.path(path, "ai_project", "06_analysis_execution", "datasets", "dummy")))
  expect_false(dir.exists(file.path(path, "06_analysis_execution")))
})

test_that("overwrite behavior preserves existing files by default", {
  path <- tempfile("airsetup-")
  create_agentic_project(path, mode = "ai_only")
  agents <- file.path(path, "ai_project", "AGENTS.md")
  writeLines("custom", agents)
  create_agentic_project(path, mode = "ai_only", overwrite = FALSE)
  expect_equal(readLines(agents), "custom")
  create_agentic_project(path, mode = "ai_only", overwrite = TRUE)
  expect_true(any(grepl("Checkpoint QC", readLines(agents))))
})

test_that("AGENTS.md includes required workflow and separation rules", {
  path <- tempfile("airsetup-")
  create_agentic_project(path, mode = "ai_only")
  text <- paste(readLines(file.path(path, "ai_project", "AGENTS.md")), collapse = "\n")
  expect_match(text, "AI-visible and AI-hidden project separation")
  expect_match(text, "r_project")
  expect_match(text, "real data")
  expect_match(text, "dummy")
  expect_match(text, "Agent operating rules")
  expect_match(text, "Git or GitHub is not required")
  expect_match(text, "Preflight")
  expect_match(text, "Flight")
  expect_match(text, "Landing")
  expect_match(text, "human_checkpoint")
  expect_match(text, "ai_assisted_human_checkpoint")
  expect_match(text, "automated_checkpoint")
  expect_match(text, "Software Inventory")
  expect_match(text, "Before starting any task")
  expect_match(text, "files created or modified")
})

test_that("split mode r_project scaffold is minimal and protects data", {
  path <- tempfile("airsetup-")
  create_agentic_project(path, mode = "split")

  gitignore <- file.path(path, "r_project", ".gitignore")
  expect_true(file.exists(gitignore))
  expect_true(any(readLines(gitignore) == "data/"))
  expect_true(file.exists(file.path(path, "r_project", "data", "README_DO_NOT_COMMIT.md")))
  expect_true(file.exists(file.path(path, "r_project", "programs", "run_analysis_template.R")))
  expect_false(dir.exists(file.path(path, "r_project", "config")))
  expect_false(dir.exists(file.path(path, "r_project", "outputs")))
})

test_that("checkpoint template contains phases and opener types", {
  path <- tempfile("airsetup-")
  create_agentic_project(path)
  cp <- read.csv(file.path(path, "ai_project", "05_qc_package", "template", "checkpoint_definition_template.csv"))
  expect_equal(cp$phase, c("Preflight", "Preflight", "Flight", "Flight", "Landing", "Landing"))
  expect_equal(cp$checkpoint_id, sprintf("C%02d", 1:6))
  expect_equal(cp$opener_type, c("human_checkpoint", "human_checkpoint", "ai_assisted_human_checkpoint", "human_checkpoint", "ai_assisted_human_checkpoint", "human_checkpoint"))
  expect_true(all(c("phase", "checkpoint_id", "checkpoint_name", "objective", "required_inputs", "expected_outputs", "check_items", "checkpoint_condition", "opener_type", "checkpoint_opener", "reviewer", "approval_required", "downstream_steps") %in% names(cp)))
})

test_that("software inventory template has required columns and status guidance", {
  path <- tempfile("airsetup-")
  create_agentic_project(path)
  inv <- read.csv(
    file.path(path, "ai_project", "03_statistical_analysis_package", "template", "software_inventory_template.csv"),
    check.names = FALSE
  )
  expect_true(all(c("category", "task", "package", "function", "status", "allowed_use", "restricted_use", "qc_requirement", "notes") %in% names(inv)))
  expect_match(inv$notes[1], "approved")
  expect_match(inv$notes[1], "under_review")
})

test_that("checkpoint QC templates have required columns", {
  path <- tempfile("airsetup-")
  create_agentic_project(path)
  checklist <- read.csv(file.path(path, "ai_project", "05_qc_package", "template", "checkpoint_checklist_template.csv"))
  decision <- read.csv(file.path(path, "ai_project", "05_qc_package", "template", "checkpoint_decision_log_template.csv"))
  discrepancy <- read.csv(file.path(path, "ai_project", "05_qc_package", "template", "checkpoint_discrepancy_log_template.csv"))
  expect_true(all(c("phase", "checkpoint_id", "check_item_id", "check_item_name", "description", "check_type", "expected_evidence", "result", "reviewer", "review_date", "comment") %in% names(checklist)))
  expect_true(all(c("phase", "checkpoint_id", "checkpoint_name", "opener_type", "checkpoint_decision", "decision_date", "decided_by", "evidence_reviewed", "unresolved_issues", "downstream_steps_allowed", "comment") %in% names(decision)))
  expect_true(all(c("discrepancy_id", "phase", "checkpoint_id", "detected_at", "description", "severity", "affected_files", "affected_downstream_steps", "resolution", "resolved_by", "resolved_at", "comment") %in% names(discrepancy)))
})

test_that("check_agentic_project reports missing and found split-mode items without stopping", {
  path <- tempfile("airsetup-")
  dir.create(path)
  report <- check_agentic_project(path, mode = "split")
  expect_s3_class(report, "data.frame")
  expect_true(all(c("item", "type", "path", "exists", "required", "message") %in% names(report)))
  expect_true(any(!report$exists))
  create_agentic_project(path, mode = "split")
  report2 <- check_agentic_project(path, mode = "split")
  expect_true(all(report2$exists))
  expect_true("r_project/programs/run_analysis_template.R" %in% report2$item)
})

test_that("check_agentic_project reports all required ai-only items after creation", {
  path <- tempfile("airsetup-")
  create_agentic_project(path, mode = "ai_only")
  report <- check_agentic_project(path, mode = "ai_only")
  expect_true(all(report$exists))
  expect_true(all(grepl("^ai_project/", report$path)))
})
