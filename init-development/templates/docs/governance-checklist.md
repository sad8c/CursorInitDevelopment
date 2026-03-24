# Governance Checklist

## Overview

Lightweight process guardrails to prevent drift between implementation and project knowledge artifacts after API, auth, data model, or shared contract changes.

Run this checklist in PR validation or before merge when any trigger condition below is met.

## Trigger Conditions

- Any API route add/remove/rename or method/contract change.
- Any auth contract change in API handlers, auth helpers, or ownership/access rules.
- Any shared convention change (error handling, validation patterns, configuration contracts).
- Any planner-orchestrator contract change in plan execution artifacts (`.cursor/commands/run-plan-autonomous.md`, `.cursor/skills/plan-autonomous-execution/SKILL.md`, `.cursor/skills/plan-progress-sync/SKILL.md`, `.cursor/agents/plan-worker.md`, `.cursor/agents/test-feedback.md`).

## Checklist

### 1) API Inventory vs Documentation

- Compare active API routes with documented endpoints in `{{DOCS_DIR}}`.
- Ensure every active route is documented with method, path, access level, and purpose.
- Ensure removed or renamed routes are removed or updated in documentation.

### 2) Auth/Contracts Consistency

- For `auth`, confirm alignment between:
  - docs in `{{DOCS_DIR}}`
  - rules in `.cursor/rules/`
  - skills in `.cursor/skills/`
- For shared contracts, confirm docs/rules/skills reflect current implementation.
- If conflict exists, keep Source-of-Truth layering: rules = guardrails, skills = workflow, docs = detailed reference.

### 3) Plan Execution Contract (`plan-` Artifacts)

- Verify planner status model still uses only `pending|in_progress|completed` in `todos[*].status`.
- Verify blocked/failed outcomes are represented in progress notes, not in todo status.
- Verify plan-worker and test-feedback output contracts remain parse-safe key-value templates expected by orchestrator logic.
- Verify `run-plan-autonomous` instructions are consistent with planner and progress-sync skills.

## Completion Criteria

- Checklist items reviewed for all triggered surfaces.
- Any detected drift fixed in the same PR or explicitly listed as follow-up work.
