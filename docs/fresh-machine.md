# Fresh machine setup with an AI agent

Give your coding agent the repository URL and the prompt in `prompts/install.md`. The agent should inspect the machine, determine which tools are present, and adapt the setup rather than asking you to reproduce file operations manually.

The expected flow is:

1. The agent reads `README.md` and `AGENTS.md`.
2. It detects the OS, shell, installed tools, and existing configuration.
3. It explains the applicable components and meaningful conflicts.
4. It installs or merges the approved pieces with timestamped backups.
5. It asks you to authenticate through each tool's normal flow. Authentication files are never copied from another machine.
6. It installs external skills and plugins from the recorded upstream projects.
7. It validates the configuration and exercises each intended CLI with a harmless prompt.

Project trust prompts, desktop preferences, browser integrations, and OS-specific MCP servers are intentionally configured per machine.
