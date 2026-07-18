# Global Claude Code Instructions

## Commit Message Guidelines

- Use conventional prefixes (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`, `style:`, `perf:`), never scoped (`feat(scope):`)
- Single line, imperative mood: `feat: add user authentication`

## Tech Stack Preferences

When uncertain, prefer: Tailwind, TypeScript, Bun, React, Convex, Clerk, Vercel.

## Code Style

- Always strive for concise, simple solutions.
- If a problem can be solved in a simpler way, propose it.

## Planning

Invoke the `html-plan` skill when I explicitly request `/html-plan` or directly ask for an HTML plan. You may also invoke it selectively for a genuinely large feature that spans multiple subsystems and requires architectural decisions, migrations, or staged implementation. Do not invoke it for routine planning, localized changes, fixes, ordinary refactors, or merely because a task has multiple steps. When invoked, follow the skill's instructions and keep the terminal reply to a short summary + file path.

## Branch Naming

Use prefixes matching commit types: `feat/`, `fix/`, `refactor/`, `docs/`, `test/`, `chore/`. Examples:
- `feat/add-web-search`
- `fix/memory-leak`
- `refactor/simplify-router`

## Dependency Management

Always follow this rule when adding dependencies in any programming language:

- **Check for newest versions** - before adding any requirement, package, or dependency, always check for and use the newest available version

## Python Development Guidelines

Always follow these rules when working with Python:

- **Always use UV** - use UV for package management and virtual environment handling
- **Use Python 3.14** - ensure all Python projects use Python 3.14

## Parallel Agent Usage

Always leverage parallel agents for better context management:

- **Use multiple agents simultaneously** - When facing 2+ independent tasks without shared state, deploy parallel agents instead of sequential execution
- **Maximize parallelization** - Independent operations (codebase exploration, multiple file reads, parallel testing) should run concurrently in a single message
- **Reduce context overhead** - Parallel execution avoids repeating context between sequential tasks and improves efficiency
- **Use appropriate agent types** - Combine specialized agents (Explore, Plan, test-runner, etc.) in parallel based on their independence

## General Preferences

- If asked to do too much work at once, stop and state that clearly.
- If computer use is helpful for completing or verifying work, shell out to gpt-5.6-sol with Codex for it (see "Picking the right models" below for how).

## Picking the right models for workflows and subagents

Rankings, higher = better. Cost reflects what I actually pay (OpenAI has really generous limits), not list price. Intelligence is how hard a problem you can hand the model unsupervised. Taste covers UI/UX, code quality, API design, and copy.

| model       | cost | intelligence | taste |
|-------------|------|--------------|-------|
| gpt-5.6-sol | 7    | 9            | 7     |
| sonnet-5    | 5    | 5            | 7     |
| opus-4.8    | 4    | 7            | 8     |
| fable-5     | 2    | 9            | 9     |

How to apply:
- These are defaults, not limits. You have standing permission to override them: if a cheaper model's output doesn't meet the bar, rerun or redo the work with a smarter model without asking. Judge the output, not the price tag. Escalating costs less than shipping mediocre work.
- Cost is a tie-breaker only; when axes conflict for anything that ships, intelligence > taste > cost.
- **Backend implementation: strongly prefer Codex (gpt-5.6-sol).** Route handlers, database/schema work, server logic, scripts, migrations, data processing, CLI tools — anything without a user-facing UI surface — should go through `codex exec` by default, even for small stuff. Don't quietly do it yourself in Sonnet/Opus/Fable just because it's "easy enough." The bar to skip Codex here is higher than for other task types, but the override rule above still applies (e.g. it needs a live Claude subagent loop, or Codex already failed on it).
- **Reading and investigation: also default to Codex.** Reading code, grepping logs, tracing a bug, exploring an unfamiliar codebase — run `codex exec -s read-only` instead of doing it inline. It's cheap and keeps raw file/log reading off Claude's context.
- Bulk/mechanical work (clear-spec implementation, data analysis): gpt-5.6-sol on low reasoning effort — still the cheap default, and Sol is strong even on low.
- Taste calls are the exception: UI, copy, and the *shape* of an API's public interface (naming, structure, what feels good to callers) need taste ≥ 7. This is a design-judgment call, separate from implementing the backend behind it — Codex can build the route once the interface is decided, it just shouldn't be the one deciding what that interface looks like.
- Reviews of plans/implementations: fable-5 or opus-4.8, optionally gpt-5.6-sol as an extra independent perspective.
- **Never use Haiku — no exceptions, cost pressure included.**
- Mechanics: gpt-5.6-sol is only reachable through the Codex CLI — `codex exec` / `codex review` (my ~/.codex/config.toml defaults to gpt-5.6-sol). Use the codex-implementation, codex-review, and codex-computer-use skills for their respective flows.
- Codex reasoning effort: pick it per run with `-c model_reasoning_effort="<level>"`. Default medium; drop to low for mechanical/clear-spec work (Sol is very good even on low); high only for genuinely hard problems. Never go above high (no xhigh) — and since config.toml defaults to high, always pass the flag explicitly.
- Claude models (sonnet-5, opus-4.8, fable-5) run via the Agent/Workflow model parameter.

Using gpt-5.6-sol inside workflows and subagents (the model parameter only takes Claude models, so use a wrapper):
- Spawn a thin Claude wrapper agent with `model: 'sonnet', effort: 'low'` whose prompt instructs it to write a self-contained codex prompt, run `codex exec` via Bash, and return codex's raw output verbatim as its final message. Keep the wrapper dumb — it does no reasoning of its own, it just shuttles the prompt to codex and the answer back, so gpt-5.6-sol does the actual work while the Agent/Workflow `model` parameter stays satisfied with a Claude model.
- Give the wrapper everything codex needs in the prompt itself (codex has no access to the workflow's context), and have it fail loudly — return the error text — if `codex exec` is missing or errors, rather than silently substituting its own answer.
- Use `schema` on the wrapper to get structured output back.
- Always label these agents with a `gpt-5.6-sol:` prefix, e.g. `{label: 'gpt-5.6-sol:review-auth'}` — the workflow UI shows the wrapper's Claude model, so the label is the only indication the real worker is gpt-5.6-sol.
- Codex runs can exceed Bash's 10-minute timeout: pass an explicit timeout, or run in the background and poll for the report file.
- Parallel gpt-5.6-sol implementation agents must use `isolation: 'worktree'` so codex edits don't collide in the shared checkout.
- Workflow token budgets only count Claude tokens; codex work is free and invisible to `budget.spent()`.

## Error Policy

Always fix any errors you encounter during work - tests, lint, build, or runtime - even if they are pre-existing and unrelated to the current task. Never leave known broken tests or errors behind.
