---
name: brainstorm-planning-orchestrator
description: Orchestrates planning-stage brainstorming with iterative, evidence-driven research loops. Use when the user asks to explore solution options, reduce uncertainty before planning, or explicitly invokes @plan-brainstorm-research.
---

# Brainstorm Planning Orchestrator

Use this skill only for planning-stage exploration and option design.

## Activation

- Run when the user explicitly invokes `@plan-brainstorm-research`.
- Do not auto-apply by default in normal planning.

## Role Boundaries

- This orchestrator defines hypotheses, launches research tracks, and synthesizes findings.
- It does not perform deep raw research itself when specialized tracks are available.
- It delegates:
  - web/source discovery to `web-research-firecrawl`
  - deep comparative investigation to `parallel-ai-research`

## Inputs

- planning goal
- scope boundaries
- constraints (time/risk/stack)
- desired depth (`light|standard|deep`)
- limits (`max_iterations`, `max_parallel`)
- final plan destination/path (when known)

## Iterative Workflow

1. Frame the planning question into:
   - decision targets
   - critical unknowns
   - success criteria
2. Build a hypothesis list with confidence tags (`low|medium|high`).
3. Create independent research packets from unknowns.
4. Launch packet execution in parallel (max 4 subagents).
5. Synthesize evidence from all tracks, deduplicate claims, and score confidence.
6. Run sufficiency gate:
   - continue if critical unknowns remain or evidence conflicts
   - stop if planning-quality evidence is sufficient
7. If continuing, refine packets and run next iteration.
8. Run `research_artifact_needed` decision gate.
9. If needed, generate a service research report file under `plans` before finalizing the plan.
10. Produce final planning bundle and include a link to the report when created.

## Sufficiency Gate

Treat evidence as sufficient only when all are true:

- all critical unknowns are either resolved or explicitly bounded
- high-impact claims have source-backed evidence
- at least two viable implementation options exist with trade-offs
- top risks have mitigation paths

## Research Artifact Decision Gate

Create a research artifact only when it materially reduces implementation risk.

Set `research_artifact_needed=true` if any are true:

- implementation depends on external API/SDK/service constraints that must be source-backed
- there are 2+ viable architecture paths with non-trivial trade-offs that must be preserved
- implementation requires concrete patterns/examples from references to avoid re-discovery
- high-risk assumptions remain and need explicit evidence and boundaries for execution

Set `research_artifact_needed=false` when all are true:

- recommendation is straightforward and does not depend on fragile external facts
- no critical external contract details are needed during implementation
- evidence can be fully captured in concise in-plan bullets without losing fidelity

When `research_artifact_needed=false`, explicitly state that no external research file is required.

## Parallelization Rules

- Launch tracks in parallel only when they target different unknowns.
- Avoid duplicate packets against the same source set.
- Use staged fan-out:
  - iteration 1: broad coverage
  - iteration 2+: targeted validation or contradiction checks
- Launch research workers as sibling subagents (up to 4):
  - web packets via `generalPurpose`/`explore` with `web-research-firecrawl` instructions
  - deep packets via `generalPurpose` with `parallel-ai-research` instructions
- Parent orchestrator is responsible for deciding whether to launch additional rounds.

## Failure and Fallback Rules

- Missing `PARALLEL_API_KEY`: skip deep track, record limitation, and expand web validation.
- Missing `FIRECRAWL_API_KEY`: use built-in web tools and reduce source breadth.
- If tool/service errors persist, continue with available channels and downgrade confidence.

## Artifact Timing and Placement

- Ask required clarifying questions first.
- Run research and synthesis loops next.
- Apply the `research_artifact_needed` gate after synthesis and before writing the final plan.
- If needed, write the report to a service path under plans:
  - `.cursor/plans/_research/<plan-slug>_<date-or-hash>.research.md`
- Keep the file focused on implementation-critical facts only.

## Output Contract

Return one concise report in this structure:

1. Problem framing
2. Decision criteria
3. Options (A/B/...)
4. Trade-offs
5. Recommended path
6. Risks and mitigations
7. Open questions
8. Evidence map (claim -> sources -> confidence)
9. Research artifact decision:
   - `research_artifact_needed: true|false`
   - `reason: <one sentence>`
   - `path: <report path or none>`
10. Plan linkage:

- if report exists, include a plan section that links to it as implementation context

## Reference

- Detailed packet templates and scoring: [reference.md](reference.md)
- Unified output and evidence schema: [output-contract.md](output-contract.md)

--- COMPANION FILE: reference.md ---

# Orchestrator Reference

## Research Packet Template

Use one packet per independent unknown.

```markdown
packet_id: <short-id>
objective: <what must be learned>
why_it_matters: <planning impact>
track: <web|parallel|both>
queries:

- <query 1>
- <query 2>
  acceptance:
- [ ] <evidence condition 1>
- [ ] <evidence condition 2>
```

## Iteration Policy

- `light`: 1-2 iterations, prefer web-first
- `standard`: 2-3 iterations, balanced web + parallel
- `deep`: 3-5 iterations, explicit contradiction checks each round

## Confidence Scoring

Score each key claim:

- `high`: 2+ independent credible sources and no unresolved conflict
- `medium`: partial support with minor gaps
- `low`: weak or single-source support

## Evidence Map Format

```markdown
- claim: <statement>
  confidence: <high|medium|low>
  sources:
  - <url or provider result id>
    notes: <why this confidence was assigned>
```

## Stop Conditions

- stop when sufficiency gate passes
- stop when `max_iterations` reached
- stop early if additional iterations only repeat evidence without reducing uncertainty

## Research Artifact Path Convention

When the orchestrator decides `research_artifact_needed=true`, write one service file:

- directory: `.cursor/plans/_research/`
- filename: `<plan-slug>_<yyyymmdd>_<short-hash>.research.md`
- examples:
  - `proposal-routing_20260315_a1b2c3d4.research.md`
  - `auth-integration_20260315_f93d120a.research.md`

`plan-slug` should be stable and derived from the planning goal.

## Selection Policy (Material Facts Only)

Include only information that is likely needed later during implementation:

- external API/SDK/service constraints with direct coding impact
- architecture comparisons that affect chosen implementation shape
- validated solution patterns/examples to replicate or adapt
- risks, limits, and assumptions that must be checked in code/tests

Exclude:

- full search logs and raw query dumps
- duplicated claims with no new evidence
- broad background context that does not alter implementation decisions

## Plan Linkage Snippet

When a report is created, add an implementation context section in the final plan:

```markdown
## Implementation context

- Research brief: [<short title>](.cursor/plans/_research/<file>.research.md)
- Use this brief to validate external contracts and implementation checklist items while executing tasks.
```

When no report is needed:

```markdown
## Implementation context

- Research brief: not required for this plan (all critical constraints captured inline).
```

--- COMPANION FILE: output-contract.md ---

# Planning Brainstorm Output Contract

## Final Response Schema

```markdown
## Problem framing

- <what exactly is being solved>

## Decision criteria

- <criterion>

## Options

- option: <name>
  summary: <approach>
  strengths:
  - <item>
    weaknesses:
  - <item>

## Trade-offs

- <comparison statement>

## Recommendation

- <chosen direction and why>

## Risks and mitigations

- risk: <item>
  mitigation: <item>

## Open questions

- <unknown that still matters>

## Evidence map

- claim: <statement>
  confidence: <high|medium|low>
  sources:
  - <url or source id>

## Research artifact decision

- research_artifact_needed: <true|false>
- reason: <one sentence>
- path: <.cursor/plans/\_research/...research.md or none>

## Implementation context

- research_report: <markdown link to report if created, otherwise "not required">
- usage_note: <how this report should be used during implementation>
```

## Research Artifact File Schema

When `research_artifact_needed=true`, write a dedicated file using this structure:

```markdown
# Research Implementation Brief

## Planning context

- goal: <planning goal>
- scope: <boundaries>
- generated_at: <ISO date or date+time>

## Material facts and constraints

- fact: <implementation-relevant statement>
  source: <url/source id>
  confidence: <high|medium|low>
  implementation_impact: <why it matters in code>

## External contracts to respect

- service_or_api: <name>
  required_rules:
  - <rule>
    failure_modes:
  - <risk if ignored>

## Applicable solution patterns

- pattern: <name>
  when_to_apply: <condition>
  source: <url/source id>
  adaptation_notes:
  - <repo-specific note>

## Architecture implications

- decision_area: <component/integration>
  recommendation: <selected direction>
  tradeoff_notes:
  - <constraint or compromise>

## Implementation checklist

- [ ] <must-have constraint to verify in code>
- [ ] <test/validation requirement from evidence>

## Source index

- id: <source id>
  link: <url>
  note: <credibility or freshness remark>
```

## Evidence Normalization Rules

- each claim must map to at least one source
- low-confidence claims cannot be used as sole basis for recommendation
- contested claims must include both interpretations
- stale/undated sources must be marked in notes

## Artifact Curation Rules

- include only material facts that affect implementation choices, correctness, or risk
- do not copy full research logs, prompt transcripts, or repetitive notes
- prefer compact, source-backed statements over long narrative text
- each checklist item should trace back to at least one cited fact or contract
