---
name: plan-progress-sync
description: Keep plan files in sync during execution. Use when working with `.plan.md` files, completing planned tasks, or executing any phase/subtask from a plan so todo statuses and progress updates are recorded immediately.
---

# Plan Progress Sync

Use this skill whenever the agent is actively executing work from a plan file (typically `.cursor/plans/*.plan.md`).

## Goal

Ensure every completed plan action is reflected in two places:

1. `todos` in frontmatter (`pending` -> `in_progress` -> `completed` only)
2. `## Progress Update (...)` section near the top of the plan

Canonical status model:

- allowed todo statuses: `pending`, `in_progress`, `completed`
- forbidden todo statuses: `blocked`, `failed`
- blocked/failed outcomes must be captured as progress notes, not todo statuses

## Mandatory Update Rule

After each meaningful completed action from the plan, update the plan file in the same work cycle before finalizing your response.

Meaningful actions include:

- finished phase
- completed subtask
- completed checklist/bullet item
- additional improvised action that supports the plan but was not listed explicitly

Do not postpone these updates until the end of the whole project.

## Update Workflow

1. Identify what was completed in the current cycle.
2. Update frontmatter `todos`:
   - mark the corresponding todo as `completed` when done
   - if partially done, keep it `in_progress`
   - start the next logical todo as `in_progress` when appropriate
   - keep only one todo as `in_progress` whenever possible
   - never set todo status to `blocked` or `failed`
3. Update `## Progress Update (...)`:
   - add a new bullet describing completed work
   - reference phase/refactor/subtask names used in the plan
   - include improvised but relevant actions in a separate explicit bullet
   - if blocked/failed occurred, add deterministic note and keep todo in allowed status set
4. Keep entries concise, factual, and chronological (newest updates first).
5. Save the plan file before moving to unrelated tasks or final reply.

## Progress Entry Style

Use clear status markers:

- `✅` completed item
- `🔄` in-progress item
- `🧩` additional improvised action not explicitly listed in the original plan
- `⛔ BLOCKED:` blocked note (reason + next action)
- `❌ FAILED:` failed note (reason + recovery action)

Example patterns:

- `✅ Phase 5 / Refactor 2 completed: extracted service orchestration and added unit tests.`
- `🔄 Phase 5 / Refactor 3 in progress: migrating dashboard inline fetch logic into hooks.`
- `🧩 Extra improvement: added shared test helper to reduce route-test duplication.`
- `⛔ BLOCKED: phase2-secure-ops-endpoints | reason: missing admin token in env | next: provision token and retry.`
- `❌ FAILED: phase4-agent-output-contract | reason: parser mismatch in worker output | next: normalize output schema and rerun.`

## Consistency Requirements

- `todos` statuses must not contradict the progress bullets.
- If a todo is marked `completed`, progress must mention what was completed.
- If progress claims a phase is complete, its related todo cannot stay `pending`.
- blocked/failed information must appear only in progress notes, never as todo status values.
- Preserve existing plan structure and headings.

## When Closing A Task

Before sending the final user-facing response for plan-driven work, quickly verify:

- relevant todo statuses are updated
- progress bullets include newly completed actions
- improvised actions are explicitly logged

If any of these are missing, update the plan first, then respond.
