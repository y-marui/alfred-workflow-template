# Contributing

Thank you for contributing!

## Before You Start

- Check existing issues and PRs to avoid duplicate work.
- For large changes, open an issue first to discuss the approach.

## Development Setup

```bash
git clone https://github.com/yourname/alfred-workflow-template
cd alfred-workflow-template
make install   # installs dev dependencies via uv
```

**Prerequisites:**
- macOS (required for Alfred)
- Python 3.9+ (managed via pyenv)
- Alfred 5 with Powerpack
- `jq` (optional, for pretty-printed dev output): `brew install jq`
- `gh` CLI (required for releases): `brew install gh`

## Development Workflow

### Daily commands

```bash
make run Q="search foo"   # simulate Alfred locally
make run Q="open repo"
make run Q="config"
make run Q=""
make test                 # run test suite
make test-cov             # tests with coverage report
make lint                 # ruff check
make format               # ruff format (auto-fix)
make typecheck            # mypy
make build                # build dist/*.alfredworkflow
make vendor               # update workflow/vendor/
```

`make run` calls `scripts/dev.sh` which sets all `alfred_workflow_*` env vars to
temp directories and calls `workflow/scripts/entry.py` with your query.

### Testing in Alfred

1. `make build` — generates `dist/*.alfredworkflow`
2. Double-click the `.alfredworkflow` file to install in Alfred
3. Open Alfred and type your keyword to verify behavior

During rapid iteration you can symlink `workflow/` to Alfred's workflow directory,
but `make run` is usually faster.

## Adding a New Command

1. Create `src/app/commands/my_cmd.py` with a `handle(args: str) -> None` function:

```python
from alfred.response import item, output

def handle(args: str) -> None:
    output([item("My command", f"Args: {args}", arg=args)])
```

2. Register in `src/app/core.py`:

```python
from app.commands import my_cmd
router.register("my")(my_cmd.handle)
```

3. Add tests in `tests/test_commands.py`.
4. Update `README.md` Usage section and `workflow/info.plist` keyword help.

## Adding a Third-Party Dependency

1. Add the package to `requirements.txt`.
2. Run `make vendor` to install into `workflow/vendor/`.
3. Import normally in your code — `entry.py` adds the vendor path to `sys.path`.

> Keep runtime dependencies minimal. Each package increases workflow download size.

## Naming Conventions

| Scope | Convention | Example |
|---|---|---|
| Python files | `snake_case` | `search_service.py` |
| Python classes | `PascalCase` | `ExampleService` |
| Python functions / variables | `snake_case` | `handle`, `cache_ttl` |
| Public functions | Require type hints | `def handle(args: str) -> None:` |
| Alfred command names | lowercase | `"search"`, `"open"` |
| Alfred variable names | `lowercase_with_underscores` | `use_uv`, `log_level` |
| Commit messages | Conventional Commits | `feat:`, `fix:`, `docs:`, `chore:` |
| Branch names | `feat/`, `fix/`, `docs/`, `chore/` | `feat/add-open-browser` |

## Code Style

- **Linter/Formatter:** ruff (line length 100). CI enforces this.
- **Type checker:** mypy strict mode.
- **Comments:** Write *why*, not *what*. Do not comment self-evident code.
- **Imports:** Each module starts with `from __future__ import annotations`.
- **No debug prints:** Remove all `print()` statements before committing.

## Commit Guidelines

- Commit per **feature unit**, after confirming it works.
- **No WIP commits** — do not commit code that does not run.
- **No `--no-verify`** — never skip pre-commit hooks.

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add clipboard copy action
fix: cache miss on special characters in query
chore: update ruff to 0.5.0
docs: update README usage section
refactor: simplify router dispatch logic
```

## Release Process

```bash
# 1. Update version in pyproject.toml
# 2. Update CHANGELOG.md
git add pyproject.toml CHANGELOG.md
git commit -m "chore: release v1.2.3"

# 3. Tag and push
git tag v1.2.3
git push origin main --tags
# GitHub Actions builds .alfredworkflow and creates a GitHub Release

# Manual release (if needed)
make build
make release
```

## Pull Request Checklist

- [ ] `make lint` passes
- [ ] `make typecheck` passes
- [ ] `make test` passes
- [ ] `make build` succeeds
- [ ] New commands have tests
- [ ] `README.md` updated if user-facing changes
- [ ] `CHANGELOG.md` entry added under `[Unreleased]`

## Code Review Guidelines

**Reviewers check for:**
- Architectural constraints respected (no business logic in `entry.py`, no layer skipping)
- All public functions have type hints
- No hardcoded absolute paths (use `$HOME` / env vars)
- No debug `print()` statements in production code
- No Unicode emoji in Alfred result item `title` / `subtitle`
- Tests cover the new or changed behavior
- Alfred env variables managed via Config Builder, not `variables` key

**Security-sensitive changes** (auth, encryption, data access) require explicit
security review before merge.

**Self-review:** Individual contributors open a PR and self-review before merging
to `main`.

## Security

### Supported Versions

Only the latest release is supported with security fixes.

### Reporting a Vulnerability

Please **do not** open a public GitHub issue for security vulnerabilities.

Instead, report them privately via
[GitHub Security Advisories](https://github.com/y-marui/alfred-workflow-template/security/advisories/new)
or email the maintainer directly.

We aim to acknowledge reports within 48 hours and provide a fix within 7 days
for confirmed vulnerabilities.

### Scope

This is a workflow template. Common areas of concern:

- **Credential handling** — never store secrets in `workflow/info.plist` or
  committed files; use Alfred's built-in encrypted keychain instead.
- **Input sanitization** — Alfred query strings are passed to `entry.py`; they
  must not be interpolated into shell commands or SQL without sanitization.
- **Dependency security** — vendored packages in `workflow/vendor/` should be
  kept up-to-date; dependabot monitors `.github/workflows/` automatically.

### Automated Security Checks

| Hook | What it detects |
|---|---|
| `gitleaks` (`.gitleaks.toml`) | Hardcoded secrets, API keys, local absolute paths |
| `detect-private-key` | SSH/TLS private key headers |
| `no-commit-dotenv` | `.env` files accidentally staged |
| `check-added-large-files` | Files over 500 KB |

These hooks run on every commit (pre-commit) and in CI (`security` job).
