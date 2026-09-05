.PHONY: build test lint fmt build-workflow precommit update-charter update-workflow-notes

build:
	go build ./...

test:
	go test ./...

lint:
	@out=$$(gofmt -l .); \
	if [ -n "$$out" ]; then \
		echo "gofmt needs to be run on:"; \
		echo "$$out"; \
		exit 1; \
	fi
	go vet ./...

fmt:
	gofmt -w .

build-workflow:
	scripts/build-workflow.sh

precommit:
	pre-commit run --all-files

# ---------------------------------------------------------------------------
# Dev Charter
# ---------------------------------------------------------------------------
update-charter:
	curl -fsSL https://raw.githubusercontent.com/y-marui/dev-charter/main/scripts/install.sh | CHARTER_UPDATE_ONLY=1 bash

# ---------------------------------------------------------------------------
# Alfred Workflow Notes
#
# This repo is the *source* of docs/alfred-workflow-notes/ (see
# scripts/install-workflow-notes.sh), so it has nothing to pull from
# itself — this target is commented out here and exists only as the
# reference copy-paste block for the projects that consume it.
# ---------------------------------------------------------------------------
# update-workflow-notes:
# 	curl -fsSL https://raw.githubusercontent.com/y-marui/alfred-workflow-template/main/scripts/install-workflow-notes.sh | bash
