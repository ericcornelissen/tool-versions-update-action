#!/bin/bash
# SPDX-License-Identifier: MIT-0

# --- Setup ------------------------------------------------------------------ #

set -eo pipefail

changelog="$(cat CHANGELOG.md)"
date=$(date '+%Y-%m-%d')
version=$(cat .version)

anchor='## [Unreleased]'
no_changes='_No changes yet._'

# --- Script ----------------------------------------------------------------- #

new_content="${anchor}

### "'`'"tool-versions-update-action"'`'"

- ${no_changes}

### "'`'"tool-versions-update-action/commit"'`'"

- ${no_changes}

### "'`'"tool-versions-update-action/pr"'`'"

- ${no_changes}

## [${version}] - ${date}"

changelog=${changelog//"${no_changes}"/'_Version bump only._'}
changelog=${changelog//"${anchor}"/"${new_content}"}

echo "${changelog}" >CHANGELOG.md
