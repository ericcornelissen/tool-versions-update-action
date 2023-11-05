SHELL_SCRIPTS:=./bin/*.sh ./lib/*.sh
SPEC_SCRIPTS:=./spec/*.sh ./spec/**/*.sh

COVERAGE_DIR:=./_coverage
REPORT_DIR:=./_reports
TMP_DIR:=./.tmp

ASDF:=$(TMP_DIR)/.asdf
DEV_IMG:=$(TMP_DIR)/.dev-img

DEV_ENV_NAME:=tool-versions-update-action-dev
DEV_IMG_NAME:=$(DEV_ENV_NAME)-img

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

.PHONY: dev-env dev-img
dev-env: dev-img ## Run an ephemeral development environment with Docker
	@docker run \
		-it \
		--rm \
		--workdir "/tool-versions-update-action" \
		--mount "type=bind,source=$(shell pwd),target=/tool-versions-update-action" \
		--name "$(DEV_ENV_NAME)" \
		"$(DEV_IMG_NAME)"

dev-img: $(DEV_IMG) ## Build a development environment image with Docker

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

.PHONY: lint lint-ci lint-docker lint-sh lint-yml
lint: lint-ci lint-docker lint-sh lint-yml ## Run lint-*

lint-ci: $(ASDF) ## Lint CI workflow files
	@actionlint

lint-docker: $(ASDF) ## Lint the Dockerfile
	@hadolint Dockerfile

lint-sh: $(ASDF) ## Lint shell scripts
	@shellcheck $(SHELL_SCRIPTS) $(SPEC_SCRIPTS)

lint-yml: $(ASDF) ## Lint YAML files
	@yamllint -c .yamllint.yml .

.PHONY: test test-e2e
test: | $(TMP_DIR) ## Run tests
	@shellspec

test-e2e: ## Run end-to-end tests
	@act --job test-bare

.PHONY: update-actions
update-actions: ## Update (and pin) all actions used by these actions
	@docker run \
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
		"pin-github-action@^1.5.0" \
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

$(DEV_IMG): .tool-versions Dockerfile | $(TMP_DIR)
	@docker build --tag $(DEV_IMG_NAME) .
	@touch $(DEV_IMG)
