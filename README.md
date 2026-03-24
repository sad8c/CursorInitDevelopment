# InitDevelopment

Bootstrap a complete Cursor development workflow in any project. Sets up skills, agents, commands, rules, and documentation scaffolding adapted to your stack — all within the project workspace.

## What It Does

When invoked in a project, InitDevelopment creates a full suite of Cursor workflow artifacts directly in the project's `.cursor/` directory:

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

Everything is installed into the **project workspace** (`.cursor/skills/init-development/`). Nothing is placed in global `~/.cursor/`.

### Quick Install (curl)

Run from your **project root**:

```bash
curl -fsSL https://raw.githubusercontent.com/sad8c/CursorInitDevelopment/main/install.sh | bash
```

If you don't have SSH keys configured for GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/sad8c/CursorInitDevelopment/main/install.sh | CLONE_URL=https bash
```

### Manual Install

```bash
cd /path/to/your/project
git clone --depth 1 git@github.com:sad8c/CursorInitDevelopment.git /tmp/cursor-init-dev
mkdir -p .cursor/skills
cp -r /tmp/cursor-init-dev/init-development .cursor/skills/init-development
rm -rf /tmp/cursor-init-dev
```

## Usage

1. `cd` into your project root and run the install command above.
2. Open the project in Cursor.
3. Ask the agent: **"Initialize development workflow"**
4. Answer the discovery questions about your project (name, stack, structure, etc.)
5. The agent processes templates and writes all skills, agents, commands, and rules into the project's `.cursor/` directory.

### After Setup

- Review `.cursor/rules/project-context.mdc` and adjust domain terms.
- Review `.cursor/rules/repo-defaults.mdc` and adjust repo conventions.
- Create a plan: ask **"Create a plan for [feature]"**
- Run autonomous execution: use the `/run-plan-autonomous` command.
- Run brainstorm research: use the `/plan-brainstorm-research` command.

### What Gets Created

After running the workflow, your project will have this structure:

```
your-project/
├── .cursor/
│   ├── skills/
│   │   ├── init-development/        ← the bootstrapper (can be removed after setup)
│   │   ├── project-docs/
│   │   ├── planning-enrichment/
│   │   ├── plan-progress-sync/
│   │   ├── plan-autonomous-execution/
│   │   ├── testing-policy/
│   │   ├── knowledge-sync/
│   │   ├── brainstorm-planning-orchestrator/
│   │   ├── parallel-ai-research/    ← if Parallel Task MCP available
│   │   └── web-research-firecrawl/  ← if Firecrawl MCP available
│   ├── agents/
│   │   ├── governance-checker.md
│   │   ├── plan-worker.md
│   │   ├── test-feedback.md
│   │   ├── research-parallel-worker.md  ← if Parallel Task MCP available
│   │   └── research-web-worker.md       ← if Firecrawl MCP available
│   ├── commands/
│   │   ├── run-plan-autonomous.md
│   │   └── plan-brainstorm-research.md
│   └── rules/
│       ├── project-context.mdc
│       ├── repo-defaults.mdc
│       ├── code-quality.mdc
│       └── testing-policy.mdc
└── docs/   (or custom docs path)
    ├── INDEX.md
    └── governance-checklist.md
```

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

Remove the bootstrapper skill from the project:

```bash
rm -rf .cursor/skills/init-development
```

To remove all generated artifacts from the project:

```bash
rm -rf .cursor/skills .cursor/agents .cursor/commands .cursor/rules
```
