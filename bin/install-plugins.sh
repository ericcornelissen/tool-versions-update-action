#!/bin/bash
# SPDX-License-Identifier: MIT

# --- Setup ------------------------------------------------------------------ #

set -eo pipefail

bin_dir=$(dirname "${BASH_SOURCE[0]}")
plugin_list=${LIST}

# --- Import ----------------------------------------------------------------- #

# shellcheck source=./lib/actions.sh
source "${bin_dir}/../lib/actions.sh"

# --- Script ----------------------------------------------------------------- #

group_start "Configuring asdf plugins"

while read -r line; do
	case "${line}" in
	"")
		debug "skipping empty line"
		;;
	*)
		debug "processing line ('${line}')"

		name="$(echo "${line}" | awk '{print $1}')"
		url="$(echo "${line}" | awk '{print $2}')"
		debug "provided url for ${name} is '${url}'"

		info "installing plugin for ${name}..."
		asdf plugin add "${name}" "${url}" &>/dev/null

		result=$?
		if [ "${result}" -eq 0 ]; then
			info "plugin ${name} installed"
		elif [ "${result}" -eq 2 ]; then
			info "plugin ${name} already installed"
		else
			info "plugin ${name} could not be installed"
		fi
		;;
	esac
done <<<"${plugin_list}"

group_end