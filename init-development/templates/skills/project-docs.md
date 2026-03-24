---
name: project-docs
description: 'Read, update, and sync focused technical knowledge in `{{DOCS_DIR}}`. Use when a task needs architectural context, pipeline details, API behavior, data-model guidance, explicit documentation changes, or a consistency check between code, docs, rules, and project skills.'
---

# Project Documentation Manager

This skill manages technical documentation in `{{DOCS_DIR}}` and helps keep related project knowledge artifacts aligned with the codebase.

## Three Modes of Operation

### Mode 1: Read (Context Gathering)

**When**: Before starting any non-trivial task, or when you need to understand how a subsystem works.

1. Read `{{DOCS_DIR}}/INDEX.md` first.
2. Use it as the source of truth for available documentation.
3. Read only the docs relevant to the current task.
4. Extract only the facts needed for the task: entities, API contracts, data flows, and constraints.

**Rules**:

- Don't dump entire docs into context — extract only what's needed
- If INDEX.md doesn't exist, scan `{{DOCS_DIR}}/` directory
- Cross-reference docs with actual code when accuracy is critical
- Do not maintain a duplicate doc inventory inside this skill

### Mode 2: Write (Generate / Update)

**When**: User explicitly asks to generate or update docs, or after significant architectural changes.

1. Analyze the codebase area to document
2. Write/update the relevant doc file in `{{DOCS_DIR}}/`
3. Update `{{DOCS_DIR}}/INDEX.md` when docs are added, removed, renamed, or materially reframed
4. Respect `.cursor/rules/repo-defaults.mdc`: do not update docs unless requested or explicitly in scope.
5. Exception: when the task is explicitly about contract alignment/knowledge sync, update only the affected docs/rules/skills artifacts.

### Mode 3: Knowledge Sync

**When**: Code changes may have invalidated project knowledge, especially docs, scoped rules, or project skills tied to a subsystem.

1. Identify the subsystem that changed.
2. Read the relevant docs from `{{DOCS_DIR}}/INDEX.md`.
3. Check whether related `.cursor/rules/` and `.cursor/skills/` still match the code.
4. Update only the affected knowledge artifacts.
5. Leave unrelated docs, rules, and skills untouched.

**Do this for contract changes**, not every local implementation edit.

## Documentation Standards

### Language

- Write entirely in English

### Structure of Each Doc File

```markdown
# [Feature/System Name]

## Overview

[1-3 sentences: what it is, what it does]

## Architecture / Key Entities

[Models, relations, key types — only what matters]

## Process / Pipeline

[Step-by-step flow with file references]

## API

[Endpoints with method, path, body, response — table or list format]

## Important Details

[Constraints, edge cases, gotchas, config]
```

### Style Rules

- **No filler text**. Every sentence must carry information.
- **No obvious explanations**. Don't explain what REST is or how standard framework routing works.
- **File references are mandatory**. Every described behavior must link to the source file.
- **Tables over prose** for structured data (API contracts, field mappings, entity relations).
- **Code blocks** only for non-obvious structures, schemas, or sequences.
- **Max 200 lines** per doc file. If longer — split into focused docs.
- Omit sections that have nothing meaningful to say.

## When to Update Docs

After completing a task, evaluate: "Did I change architecture, add API endpoints, modify data models, or alter a pipeline?" If yes, update docs only when docs work is requested or explicitly in scope.

For explicit contract alignment or knowledge-sync tasks, treat targeted docs updates as in-scope work.

Do NOT:

- Create docs for minor UI changes
- Document obvious CRUD operations
- Duplicate information already in code comments
- Write aspirational/planned features — only document what exists

## Extracting Context for Tasks

When reading docs to support a task, return a focused brief:

```
**Relevant context from docs:**
- [fact 1 relevant to the task]
- [fact 2 relevant to the task]
- Key files: `path/to/file.ts`, `path/to/other.ts`
- API: `POST /api/endpoint` — does X
- Constraint: [important limitation or gotcha]
```

Keep it under 10 bullet points. The orchestrator agent doesn't need the full doc — just the actionable facts.
