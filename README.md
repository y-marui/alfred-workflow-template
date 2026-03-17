# alfred-workflow-template

> Production-ready template for building Alfred 5 Script Filter workflows.
> Start shipping in 10 minutes.

[![CI](https://github.com/yourname/alfred-workflow-template/actions/workflows/ci.yml/badge.svg)](https://github.com/yourname/alfred-workflow-template/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Features

- **Layered architecture** — Alfred boundary isolated from business logic
- **Lightweight Alfred SDK** — response builder, router, cache, config, logger
- **Command-based UX** — `wf search`, `wf open`, `wf config`, `wf help`
- **Full test suite** — pytest, no Alfred required to run tests
- **CI/CD** — lint, test, build, and release via GitHub Actions
- **Vendor packaging** — third-party deps bundled in `vendor/`
- **AI-ready** — `CLAUDE.md` for Claude Code context

## Installation

> **End users:** Download the latest `.alfredworkflow` from the
> [Releases page](https://github.com/yourname/alfred-workflow-template/releases),
> then double-click the file to install it in Alfred.

## Quick Start (developers)

```bash
git clone https://github.com/yourname/alfred-workflow-template
cd alfred-workflow-template

# Install dev dependencies
make install

# Simulate Alfred locally
make run Q="search foo"
make run Q="help"

# Run tests
make test

# Build workflow package
make build
# → dist/workflow-template-0.1.0.alfredworkflow
```

Double-click `dist/*.alfredworkflow` to install in Alfred.

## Usage

```
wf <query>           search (default)
wf search <query>    search
wf open <name>       open a named shortcut
wf config            view / reset settings
wf help              show all commands
```

See [docs/usage.md](docs/usage.md) for full documentation.

## Development

See [docs/development.md](docs/development.md) for:
- Adding new commands
- Adding third-party dependencies
- Local testing workflow
- Release process

## Architecture

See [docs/architecture.md](docs/architecture.md) for the full design.

```
Alfred → entry.py → safe_run → core → router → commands → services → clients
```

## Customizing this template

1. Edit `workflow/info.plist`:
   - Replace `bundleid` with your bundle ID (`com.yourname.workflowname`)
   - Replace the `keyword` (`wf`) with your trigger keyword
   - Run `uuidgen` and replace the placeholder UIDs
2. Replace `src/app/clients/api_client.py` with your API
3. Update the workflow name in `pyproject.toml`
4. Update shortcuts in `src/app/commands/open_cmd.py`
5. Add your `workflow/icon.png`

## License

MIT — see [LICENSE](LICENSE)
