# Configuration Builder — This Project

For the general Alfred Configuration Builder mechanism (widget types,
config keys, how variables reach scripts), see the cross-project reference:
[`docs/alfred-workflow-notes/configuration-builder.md`](alfred-workflow-notes/configuration-builder.md).

This file covers only what's specific to this project.

Variable names in this project use **lowercase with underscores** (e.g. `use_uv`, `log_level`).

## This project's configuration

| Variable | Type | Default | Description |
|---|---|---|---|
| `use_uv` | checkbox | `true` | Use `uv run` when uv is installed |
| `log_level` | select | `WARNING` | Log verbosity (`DEBUG` / `INFO` / `WARNING` / `ERROR`) |
| `cache_ttl` | textfield | `300` | API cache lifetime in seconds |
| `api_base_url` | textfield | `https://api.example.com/v1` | API endpoint base URL |
| `api_timeout` | textfield | `5` | HTTP request timeout in seconds |
