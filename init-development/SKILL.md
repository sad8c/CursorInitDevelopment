---
name: init-development
description: Bootstrap a complete Cursor development workflow (skills, agents, commands, rules, docs) in any project. Adapts proven planning, research, testing, and documentation patterns to the target project's stack and structure.
---

# InitDevelopment

This skill sets up a full Cursor development workflow in the current project. It creates skills, agents, commands, rules, and documentation scaffolding adapted to the project's technology stack.

## Activation

Run when the user asks to initialize, bootstrap, or set up the development workflow. Typical prompts:

- "Initialize development workflow"
- "Set up Cursor workflow"
- "Bootstrap project skills"

## Phase 1: Discovery

Use the AskQuestion tool to gather project information. Ask all questions in a single call.

### Questions

1. **Project name** — short identifier for the project
2. **Project description** — one-line summary of what the project does
3. **Primary language** — TypeScript / Python / Go / Rust / other
4. **Framework** — Next.js / FastAPI / Express / Gin / Axum / Django / Rails / other
5. **Package manager** — pnpm / npm / yarn / bun / pip / uv / cargo / go mod
6. **Test framework** — vitest / jest / pytest / go test / cargo test / other
7. **Repository structure** — monorepo (yes/no)
8. **Primary app directory** — e.g. `apps/myapp`, `src`, `.`
9. **Base branch** — main / dev / master / develop
10. **Domain terms** — 3-5 key domain entities and their meanings (comma-separated pairs like `User: platform user, Order: purchase request`)
11. **MCP: Firecrawl available?** — yes / no
12. **MCP: Parallel Task available?** — yes / no
13. **Existing docs folder** — path if exists, or "none"

### Variable Resolution

From the answers, derive these template variables:

| Variable                  | Source                                                                                              |
| ------------------------- | --------------------------------------------------------------------------------------------------- |
| `{{PROJECT_NAME}}`        | answer 1                                                                                            |
| `{{PROJECT_DESCRIPTION}}` | answer 2                                                                                            |
| `{{LANGUAGE}}`            | answer 3                                                                                            |
| `{{FRAMEWORK}}`           | answer 4                                                                                            |
| `{{PACKAGE_MANAGER}}`     | answer 5                                                                                            |
| `{{TEST_FRAMEWORK}}`      | answer 6                                                                                            |
| `{{IS_MONOREPO}}`         | answer 7 (true/false)                                                                               |
| `{{PRIMARY_APP_DIR}}`     | answer 8                                                                                            |
| `{{BASE_BRANCH}}`         | answer 9                                                                                            |
| `{{DOMAIN_TERMS_BLOCK}}`  | answer 10 formatted as definition list                                                              |
| `{{HAS_FIRECRAWL}}`       | answer 11 (true/false)                                                                              |
| `{{HAS_PARALLEL_MCP}}`    | answer 12 (true/false)                                                                              |
| `{{DOCS_DIR}}`            | answer 13, or `{{PRIMARY_APP_DIR}}/docs` if "none"                                                  |
| `{{LANGUAGE_GLOBS}}`      | derived: `**/*.{ts,tsx}` for TypeScript, `**/*.py` for Python, `**/*.go` for Go, `**/*.rs` for Rust |

## Phase 2: Template Processing

1. Read each template file from the `templates/` directory (relative to this SKILL.md).
2. Replace all `{{PLACEHOLDER}}` variables with resolved values.
3. Process conditional blocks:
   - `{{#IF_MONOREPO}}...{{/IF_MONOREPO}}` — include only when `{{IS_MONOREPO}}` is true
   - `{{#IF_TYPESCRIPT}}...{{/IF_TYPESCRIPT}}` — include only when `{{LANGUAGE}}` is TypeScript
   - `{{#IF_PYTHON}}...{{/IF_PYTHON}}` — include only when `{{LANGUAGE}}` is Python
   - `{{#IF_GO}}...{{/IF_GO}}` — include only when `{{LANGUAGE}}` is Go
   - `{{#IF_RUST}}...{{/IF_RUST}}` — include only when `{{LANGUAGE}}` is Rust
   - `{{#IF_FIRECRAWL}}...{{/IF_FIRECRAWL}}` — include only when Firecrawl MCP is available
   - `{{#IF_PARALLEL_MCP}}...{{/IF_PARALLEL_MCP}}` — include only when Parallel Task MCP is available
4. Remove conditional block markers from the output (keep or discard content based on condition).
5. For templates with `--- COMPANION FILE: <filename> ---` markers, split into separate files.

## Phase 3: File Generation

Write processed templates to the target project. File mapping:

### Skills

| Template                                        | Target                                              |
| ----------------------------------------------- | --------------------------------------------------- |
| `templates/skills/project-docs.md`              | `.cursor/skills/project-docs/SKILL.md`              |
| `templates/skills/planning-enrichment.md`       | `.cursor/skills/planning-enrichment/SKILL.md`       |
| `templates/skills/plan-progress-sync.md`        | `.cursor/skills/plan-progress-sync/SKILL.md`        |
| `templates/skills/plan-autonomous-execution.md` | `.cursor/skills/plan-autonomous-execution/SKILL.md` |
| `templates/skills/testing-policy.md`            | `.cursor/skills/testing-policy/SKILL.md`            |
| `templates/skills/knowledge-sync.md`            | `.cursor/skills/knowledge-sync/SKILL.md`            |

Conditional skills (only if MCP is available):

| Template                                               | Target                                                                       | Condition              |
| ------------------------------------------------------ | ---------------------------------------------------------------------------- | ---------------------- |
| `templates/skills/brainstorm-planning-orchestrator.md` | `.cursor/skills/brainstorm-planning-orchestrator/SKILL.md` + companion files | always                 |
| `templates/skills/parallel-ai-research.md`             | `.cursor/skills/parallel-ai-research/SKILL.md` + companion files             | `{{HAS_PARALLEL_MCP}}` |
| `templates/skills/web-research-firecrawl.md`           | `.cursor/skills/web-research-firecrawl/SKILL.md` + companion files           | `{{HAS_FIRECRAWL}}`    |

### Agents

| Template                                       | Target                                       | Condition              |
| ---------------------------------------------- | -------------------------------------------- | ---------------------- |
| `templates/agents/governance-checker.md`       | `.cursor/agents/governance-checker.md`       | always                 |
| `templates/agents/plan-worker.md`              | `.cursor/agents/plan-worker.md`              | always                 |
| `templates/agents/test-feedback.md`            | `.cursor/agents/test-feedback.md`            | always                 |
| `templates/agents/research-parallel-worker.md` | `.cursor/agents/research-parallel-worker.md` | `{{HAS_PARALLEL_MCP}}` |
| `templates/agents/research-web-worker.md`      | `.cursor/agents/research-web-worker.md`      | `{{HAS_FIRECRAWL}}`    |

### Commands

| Template                                         | Target                                         |
| ------------------------------------------------ | ---------------------------------------------- |
| `templates/commands/run-plan-autonomous.md`      | `.cursor/commands/run-plan-autonomous.md`      |
| `templates/commands/plan-brainstorm-research.md` | `.cursor/commands/plan-brainstorm-research.md` |

### Rules

| Template                              | Target                              |
| ------------------------------------- | ----------------------------------- |
| `templates/rules/project-context.mdc` | `.cursor/rules/project-context.mdc` |
| `templates/rules/repo-defaults.mdc`   | `.cursor/rules/repo-defaults.mdc`   |
| `templates/rules/code-quality.mdc`    | `.cursor/rules/code-quality.mdc`    |
| `templates/rules/testing-policy.mdc`  | `.cursor/rules/testing-policy.mdc`  |

### Docs

| Template                                 | Target                                 |
| ---------------------------------------- | -------------------------------------- |
| `templates/docs/INDEX.md`                | `{{DOCS_DIR}}/INDEX.md`                |
| `templates/docs/governance-checklist.md` | `{{DOCS_DIR}}/governance-checklist.md` |

## Phase 4: Summary

After all files are written, print a summary:

```
## InitDevelopment Setup Complete

### Skills installed (N)
- skill-name — brief description

### Agents installed (N)
- agent-name — brief description

### Commands installed (N)
- command-name — brief description

### Rules installed (N)
- rule-name — brief description

### Docs scaffolding
- path/to/INDEX.md
- path/to/governance-checklist.md

### Skipped (reason)
- item — reason (e.g., "MCP not available")

### Next steps
1. Review `.cursor/rules/project-context.mdc` and adjust domain terms
2. Review `.cursor/rules/repo-defaults.mdc` and adjust repo conventions
3. Start a plan: ask "Create a plan for [feature]"
4. Run autonomous execution: use `/run-plan-autonomous`
```

## Template Syntax Reference

See [reference.md](reference.md) for the full placeholder variable catalog and conditional block syntax.
