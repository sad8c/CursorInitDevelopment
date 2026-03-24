# Run Plan Autonomous

Execute autonomous plan mode now.

Always include this exact activation token in your response:

`@run-plan-autonomous`

## Parameters

- `plan`: required path to `.plan.md`
- `start`: optional `fresh|resume`
- `base`: optional base branch for fresh starts (default `{{BASE_BRANCH}}`)
- `branch`: optional explicit branch override
- `max_parallel`: optional integer (default `2`)
- `max_governance_retries`: optional integer remediation-cycle limit after governance no-go (default `2`)

## Behavior contract

1. Parse the target plan and schedule subagent-sized tasks.
2. Use `plan-worker` for each implementation subtask.
3. Use `test-feedback` after each worker result.
4. Apply `plan-progress-sync` updates before launching next worker.
5. If plan has zero progress and no override, create a new branch from `{{BASE_BRANCH}}`.
6. If plan has existing progress and no override, continue in current branch.
7. After each completed subtask: commit and push.
8. Canonical todo status model is strict: `pending|in_progress|completed` only.
9. Do not write `blocked` or `failed` to `todos[*].status`; record those outcomes only as progress notes.
10. If blocked/failed: add deterministic progress note and continue with other runnable tasks.
11. Do not create a PR unless all todos are `completed`.
12. Do not create a PR if `governance-checker` returns `GO_NO_GO: no-go`.
13. Create PR to `{{BASE_BRANCH}}` only after `governance-checker` returns `GO_NO_GO: go`.
14. Governance no-go recovery is deterministic:

- run one initial `governance-checker` pass first
- if `GO_NO_GO: no-go`, execute at most `max_governance_retries` remediation cycles (default `2`)
- one remediation cycle = focused `plan-worker` fix -> `test-feedback` -> `governance-checker` re-run
- stop immediately on clean pass (`GO_NO_GO: go`)
- if still `no-go` after final allowed cycle, stop with no PR and report threshold breach details

15. Recovery loop for no-go and blocked tasks:

- no-go: keep todo in allowed status set, add `- 🔄 <task-id> no-go: <reason>`, rerun worker + test-feedback
- blocked: add `- ⛔ BLOCKED: <task-id> | reason: <blocker> | next: <unblock action>`
- failed: add `- ❌ FAILED: <task-id> | reason: <failure> | next: <recovery action>`
- threshold-breach report (no PR): include blocker reason, concise governance findings summary, and attempts used vs allowed

## Invocation payload

`@run-plan-autonomous plan=<PATH_TO_PLAN> start=<fresh|resume?> base=<{{BASE_BRANCH}}?> branch=<override?> max_parallel=<N?> max_governance_retries=<N?>`

If required fields are missing, ask one concise follow-up question.
