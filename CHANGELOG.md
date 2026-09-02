# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `docs/alfred-workflow-notes/` — canonical, subtree-pullable reference for
  cross-project Alfred workflow development knowledge (Configuration
  Builder mechanism, `info.plist` object schema)

### Changed

- `docs/configuration-builder.md` now covers only this project's own
  Configuration Builder settings; the general mechanism reference moved
  to `docs/alfred-workflow-notes/configuration-builder.md`

### Fixed

- `docs/alfred-workflow-notes/README.md`'s "Installing in a consuming
  project" sample commands: a plain `git subtree add`/`pull` against
  `alfred-workflow-template` pulled in that repo's entire root instead of
  just `docs/alfred-workflow-notes/`, since (unlike `docs/dev-charter/`)
  the shared content here lives in a subdirectory, not at the upstream
  repo's root. Both the first-time install and the `update-workflow-notes`
  Makefile target now split that subdirectory's history into a throwaway
  local branch first, then add/merge just that — verified against
  [alfred-clean-invisible-text#26](https://github.com/y-marui/alfred-clean-invisible-text/pull/26)

## [0.1.0] - 2024-01-01

### Added

- Initial release of the Alfred Workflow Template
- Alfred SDK: `response`, `cache`, `config`, `logger`, `router`, `safe_run`
- Command-based UX: `search`, `open`, `config`, `help`
- Vendor packaging via `scripts/vendor.sh`
- Build pipeline via `scripts/build.sh`
- GitHub Actions CI (lint, test, build)
- GitHub Actions Release (tag → `.alfredworkflow` → GitHub Release)
- Full pytest test suite

[Unreleased]: https://github.com/yourname/alfred-workflow-template/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/yourname/alfred-workflow-template/releases/tag/v0.1.0
