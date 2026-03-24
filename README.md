# InitDevelopment

Bootstrap a complete Cursor development workflow in any project. Sets up skills, agents, commands, rules, and documentation scaffolding adapted to your stack.

## What It Does

When invoked in a project, InitDevelopment creates a full suite of Cursor workflow artifacts:

| Category     | Count   | Description                                                      |
| ------------ | ------- | ---------------------------------------------------------------- |
| **Skills**   | up to 9 | Planning, execution, testing, docs, research, knowledge sync     |
| **Agents**   | up to 5 | Plan worker, test feedback, governance checker, research workers |
| **Commands** | 2       | Autonomous plan execution, brainstorm research                   |
| **Rules**    | 4       | Project context, repo defaults, code quality, testing policy     |
| **Docs**     | 2       | Documentation index, governance checklist                        |

### Skills Installed

| Skill                              | Description                                                |
| ---------------------------------- | ---------------------------------------------------------- |
| `project-docs`                     | Documentation management with read/write/sync modes        |
| `planning-enrichment`              | Execution-ready plan building with task decomposition      |
| `plan-progress-sync`               | Real-time plan file synchronization during execution       |
| `plan-autonomous-execution`        | Full autonomous plan orchestration with subagents          |
| `testing-policy`                   | Stack-specific testing expectations and patterns           |
| `knowledge-sync`                   | Post-change consistency verification for docs/rules/skills |
| `brainstorm-planning-orchestrator` | Evidence-driven research for planning decisions            |
| `parallel-ai-research`\*           | Deep comparative analysis via Parallel API                 |
| `web-research-firecrawl`\*         | Web source discovery and extraction via Firecrawl          |

\* Requires corresponding MCP server; skipped if unavailable.

### Supported Languages

- TypeScript (Next.js, Express, etc.)
- Python (FastAPI, Django, etc.)
- Go (Gin, Echo, etc.)
- Rust (Axum, Actix, etc.)

## Installation

### Quick Install (curl)

```bash
curl -fsSL https://raw.githubusercontent.com/sad8c/CursorInitDevelopment/main/install.sh | bash
```

If you don't have SSH keys configured for GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/sad8c/CursorInitDevelopment/main/install.sh | CLONE_URL=https bash
```

### Manual Install

```bash
git clone --depth 1 git@github.com:sad8c/CursorInitDevelopment.git /tmp/cursor-init-dev
mkdir -p ~/.cursor/skills
cp -r /tmp/cursor-init-dev/init-development ~/.cursor/skills/init-development
rm -rf /tmp/cursor-init-dev
```

## Usage

1. Open your project in Cursor.
2. Ask the agent: **"Initialize development workflow"**
3. Answer the discovery questions about your project (name, stack, structure, etc.)
4. The agent processes templates and writes all files to your project.

### After Setup

- Review `.cursor/rules/project-context.mdc` and adjust domain terms.
- Review `.cursor/rules/repo-defaults.mdc` and adjust repo conventions.
- Create a plan: ask **"Create a plan for [feature]"**
- Run autonomous execution: use the `/run-plan-autonomous` command.
- Run brainstorm research: use the `/plan-brainstorm-research` command.

## Configuration

The skill asks discovery questions and adapts templates using placeholders. Key configuration points:

| Setting            | Effect                                                   |
| ------------------ | -------------------------------------------------------- |
| Language/Framework | Determines code quality rules and testing patterns       |
| Monorepo structure | Adjusts repo defaults and primary app directory handling |
| Base branch        | Sets default branch for PRs and autonomous execution     |
| MCP availability   | Controls whether research skills/agents are installed    |
| Docs directory     | Sets where documentation scaffolding is placed           |

## Uninstall

Remove the skill:

```bash
rm -rf ~/.cursor/skills/init-development
```

To remove generated files from a project, delete the corresponding entries in `.cursor/skills/`, `.cursor/agents/`, `.cursor/commands/`, `.cursor/rules/`, and the docs directory.
