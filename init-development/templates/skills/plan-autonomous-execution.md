---
name: plan-autonomous-execution
description: 'Orchestrates explicit autonomous execution of a .plan.md file using plan-worker and test-feedback subagents, with dependency-aware sequencing, parallel batches, and per-task commit/push. Use only when the prompt contains the exact token @run-plan-autonomous.'
---

# Plan Autonomous Execution

Use this skill only for explicit autonomous execution mode.

## Activation Gate

Run this workflow only when the user prompt contains the exact token:

- `@run-plan-autonomous`

If the token is absent, do not apply this skill.

## Important Platform Constraint

Nested subagents are unsupported. Therefore:

- parent agent performs orchestration
- parent agent launches `plan-worker` and `test-feedback` as sibling subagents
- do not attempt subagent-to-subagent fan-out

## Required Inputs

- `plan=<path-to-.plan.md>`
- optional: `start=fresh|resume` (explicit override)
- optional: `base=<branch>` (default: `{{BASE_BRANCH}}` when `start=fresh`)
- optional: `max_parallel=<N>` (default: `2`)
- optional: `max_governance_retries=<N>` (default: `2`)
- optional: `branch=<name>` override

## Git Branch Policy

Branch selection priority (highest to lowest):

1. explicit `branch=<name>` in prompt
2. explicit `start=fresh|resume` in prompt
3. auto-detect from plan progress

Auto-detect rules when `start` is not provided:

- if plan has zero progress (no completed todos and no completed progress bullets), treat as fresh start
- if plan already has progress, treat as resume

Fresh-start behavior (`start=fresh`) with no explicit branch override:

1. checkout `{{BASE_BRANCH}}`
2. pull latest for `{{BASE_BRANCH}}`
3. create new branch `plan/<plan-slug>-<yyyymmdd>`

Resume behavior (`start=resume`) with no explicit branch override:

- continue in current branch
- do not create a new branch automatically

If prompt explicitly requests different branch behavior, follow prompt.

## Plan Parsing and Scheduling

1. Read plan frontmatter and task sections.
2. Build execution units (one unit = one subtask).
3. Determine dependency order and concurrency:
   - `sequential-blocked`: run strictly after prerequisites
   - `parallel-safe`: eligible for same batch
   - `async-independent`: can run asynchronously, must return before batch checkpoint
4. For each batch, avoid launching tasks that are likely to collide on same files.

## Deterministic Plan Parser Protocol

Use this parser protocol exactly to infer progress state.

### Canonical todo status model (mandatory)

- `todos[*].status` supports only: `pending`, `in_progress`, `completed`
- `blocked` and `failed` are forbidden as todo statuses
- blocked/failed outcomes must be represented only as progress notes in `## Progress Update (...)`

### Frontmatter source of truth

- read `todos[*].status` from frontmatter
- valid states: `pending`, `in_progress`, `completed`
- if any other value appears, treat it as invalid plan state and stop for manual reconciliation

### Progress Update marker source

- in `## Progress Update (...)`, treat bullets starting with `- ✅` as completed markers
- treat bullets starting with `- 🔄` as in-progress markers
- treat bullets starting with `- 🧩` as extra completed work only if the text explicitly says completed
- treat bullets starting with `- ⛔ BLOCKED:` as blocked notes (informational, not todo status)
- treat bullets starting with `- ❌ FAILED:` as failed notes (informational, not todo status)

### Zero-progress detection

Treat plan as zero-progress only when both are true:

1. no frontmatter todo has `status: completed`
2. no `- ✅` bullet exists in the Progress Update section

If either condition is false, plan is non-zero-progress (resume mode by default).

## Synchronization Gate (Mandatory)

Before launching any next worker task, parent must complete all steps:

1. apply progress update to plan using `plan-progress-sync` conventions
2. save file changes
3. re-read the plan file from disk
4. verify assigned task status and prerequisites reflect the expected state
5. only then launch next `plan-worker`

If verification fails, stop and reconcile the plan before any further subagent launch.

## Parallel Batch Checkpoint Protocol

For `parallel-safe` or `async-independent` tasks:

1. launch workers in parallel for the same batch
2. do not let workers edit the plan file
3. wait for all workers and test-feedback results in the batch
4. update plan sequentially in parent (one task status at a time)
5. re-read plan after each task status write
6. after full batch sync, start the next batch

This prevents plan-status races and ensures each next task sees committed plan state.

## Subagent Orchestration Loop

For each runnable subtask:

1. Launch `plan-worker` with strict single-task scope.
2. On worker completion, launch `test-feedback` for verification.
3. If `GO_NO_GO: no-go`:
   - append progress note: `- 🔄 <task-id> no-go: <concise reason>`
   - keep todo status as `in_progress` (or `pending` if work did not start)
   - launch `plan-worker` again with test feedback
   - re-run `test-feedback`
   - repeat until pass or explicit recovery threshold
4. On pass:
   - update and verify plan via Synchronization Gate
   - commit with short explanatory message
   - push branch
5. On blocked/failed:
   - write deterministic progress note in plan:
     - `- ⛔ BLOCKED: <task-id> | reason: <concise blocker> | next: <unblock action>`
     - `- ❌ FAILED: <task-id> | reason: <concise failure> | next: <recovery action>`
   - do not write `blocked` or `failed` to frontmatter todo status
   - keep todo status `in_progress` if execution started, otherwise `pending`
   - re-read and verify plan before scheduling other tasks

## Final Governance and PR Gate (Mandatory)

Run this stage only after the main task loop reaches batch-stable completion.

- Phase A: verify all frontmatter todos are `status: completed`
- Phase B: launch `governance-checker` with:
  - checklist path: `{{DOCS_DIR}}/governance-checklist.md`
  - run context: plan path, branch name, completed-task summary, and recent test-feedback outcomes
- Phase C: if checker returns `GO_NO_GO: no-go`, run deterministic corrective loop:
  - retry model:
    - one initial governance check always runs first
    - then run at most `max_governance_retries` remediation cycles (default `2`)
    - one remediation cycle = `plan-worker` focused fix -> `test-feedback` -> `governance-checker` re-run
  - stop conditions:
    - stop-success: immediately stop when `GO_NO_GO: go`
    - stop-threshold: stop when `GO_NO_GO: no-go` after the final allowed remediation cycle
- Phase D: create PR to `{{BASE_BRANCH}}` only when checker returns clean pass (`GO_NO_GO: go`)

Hard gate rule:

- parent must treat `governance-checker` `GO_NO_GO` as a required gate before any PR stage
- when `GO_NO_GO: no-go`, do not open PR; continue remediation only within threshold
- on threshold breach, end without PR and return explicit final report containing:
  - blocking reason (`governance no-go threshold reached`)
  - concise findings summary from last checker run
  - remediation attempts used versus allowed

## Commit and Push Policy

After each completed subtask:

1. stage relevant changes
2. commit with message focused on intent
3. push to current branch

Commit style:

- first line <= 72 chars
- mention task id when available
- example: `refactor(firm-profile): extract entities service (task refactor-2.3)`

## Safety Rules

- never start this mode without explicit token
- do not run destructive git commands
- if the worktree contains unrelated conflicting edits, stop and ask user
- if a task is blocked by missing dependency, write `- ⛔ BLOCKED: ...` progress note and continue with other runnable tasks
- keep exactly one source of truth for progress in the plan file
- parent is the only writer of the plan file during orchestration

## Suggested Invocation

`@run-plan-autonomous plan=.cursor/plans/my-plan.plan.md start=fresh base={{BASE_BRANCH}} max_parallel=3`

## Completion Criteria

- all possible tasks completed or explicitly recorded as blocked/failed in progress notes
- plan todos and progress section synchronized
- every completed subtask has its own commit and push
- PR is opened against `{{BASE_BRANCH}}` only after governance checker clean pass
- final report includes:
  - completed tasks
  - blocked tasks
  - failed tasks
  - branch name
  - links/refs to commits
