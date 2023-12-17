#!/bin/bash
# SPDX-License-Identifier: MIT

# --- Setup ------------------------------------------------------------------ #

set -eo pipefail

## Inputs
template=${TEXT}

## Constants
output_name_value="value"

## State
value=${template}

# --- Import ----------------------------------------------------------------- #

bin=$(dirname "${BASH_SOURCE[0]}")

# shellcheck source=./lib/actions.sh
source "${bin}/../lib/actions.sh"

# --- Script ----------------------------------------------------------------- #

debug "input for templating is '${value}'"

debug "substitute '{{updated-count}}' for '${UPDATED_COUNT}'"
value=${value//'{{updated-count}}'/"${UPDATED_COUNT}"}

debug "substitute '{{updated-new-versions}}' for '${UPDATED_NEW_VERSIONS}'"
value=${value//'{{updated-new-versions}}'/"${UPDATED_NEW_VERSIONS}"}

debug "substitute '{{updated-old-versions}}' for '${UPDATED_OLD_VERSIONS}'"
value=${value//'{{updated-old-versions}}'/"${UPDATED_OLD_VERSIONS}"}

debug "substitute '{{updated-tools}}' for '${UPDATED_TOOLS}'"
value=${value//'{{updated-tools}}'/"${UPDATED_TOOLS}"}

debug "setting output"
set_output "${output_name_value}" "${value}"
