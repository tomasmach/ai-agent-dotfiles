# Global Codex Instructions

## Commit Message Guidelines

Always follow these rules when creating git commits:

- **Use conventional commit prefixes**: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`, `style:`, `perf:`
- **Never add scopes** - do NOT use `feat(scope):` format, only use simple `feat:` format
- **Never modify or extend existing prefixes** - if a prefix exists, use it as-is without additions
- **Keep commits to a single line** - no multi-line commit messages
- **Be concise and descriptive** - explain what changed, not why
- **Use imperative mood** - "add feature" not "added feature"

Examples of correct format:
- `feat: add user authentication`
- `fix: resolve memory leak in cache`
- `refactor: simplify database query logic`
- `docs: update API documentation`
- `test: add unit tests for validation`
- `chore: update dependencies`

Examples of INCORRECT format (never use):
- `feat(AI-Search): add search`
- `fix(auth): resolve bug`
- `refactor(database): simplify query`

## Branch Naming

Use prefixes matching commit types: `feat/`, `fix/`, `refactor/`, `docs/`, `test/`, `chore/`. Examples:
- `feat/add-web-search`
- `fix/memory-leak`
- `refactor/simplify-router`

## Planning

Use the `html-plan` skill when I explicitly request `/html-plan` or directly ask for an HTML plan. You may also invoke it selectively for a genuinely large feature that spans multiple subsystems and requires architectural decisions, migrations, or staged implementation. Do not invoke it for routine planning, localized changes, fixes, ordinary refactors, or merely because a task has multiple steps. When invoked, follow the skill's instructions and keep the terminal reply to a short summary + file path.

## GitHub Operations

- Always use the local `gh` CLI for GitHub work. Do not use the GitHub MCP, GitHub API, or other remote GitHub integrations unless the user explicitly asks for them.

## Commit and Push Cadence

- Commit and push often when working in a git repository, especially after completing a coherent change or before switching tasks.

## Dependency Management

Always follow this rule when adding dependencies in any programming language:

- **Check for newest versions** - before adding any requirement, package, or dependency, always check for and use the newest available version

## Python Development Guidelines

Always follow these rules when working with Python:

- **Always use UV** - use UV for package management and virtual environment handling
- **Use Python 3.14** - ensure all Python projects use Python 3.14

## Subagent Usage

- **Only spawn subagents when the user explicitly asks you to.**
- Do not spawn subagents automatically, even when tasks could be parallelized.
