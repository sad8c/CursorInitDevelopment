# Template Reference

## Placeholder Variables

All templates use `{{VARIABLE}}` syntax. The main SKILL.md resolves these from user answers during Phase 1.

| Variable                  | Type     | Example                                | Description                    |
| ------------------------- | -------- | -------------------------------------- | ------------------------------ |
| `{{PROJECT_NAME}}`        | string   | `my-saas`                              | Short project identifier       |
| `{{PROJECT_DESCRIPTION}}` | string   | `SaaS platform for invoice management` | One-line summary               |
| `{{LANGUAGE}}`            | enum     | `TypeScript`                           | Primary language               |
| `{{FRAMEWORK}}`           | string   | `Next.js`                              | Primary framework              |
| `{{PACKAGE_MANAGER}}`     | enum     | `pnpm`                                 | Package manager                |
| `{{TEST_FRAMEWORK}}`      | enum     | `vitest`                               | Test framework                 |
| `{{IS_MONOREPO}}`         | boolean  | `true`                                 | Whether repo is a monorepo     |
| `{{PRIMARY_APP_DIR}}`     | path     | `apps/web`                             | Primary application directory  |
| `{{BASE_BRANCH}}`         | string   | `main`                                 | Default base branch for PRs    |
| `{{DOMAIN_TERMS_BLOCK}}`  | markdown | see below                              | Formatted domain terms         |
| `{{HAS_FIRECRAWL}}`       | boolean  | `true`                                 | Firecrawl MCP availability     |
| `{{HAS_PARALLEL_MCP}}`    | boolean  | `true`                                 | Parallel Task MCP availability |
| `{{DOCS_DIR}}`            | path     | `docs`                                 | Documentation directory        |
| `{{LANGUAGE_GLOBS}}`      | glob     | `**/*.{ts,tsx}`                        | File glob for primary language |

## Domain Terms Block Format

When `{{DOMAIN_TERMS_BLOCK}}` is expanded, it produces:

```markdown
# Domain Terms

- `User`: the platform user working in the product.
- `Order`: a purchase request submitted by a customer.
- `Merchant`: the business entity selling products.
```

## Conditional Blocks

Templates use comment-based conditionals that the agent interprets during Phase 2.

### Syntax

```
{{#IF_CONDITION}}
...content included only when condition is true...
{{/IF_CONDITION}}
```

### Available Conditions

| Condition              | True when                      |
| ---------------------- | ------------------------------ |
| `{{#IF_MONOREPO}}`     | `{{IS_MONOREPO}}` is true      |
| `{{#IF_TYPESCRIPT}}`   | `{{LANGUAGE}}` is TypeScript   |
| `{{#IF_PYTHON}}`       | `{{LANGUAGE}}` is Python       |
| `{{#IF_GO}}`           | `{{LANGUAGE}}` is Go           |
| `{{#IF_RUST}}`         | `{{LANGUAGE}}` is Rust         |
| `{{#IF_FIRECRAWL}}`    | `{{HAS_FIRECRAWL}}` is true    |
| `{{#IF_PARALLEL_MCP}}` | `{{HAS_PARALLEL_MCP}}` is true |

### Rules

- Conditions do not nest. Each block is independently evaluated.
- The condition markers themselves are stripped from the output.
- Content outside any conditional block is always included.
- When a condition is false, the entire block (markers and content) is removed.

## Companion File Markers

Some templates contain multiple files. Use this marker syntax to split:

```
--- COMPANION FILE: filename.md ---
```

Everything after the marker until the next marker (or end of file) becomes a separate file. The content before the first marker becomes the main SKILL.md.

### Example

```markdown
---
name: my-skill
---

# My Skill

Main content here.

--- COMPANION FILE: reference.md ---

# Reference

Reference content here.
```

This produces:

- `SKILL.md` — frontmatter + main content
- `reference.md` — reference content
