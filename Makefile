# SPDX-License-Identifier: MIT-0

CONTAINER_ENGINE?=docker

SHELL_SCRIPTS:=./bin/*.sh ./lib/*.sh
SPEC_SCRIPTS:=./spec/*.sh ./spec/**/*.sh

COVERAGE_DIR:=./_coverage
REPORT_DIR:=./_reports
TMP_DIR:=./.tmp

ASDF:=$(TMP_DIR)/.asdf
DEV_IMG:=$(TMP_DIR)/.dev-img

DEV_ENV_NAME:=tool-versions-update-action-dev
DEV_IMG_NAME:=$(DEV_ENV_NAME)-img

SHELLCHECK_OPTS:='--enable=avoid-nullary-conditions --enable=deprecate-which --enable=quote-safe-variables --enable=require-variable-braces'

################################################################################
### Commands ###################################################################
################################################################################

.PHONY: default
default: help

.PHONY: clean
clean: ## Clean the repository
	@git clean -fx \
		$(COVERAGE_DIR) \
		$(REPORT_DIR) \
		$(TMP_DIR)

.PHONY: coverage
coverage: $(ASDF) | $(TMP_DIR) ## Run tests with coverage
	@shellspec --kcov

.PHONY: dev-env dev-img
dev-env: dev-img ## Run an ephemeral development environment container
	@$(CONTAINER_ENGINE) run \
		-it \
		--rm \
		--workdir "/tool-versions-update-action" \
		--mount "type=bind,source=$(shell pwd),target=/tool-versions-update-action" \
		--name "$(DEV_ENV_NAME)" \
		"$(DEV_IMG_NAME)"

dev-img: $(DEV_IMG) ## Build a development environment container image

.PHONY: format format-check
format: $(ASDF) ## Format the source code
	@shfmt --simplify --write $(SHELL_SCRIPTS)

format-check: $(ASDF) ## Check the source code formatting
	@shfmt --diff $(SHELL_SCRIPTS)

.PHONY: help
help: ## Show this help message
	@printf "Usage: make <command>\n\n"
	@printf "Commands:\n"
	@awk -F ':(.*)## ' '/^[a-zA-Z0-9%\\\/_.-]+:(.*)##/ { \
		printf "  \033[36m%-30s\033[0m %s\n", $$1, $$NF \
	}' $(MAKEFILE_LIST)

.PHONY: lint lint-ci lint-container lint-sh lint-yml
lint: lint-ci lint-container lint-sh lint-yml ## Run lint-*

lint-ci: $(ASDF) ## Lint CI workflow files
	@SHELLCHECK_OPTS=$(SHELLCHECK_OPTS) \
		actionlint

lint-container: $(ASDF) ## Lint the Containerfile
	@hadolint Containerfile.dev

lint-sh: $(ASDF) ## Lint shell scripts
	@SHELLCHECK_OPTS=$(SHELLCHECK_OPTS) \
		shellcheck \
		$(SHELL_SCRIPTS) $(SPEC_SCRIPTS)

lint-yml: $(ASDF) ## Lint YAML files
	@yamllint -c .yamllint.yml .

.PHONY: sast
sast: sast-ades sast-zizmor ## Perform static application security testing

sast-ades:
	@$(CONTAINER_ENGINE) run \
		--rm \
		--volume $(shell pwd):/src \
		docker.io/ericornelissen/ades:v25.02 \
		./commit/action.yml \
		./pr/action.yml \
		./action.yml

sast-zizmor:
	@$(CONTAINER_ENGINE) run \
		--rm \
		--volume $(shell pwd):/src \
		ghcr.io/woodruffw/zizmor:1.4.0 \
		/src/commit/action.yml \
		/src/pr/action.yml \
		/src/action.yml

.PHONY: test test-e2e
test: $(ASDF) | $(TMP_DIR) ## Run tests
	@shellspec

.PHONY: update-actions
update-actions: ## Update (and pin) all actions used by these actions
	@$(CONTAINER_ENGINE) run \
		--rm \
		--workdir "/tool-versions-update-action" \
		--mount "type=bind,source=$(shell pwd),target=/tool-versions-update-action" \
		--name "tool-versions-update-action-update-actions" \
		--entrypoint "npx" \
		--env "GH_ADMIN_TOKEN" \
		"node:current-alpine" \
		\
		"--update-notifier=false" \
		"--yes" \
		"pin-github-action@^2.0.2" \
		"commit/action.yml" "pr/action.yml" "action.yml"

.PHONY: verify
verify: format-check lint test ## Verify project is in a good state

################################################################################
### Targets ####################################################################
################################################################################

$(TMP_DIR):
	@mkdir $(TMP_DIR)

$(ASDF): .tool-versions | $(TMP_DIR)
	@asdf install
	@touch $(ASDF)

$(DEV_IMG): .tool-versions Containerfile.dev | $(TMP_DIR)
	@$(CONTAINER_ENGINE) build --file Containerfile.dev --tag $(DEV_IMG_NAME) .
	@touch $(DEV_IMG)
