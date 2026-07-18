# Linux and Nobara

Install `git`, `jq`, and the AI CLIs through their official channels. Ensure `~/.local/bin` is on `PATH`.

For CLIProxyAPI, install its executable at `~/.local/bin/cliproxyapi`, keep the private config at `~/.config/cliproxyapi/config.yaml` with mode `0600`, then install the user service:

```bash
mkdir -p ~/.config/systemd/user
cp claudex/systemd/cliproxyapi.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now cliproxyapi.service
```

The service assumes the executable and config paths above. Run `./scripts/doctor` after setup.
