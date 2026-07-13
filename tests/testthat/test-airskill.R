test_that("airskill creates QC skill files", {
  path <- tempfile("airskill-")
  airsetup(path, split = FALSE, skills = FALSE)

  report <- airskill(path, quiet = TRUE)

  expect_s3_class(report, "data.frame")
  expect_true(all(c("file", "path", "status", "overwritten") %in% names(report)))
  expect_equal(
    report$file,
    c(
      "AGENT_CONTROL_INDEX.md",
      "QC_SKILL_CONTEXT.md",
      "QC_SKILL_PLAN.md",
      "QC_SKILL_SAP.md",
      "QC_SKILL_RESULT.md",
      "QC_SKILL_M11SEMANTIC.md"
    )
  )
  expect_equal(report$status, c("skipped", "created", "created", "created", "created", "created"))
  expect_true(all(!report$overwritten))

  skills_dir <- file.path(path, "ai_project", "agent_control")
  expect_true(dir.exists(skills_dir))
  expect_false(dir.exists(file.path(path, "ai_project", "skills")))
  expect_false(dir.exists(file.path(path, "ai_project", "source", "skills")))
  expect_true(file.exists(file.path(skills_dir, "AGENT_CONTROL_INDEX.md")))
  expect_true(file.exists(file.path(skills_dir, "QC_SKILL_CONTEXT.md")))
  expect_true(file.exists(file.path(skills_dir, "QC_SKILL_PLAN.md")))
  expect_true(file.exists(file.path(skills_dir, "QC_SKILL_SAP.md")))
  expect_true(file.exists(file.path(skills_dir, "QC_SKILL_RESULT.md")))
  expect_true(file.exists(file.path(skills_dir, "QC_SKILL_M11SEMANTIC.md")))

  index <- paste(readLines(file.path(skills_dir, "AGENT_CONTROL_INDEX.md"), warn = FALSE), collapse = "\n")
  expect_match(index, "Do not load all agent control files unless needed.", fixed = TRUE)
  expect_match(index, "Carry unresolved issues forward to `QC_STATUS.md`.", fixed = TRUE)
  expect_match(index, "Use `QC_SKILL_M11SEMANTIC.md` when:", fixed = TRUE)
  expect_match(index, "Use `QC_SKILL_SAP.md` when:", fixed = TRUE)
  expect_match(index, "PLAN and SAP are", fixed = TRUE)
  expect_match(index, "Use `QC_SKILL_CONTEXT.md` instead.", fixed = TRUE)

  context <- paste(readLines(file.path(skills_dir, "QC_SKILL_CONTEXT.md"), warn = FALSE), collapse = "\n")
  expect_match(context, "## 12. Handoff to next workflow step", fixed = TRUE)
  expect_match(context, "Do not assign a numeric score.", fixed = TRUE)
  expect_match(context, "AI assumption risks", fixed = TRUE)
  expect_match(context, "R package QC updates for `QC_STATUS.md`", fixed = TRUE)
  expect_match(context, "Package and reproducibility constraints", fixed = TRUE)

  plan <- paste(readLines(file.path(skills_dir, "QC_SKILL_PLAN.md"), warn = FALSE), collapse = "\n")
  expect_match(plan, "planned package, main function, CRAN status", fixed = TRUE)
  expect_match(plan, "For a clinical-trial Statistical Analysis Plan (SAP), use `QC_SKILL_SAP.md` instead.", fixed = TRUE)
  expect_match(plan, "No evidence, no study-specific assertion.", fixed = TRUE)

  sap <- paste(readLines(file.path(skills_dir, "QC_SKILL_SAP.md"), warn = FALSE), collapse = "\n")
  expect_match(sap, "No evidence, no study-specific assertion.", fixed = TRUE)
  expect_match(sap, "Review all 55 paraphrased items internally.", fixed = TRUE)
  expect_match(sap, "M11SEMANTIC_MAP.md` is optional input", fixed = TRUE)
  expect_match(sap, "Do not require or recreate a complete M11 semantic map", fixed = TRUE)
  expect_match(sap, "ai_project/qc/sap-qc-001.md", fixed = TRUE)
  expect_match(sap, "Counts are descriptive only and are not a score.", fixed = TRUE)

  result <- paste(readLines(file.path(skills_dir, "QC_SKILL_RESULT.md"), warn = FALSE), collapse = "\n")
  expect_match(result, "package versions, installation or namespace messages", fixed = TRUE)

  m11semantic <- paste(readLines(file.path(skills_dir, "QC_SKILL_M11SEMANTIC.md"), warn = FALSE), collapse = "\n")
  expect_match(m11semantic, "M11-informed semantic organization", fixed = TRUE)
  expect_match(m11semantic, "ai_project/ai_output/m11semantic/M11SEMANTIC_MAP.md", fixed = TRUE)
  expect_match(m11semantic, "ai_project/qc/m11semantic/M11SEMANTIC_QC_SUMMARY.md", fixed = TRUE)
  expect_match(m11semantic, "Do not claim M11 compliance.", fixed = TRUE)
  expect_match(m11semantic, "Do not also use the common AI & R QC Report format.", fixed = TRUE)
  expect_match(m11semantic, "No evidence, no study-specific assertion.", fixed = TRUE)
  expect_match(m11semantic, "| Item | Document-supported content | Evidence | Status |", fixed = TRUE)
  expect_match(m11semantic, "| Cannot assess | Required material is unavailable", fixed = TRUE)
  expect_match(m11semantic, "Include these 14 rows in the semantic map:", fixed = TRUE)
  expect_false(grepl("- implications for R coding", m11semantic, fixed = TRUE))
  expect_false(grepl("# AI & R QC Report", m11semantic, fixed = TRUE))
})

test_that("airskill selected skills creates index plus selected files", {
  path <- tempfile("airskill-")
  airsetup(path, split = FALSE, skills = FALSE)

  report <- airskill(path, skills = "context", quiet = TRUE)

  expect_equal(report$file, c("AGENT_CONTROL_INDEX.md", "QC_SKILL_CONTEXT.md"))
  expect_equal(report$status, c("skipped", "created"))

  skills_dir <- file.path(path, "ai_project", "agent_control")
  expect_true(file.exists(file.path(skills_dir, "AGENT_CONTROL_INDEX.md")))
  expect_true(file.exists(file.path(skills_dir, "QC_SKILL_CONTEXT.md")))
  expect_false(file.exists(file.path(skills_dir, "QC_SKILL_PLAN.md")))
  expect_false(file.exists(file.path(skills_dir, "QC_SKILL_SAP.md")))
  expect_false(file.exists(file.path(skills_dir, "QC_SKILL_RESULT.md")))
  expect_false(file.exists(file.path(skills_dir, "QC_SKILL_M11SEMANTIC.md")))
})

test_that("airskill can create only the M11 semantic skill", {
  path <- tempfile("airskill-")
  airsetup(path, split = FALSE, skills = FALSE)

  report <- airskill(path, skills = "m11_semantic", quiet = TRUE)

  expect_equal(report$file, c("AGENT_CONTROL_INDEX.md", "QC_SKILL_M11SEMANTIC.md"))
  expect_equal(report$status, c("skipped", "created"))

  skills_dir <- file.path(path, "ai_project", "agent_control")
  expect_true(file.exists(file.path(skills_dir, "AGENT_CONTROL_INDEX.md")))
  expect_true(file.exists(file.path(skills_dir, "QC_SKILL_M11SEMANTIC.md")))
  expect_false(file.exists(file.path(skills_dir, "QC_SKILL_CONTEXT.md")))
  expect_false(file.exists(file.path(skills_dir, "QC_SKILL_SAP.md")))
})

test_that("airskill can create only the clinical SAP skill", {
  path <- tempfile("airskill-")
  airsetup(path, split = FALSE, skills = FALSE)

  report <- airskill(path, skills = "sap", quiet = TRUE)

  expect_equal(report$file, c("AGENT_CONTROL_INDEX.md", "QC_SKILL_SAP.md"))
  expect_equal(report$status, c("skipped", "created"))

  skills_dir <- file.path(path, "ai_project", "agent_control")
  expect_true(file.exists(file.path(skills_dir, "AGENT_CONTROL_INDEX.md")))
  expect_true(file.exists(file.path(skills_dir, "QC_SKILL_SAP.md")))
  expect_false(file.exists(file.path(skills_dir, "QC_SKILL_PLAN.md")))
  expect_false(file.exists(file.path(skills_dir, "QC_SKILL_M11SEMANTIC.md")))
})

test_that("airskill preserves existing files by default and overwrites when requested", {
  path <- tempfile("airskill-")
  airsetup(path, split = FALSE, skills = FALSE)
  airskill(path, skills = "context", quiet = TRUE)

  context <- file.path(path, "ai_project", "agent_control", "QC_SKILL_CONTEXT.md")
  writeLines("custom context skill", context)

  skipped <- airskill(path, skills = "context", overwrite = FALSE, quiet = TRUE)
  expect_true(any(skipped$file == "QC_SKILL_CONTEXT.md" & skipped$status == "skipped"))
  expect_equal(readLines(context, warn = FALSE), "custom context skill")

  overwritten <- airskill(path, skills = "context", overwrite = TRUE, quiet = TRUE)
  expect_true(any(overwritten$file == "QC_SKILL_CONTEXT.md" & overwritten$status == "overwritten"))
  expect_true(any(overwritten$file == "QC_SKILL_CONTEXT.md" & overwritten$overwritten))
  expect_identical(readLines(context, warn = FALSE), context_qc_skill_template())
})

test_that("airskill validates skill names and project structure", {
  path <- tempfile("airskill-")
  dir.create(path)

  expect_error(airskill(path, quiet = TRUE), "airsetup project root")
  expect_error(airskill(tempfile("missing-"), quiet = TRUE))

  airsetup(path, split = FALSE, skills = FALSE)
  expect_error(airskill(path, skills = "other", quiet = TRUE), "Unsupported skill value")
  expect_error(airskill(path, skills = character(), quiet = TRUE), "`skills` must be")
  expect_error(airskill(path, overwrite = NA, quiet = TRUE), "`overwrite` must be")
  expect_error(airskill(path, quiet = NA), "`quiet` must be")
})
