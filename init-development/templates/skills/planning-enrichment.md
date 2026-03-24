---
name: planning-enrichment
description: 'Builds execution-ready plans for {{PROJECT_NAME}} with dependency mapping, testing/docs enrichment, and subagent-sized task decomposition. Use when the user asks for a plan, roadmap, phased implementation, or refactor plan.'
---

# Planning Enrichment

Use this skill when drafting or revising `.cursor/plans/*.plan.md`.

## Goal

Produce plans that are directly executable by autonomous orchestration:

- every task is isolated enough to reduce merge conflicts
- every task is substantial enough to be worth a subagent run
- every task is atomic enough to complete in one worker cycle

## Planning Pipeline

1. Classify the plan before phases (one or more):
   - `feature/workflow change`
   - `API/server contract change`
   - `UI flow/component change`
   - `integration/provider change`
   - `refactor/legacy stabilization`
   - `data model/migration change`
   - `architecture/shared contract change`
2. Expand mandatory enrichment categories:
   - testing impact
   - testability refactor impact
   - mocks/stubs/fixtures
   - docs impact in `{{DOCS_DIR}}`
   - rules/skills impact
   - knowledge-sync impact
   - parallelization impact
3. Apply deterministic behavior triggers for enrichment:
   - if any API route changes -> add API test subtasks + auth/validation/ownership review
   - if hooks/polling/client data-flow changes -> add hook/component test subtasks + timeout/cleanup review
   - if critical user flows change -> evaluate e2e impact + include at least one e2e subtask unless explicitly ruled out
   - if shared contracts/conventions change -> add docs + knowledge-sync subtasks
   - if legacy refactors are planned -> add characterization-test subtasks first
4. Decompose each phase into subagent-ready tasks using the protocol below.
5. Mark prerequisites, dependencies, and concurrency.
6. Run the final completeness checklist.

## Subagent-Ready Task Unit Protocol

Each task in the plan must satisfy all three properties.

### 1) Isolated

- has explicit file/surface scope (paths or modules)
- has one primary outcome
- does not require cross-phase hidden context
- declares conflict risk with sibling tasks

### 2) Atomic

- can be completed in one worker run with one validation loop
- has binary acceptance criteria (`done`/`not done`)
- has a clear entry condition (prerequisites) and exit condition
- avoids mixed outcomes like "refactor + UI redesign + docs rewrite" in one task

### 3) Sufficiently Capacity-Rich

- not too small (avoid micro-tasks like "rename one variable")
- includes implementation + minimal verification for that slice
- produces meaningful artifact(s): code delta, tests, or contract update

## Task Sizing Heuristics

Use these defaults when splitting work:

- target one bounded surface cluster per task (usually 1-4 files, or one cohesive module area)
- target one dominant risk type per task (API contract, async flow, parsing, UI state, etc.)
- target one verification bundle per task (unit OR route OR component OR e2e-impact check)
- if a task needs multiple independent verifications, split it
- if a task cannot produce a meaningful commit message on its own, merge it with a sibling

## Required Task Metadata In Plan

For every execution task, include:

- `task_id`
- `outcome` (single primary result)
- `scope` (files/modules)
- `acceptance_criteria` (checklist with binary checks)
- `verification` (commands or test type)
- `prerequisites` (entry conditions that must already be true)
- `depends_on` (task ids or empty)
- `concurrency` (`parallel-safe` | `async-independent` | `sequential-blocked`)
- `conflict_risk` (shared files/surfaces)
- `sync_checkpoint` (where outputs are reconciled)

## Concurrency Mapping Rules

- `parallel-safe`: no overlapping write scope and no hidden runtime coupling
- `async-independent`: independent deliverable that can report later, but must sync before dependent tasks
- `sequential-blocked`: depends on unfinished prerequisite or shared risky surface

For medium/large plans, include at least one explicit parallel batch with a named synchronization checkpoint unless clearly unsafe.

## Validation Guidance

Before finalizing, dry-run the plan against representative classes:

- feature/workflow change: verify tests + docs/knowledge-sync expansion when behavior changes
- API/server contract change: verify route/auth/validation/ownership review + API test subtasks
- UI flow/component change: verify hook/component tests + critical-flow e2e decision
- integration/provider change: verify mocks/stubs + integration sequencing + sync checkpoints
- refactor/legacy stabilization: verify characterization tests precede behavior changes
- data model/migration change: verify contract/test/docs/knowledge-sync impacts are explicit
- architecture/shared contract change: verify docs/rules/skills + knowledge-sync tasks are explicit

At least one validation pass should demonstrate a usable parallel batch that rejoins at a checkpoint label.

## Decomposition Algorithm

For each broad phase:

1. Write desired phase outcome in one sentence.
2. List candidate changes by code surface.
3. Group by lowest-coupling clusters.
4. Create one task per cluster with binary acceptance.
5. Attach verification and dependency metadata.
6. Re-check each task against Isolated + Atomic + Capacity-Rich gates.
7. Split or merge until all gates pass.

## Anti-Patterns (Must Avoid)

- tasks that span unrelated layers without a clear seam
- tasks that require "continue in next task" to finish core acceptance
- tasks with vague acceptance ("improve reliability", "clean up code")
- parallel tasks writing same hotspot files without sync strategy
- docs/rules/skill updates left implicit when contracts change

## Existing Skill Routing

When plan touches specific domains, reference installed skills:

- docs/architecture consistency -> `project-docs`
- progress synchronization during execution -> `plan-progress-sync`
- knowledge sync after contract changes -> `knowledge-sync`
- testing decisions -> `testing-policy`

## Subtask Template (Use in Plan)

```markdown
- task_id: <phase-x.y>
  outcome: <single primary result>
  scope:
  - <path-or-module>
    acceptance_criteria:
  - [ ] <binary condition 1>
  - [ ] <binary condition 2>
        verification:
  - <test command or validation step>
    prerequisites:
  - <entry condition or none>
    depends_on:
  - <task-id or none>
    concurrency: <parallel-safe|async-independent|sequential-blocked>
    conflict_risk:
  - <shared surface or none>
    sync_checkpoint: <batch checkpoint label>
```

## Final Completeness Checklist

- [ ] task type is classified
- [ ] mandatory enrichment categories are present
- [ ] behavior triggers were evaluated and applicable rows expanded
- [ ] every task has required metadata
- [ ] every task passes Isolated + Atomic + Capacity-Rich gates
- [ ] dependencies and concurrency are explicit
- [ ] at least one parallel batch exists for medium/large plans (or explicit reason why not)
- [ ] representative validation pass covers all applicable classes in the classification list
- [ ] testing/docs/rules/skills/knowledge-sync impacts are covered
