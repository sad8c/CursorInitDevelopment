---
name: parallel-ai-research
description: Runs deep external research through Parallel API for planning-stage decision support. Use when hypotheses need broader comparative analysis, synthesis across many candidates, or deeper iteration beyond standard web lookup.
---

# Parallel AI Research

This skill is research-only and returns evidence for parent synthesis.

## Required Environment

- `PARALLEL_API_KEY`

If missing, report blocked channel and suggest web-track compensations.

## Usage Boundaries

- Use for deep comparative exploration and structured alternatives analysis.
- Do not make final planning decisions in this skill.
- Keep outputs traceable for parent evidence map.

## Workflow

1. Receive packet objective and acceptance criteria.
2. Build concise Parallel API prompts around:
   - comparison dimensions
   - constraints
   - decision-critical unknowns
3. Execute deep research via MCP:
   - primary call: `user-Parallel Task MCP.createDeepResearch`
   - for list enrichment tasks: `user-Parallel Task MCP.createTaskGroup`
4. If status/results retrieval is requested, use:
   - `user-Parallel Task MCP.getStatus`
   - `user-Parallel Task MCP.getResultMarkdown`
5. Detect and mark weak or unsupported claims.
6. Return structured findings, including confidence and follow-up queries.

## Iteration Discipline

- default: max 2 rounds per packet
- run additional round only when:
  - critical ambiguity remains, or
  - claims conflict with web track evidence
- avoid repetitive reruns that do not reduce uncertainty
- follow tool-level server policy if it requires handing off with a task URL before polling

## Quality Gates

- claims must be specific, testable, and decision-relevant
- recommendations must include trade-offs
- assumptions must be explicit
- unresolved uncertainty must be marked, not hidden

## Output Contract

Return:

- packet outcome (`complete|partial|inconclusive`)
- key findings by decision criterion
- assumptions and caveats
- confidence per key claim (`high|medium|low`)
- targeted follow-up prompts (if needed)

## Reference

- Prompt scaffolds and confidence rubric: [reference.md](reference.md)

--- COMPANION FILE: reference.md ---

# Parallel AI Research Reference

## Packet Prompt Scaffold

```markdown
Objective: <what must be learned>
Context: <short planning context>
Constraints:

- <constraint 1>
- <constraint 2>
  Decision criteria:
- <criterion 1>
- <criterion 2>
  Output requirements:
- compare at least 2 options
- include trade-offs and failure modes
- flag assumptions and unknowns
```

## Confidence Rubric

- `high`: findings internally consistent and aligned with external corroboration
- `medium`: useful direction with notable assumptions
- `low`: speculative guidance requiring further validation

## Contradiction Handling

When findings conflict with web evidence:

1. mark claim as `contested`
2. request one targeted resolution query
3. return both interpretations and decision impact

## Minimal Result Schema

```markdown
packet_id: <id>
outcome: <complete|partial|inconclusive>
findings:

- criterion: <name>
  option: <A/B/...>
  claim: <summary>
  confidence: <high|medium|low>
  assumptions:
- <item>
  follow_up:
- <next prompt or "none">
```

## MCP Tool Mapping

- single-topic deep research: `user-Parallel Task MCP.createDeepResearch`
- multi-item enrichment: `user-Parallel Task MCP.createTaskGroup`
- task status check: `user-Parallel Task MCP.getStatus`
- markdown results retrieval: `user-Parallel Task MCP.getResultMarkdown`
