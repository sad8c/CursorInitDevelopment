---
name: knowledge-sync
description: 'Verify and update project knowledge artifacts after contract-level changes. Triggers after architecture, API contract, data model, or shared convention changes to keep docs, rules, and skills aligned with code.'
---

# Knowledge Sync

This skill ensures that project knowledge artifacts (docs, rules, skills) stay aligned with the codebase after significant changes.

## When to Trigger

Activate this skill after any of these change types:

- **Architecture changes**: new subsystems, major structural refactors, dependency changes
- **API contract changes**: new/removed/renamed endpoints, request/response schema changes
- **Data model changes**: schema migrations, entity additions/removals, relation changes
- **Shared convention changes**: auth patterns, error handling, naming conventions, configuration
- **Pipeline/workflow changes**: build process, CI/CD, deployment, background job contracts

Do NOT trigger for:

- Minor implementation edits within existing contracts
- UI-only changes that don't alter data flow or API surface
- Bug fixes that don't change contracts or behavior expectations
- Dependency version bumps without API changes

## Knowledge Sync Map

Use this mapping to decide what to verify after code changes. Adapt this map to your project's subsystems.

| Subsystem                | Check docs                        | Check rules             | Check skills             |
| ------------------------ | --------------------------------- | ----------------------- | ------------------------ |
| Auth / API ownership     | auth docs, API reference          | auth-related rules      | auth-related skills      |
| Data model / schema      | data model docs                   | migration rules         | none by default          |
| External integrations    | integration docs                  | provider-specific rules | provider-specific skills |
| Testing contracts        | testing docs                      | testing rules           | testing-policy           |
| Build / deploy pipeline  | deployment docs                   | CI-related rules        | none by default          |
| Product / domain meaning | domain glossary, product overview | project-context rule    | none by default          |

## Sync Workflow

1. **Identify** the subsystem that changed using the Knowledge Sync Map.
2. **Read** the relevant docs from `{{DOCS_DIR}}/INDEX.md`.
3. **Check** whether related `.cursor/rules/` entries still match the code.
4. **Check** whether related `.cursor/skills/` entries still match the code.
5. **Update** only the affected knowledge artifacts.
6. **Leave** unrelated docs, rules, and skills untouched.

## Update Rules

- Keep Source-of-Truth layering: **rules** = guardrails, **skills** = workflows, **docs** = detailed reference.
- When a conflict exists between artifacts, update in this priority order: rules first (guardrails), then skills (workflow), then docs (reference).
- Only update artifacts that are directly affected by the change.
- Do not create new docs/rules/skills unless the change introduces a genuinely new subsystem.
- After updating, verify cross-references between artifacts are still valid.

## Output

When triggered, report:

```
**Knowledge Sync Report:**
- Subsystem: <what changed>
- Docs checked: <list of docs reviewed>
- Rules checked: <list of rules reviewed>
- Skills checked: <list of skills reviewed>
- Updates made:
  - <artifact path>: <what was updated and why>
- No updates needed: <list of artifacts that were checked and found current>
```

Keep the report concise. Only list artifacts that were actually checked.
