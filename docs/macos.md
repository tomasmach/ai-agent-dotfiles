# macOS

Required commands are available from Xcode Command Line Tools plus `jq` (for example via Homebrew). Ensure `~/.local/bin` is on `PATH` after installation.

For Claudex, copy `claudex/launchd/com.tomasmach.cliproxyapi.plist.template` to `~/Library/LaunchAgents/`, replace template values, and load it only after installing and privately configuring CLIProxyAPI. The repository never supplies credentials.

Mac-only Codex desktop integrations, Computer Use paths, Chrome native hosts, and Pencil configuration are intentionally excluded because application installers own them.
