---
name: verify
description: Verify any change end-to-end in the real running app before declaring it done — exercise the affected flow, not just tests or typecheck.
---

# Verifying changes

Never report a change as complete based on a successful edit, passing typecheck, or passing tests alone. Verify it the way a human reviewer would: run the affected flow and observe the behavior.

## 1. Discover how this project is checked

Before inventing commands, read what the repo already documents, in this order:

1. `AGENTS.md` / `CLAUDE.md` — many repos list **verified commands** (exact CI order, docker invocations, focused test commands). Trust these over habit.
2. `package.json` scripts, `composer.json` scripts, `Makefile`, `justfile`.
3. CI config (`.github/workflows/*`) — whatever CI runs is the ground truth for "passing".

Run the project's own typecheck, lint, and tests — scoped to the change where possible, full suite when the change is risky or cross-cutting.

## 2. Exercise the real flow, per project type

- **Web app:** find the running dev server first — probe documented ports before starting anything; **never start a second dev server** if one is running (it can hijack queue workers, watchers, or ports). Open the affected page in the browser (Playwright or Chrome tools), interact with the change directly — click the new control, submit the form, confirm the state change — and screenshot before/after.
- **Check whether the app serves compiled assets.** If there is no hot-reload proxy, rebuild (e.g. `vite build`) before verifying, or you will be looking at the old code and conclude "my change didn't apply".
- **Backend / API:** hit the real endpoint (curl or the app UI that calls it) with a realistic payload, and read the app log for new errors while doing it. A passing unit test is not a verified endpoint.
- **Mobile (Expo / React Native):** run it in the simulator; delegate to `codex-computer-use` when driving the simulator is needed.
- **CLI / script:** run it on realistic input and check the output and exit code.

## 3. Observe, don't assume

- Browser console: zero **new** errors or warnings after your interaction.
- App/server logs: no new exceptions triggered by the flow.
- If the change is visual, look at the screenshot yourself — layout breaks don't throw.

## 4. Auth-gated apps

Never type real passwords into login forms. Prefer the project's documented test-login mechanism (seeded test user, session/cookie mint, auth bypass for local). If none exists and you are blocked, ask the user to log in once rather than guessing credentials.

## 5. On failure, loop

If any step fails, fix the issue and rerun from step 1. Do not hand back partially verified work, and report honestly what was and wasn't verified — if a step was skipped (no simulator, no running server), say so explicitly.
