---
name: web-research-firecrawl
description: Executes focused web research for planning decisions using Firecrawl MCP for discovery, scraping, and extraction. Use when collecting source-backed facts, validating claims, or comparing external approaches during brainstorming and planning.
---

# Web Research (Firecrawl)

This skill is research-only. It does not decide final plan direction.

## Use Cases

- discover external references quickly
- extract reliable page content for evidence
- validate or falsify planning hypotheses
- compare ecosystem options and implementation patterns

## Required Environment

- `FIRECRAWL_API_KEY`

If the key is missing, use built-in web search/fetch and record reduced confidence.

## Workflow

1. Convert hypothesis into focused search queries.
2. Use Firecrawl MCP discovery first:
   - call `user-firecrawl.firecrawl_search` for source discovery
   - prioritize official docs, standards, maintainer sources
   - limit noisy aggregator content
3. For shortlisted URLs, use Firecrawl content retrieval:
   - call `user-firecrawl.firecrawl_scrape` for page content
   - use `user-firecrawl.firecrawl_extract` only for structured fields when needed
   - keep only relevant fragments
4. Build claim-level evidence with confidence.
5. Return concise findings to parent orchestrator.

## Source Quality Rules

- prefer primary sources over reposts
- avoid single-source conclusions for high-impact claims
- note publication date when freshness matters
- flag contradictory sources explicitly

## Output Contract

Return:

- findings per hypothesis
- evidence map (source URL + key excerpt summary)
- confidence per claim (`high|medium|low`)
- unresolved gaps and suggested next queries

## Reference

- Query templates, MCP usage, quality gates, and fallback matrix: [reference.md](reference.md)

--- COMPANION FILE: reference.md ---

# Web Research Reference

## Query Template

```text
<topic> <target_technology_or_domain> best practices official docs architecture trade-offs
```

## Firecrawl Search Heuristics

- first pass: 4-6 broad queries
- second pass: 2-4 targeted contradiction queries
- third pass (optional): close critical evidence gaps

## MCP Tool Usage

- discovery: `user-firecrawl.firecrawl_search`
- page content: `user-firecrawl.firecrawl_scrape`
- structured fields: `user-firecrawl.firecrawl_extract` (only when schema output is needed)

## Firecrawl Extraction Rules

- extract only pages shortlisted from Firecrawl search
- keep snippets that directly support/refute claims
- discard marketing-only sections with no technical substance

## Evidence Item Schema

```markdown
- hypothesis: <id or short text>
  claim: <specific statement>
  status: <supported|contradicted|inconclusive>
  confidence: <high|medium|low>
  sources:
  - url: <https://...>
    reason: <why credible/relevant>
```

## Fallback Matrix

- Firecrawl unavailable -> use built-in web tools
- MCP call failures -> retry once with narrower queries
- persistent failures -> report constraint and return tentative findings only
