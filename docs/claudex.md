# Claudex profile

Claudex is a second Claude Code profile:

- configuration: `~/.claudex`
- API base URL: `http://127.0.0.1:8317`
- model: `gpt-5.6-sol`
- credentials: `~/.config/claudex/env` (untracked, mode `0600`)

Create the credential file from the example:

```bash
mkdir -p ~/.config/claudex
cp shell/claudex.env.example ~/.config/claudex/env
chmod 600 ~/.config/claudex/env
```

Set a real local proxy token, install the repository, start CLIProxyAPI, then verify:

```bash
claudex -p 'Reply with exactly CLAUDEX_OK' </dev/null
```

The wrapper removes `ANTHROPIC_API_KEY` from its environment so a normal Claude credential cannot accidentally override the isolated profile.
