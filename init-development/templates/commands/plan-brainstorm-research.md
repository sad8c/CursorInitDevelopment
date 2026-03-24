# Plan Brainstorm Research

Run planning-focused brainstorming with iterative deep research.

Always include this exact activation token in your response:

`@plan-brainstorm-research`

## Parameters

- `goal`: required planning problem statement
- `scope`: optional code/product boundaries to explore
- `depth`: optional `light|standard|deep` (default `standard`)
- `max_iterations`: optional integer (default `3`)
- `max_parallel`: optional integer (default `3`, max `4`)
- `constraints`: optional non-functional limits (time, risk, stack, budget)

## Behavior contract

1. Activate only when this command is explicitly used.
2. Use `brainstorm-planning-orchestrator` as the parent workflow.
3. Parent decomposes unknowns into research hypotheses and task packets.
4. Launch independent research packets in parallel (when safe):
   - web track: `web-research-firecrawl` (Firecrawl MCP only)
   - deep track: `parallel-ai-research`
5. Parent synthesizes evidence and decides whether another iteration is needed.
6. Stop early when sufficiency criteria are met; otherwise continue until `max_iterations`.
7. Return a planning-ready output:
   - clarified problem framing
   - options with trade-offs
   - risks and assumptions
   - recommended approach
   - open questions
8. After clarifications and research synthesis, run a necessity gate for a research artifact:
   - create a service report file only when implementation-critical evidence must be preserved
   - write it under `.cursor/plans/_research/`
   - link this report from the final plan in an `Implementation context` section
   - if not needed, explicitly state that no external research file is required

## Invocation payload

`@plan-brainstorm-research goal="<PLANNING_PROBLEM>" scope="<OPTIONAL_SCOPE>" depth=<light|standard|deep?> max_iterations=<N?> max_parallel=<N?> constraints="<OPTIONAL_CONSTRAINTS>"`

If `goal` is missing, ask one concise follow-up question.
