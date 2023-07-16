#!/bin/bash

# --- Setup ------------------------------------------------------------------ #

set -eo pipefail

bin_dir=$(dirname "${BASH_SOURCE[0]}")
max_capacity=${MAX}
remaining_capacity=${MAX}

# --- Import ----------------------------------------------------------------- #

# shellcheck source=./lib/actions.sh
source "${bin_dir}/../lib/actions.sh"

# --- Script ----------------------------------------------------------------- #

debug "checking if .tool-versions file exists"
if [[ ! -f '.tool-versions' ]]; then
	error "no .tool-versions file found, it must be present at the root of your project in order for this action to work"
	exit 1
fi

group_start "Updating tools"
debug "starting with update capacity: ${remaining_capacity}"

while read -r line; do
	case "${line}" in
	"")
		debug "skipping empty line"
		;;
	\#*)
		debug "skipping comment ('${line}')"
		;;
	*)
		debug "processing line ('${line}')"

		tool="$(echo "${line}" | awk '{print $1}')"
		info "evaluating ${tool}..."

		current_version="$(echo "${line}" | awk '{print $2}')"
		latest_version="$(asdf latest "${tool}")"
		debug "${tool} current: ${current_version}, latest: ${latest_version}"

		if [ "${current_version}" != "${latest_version}" ]; then
			info "update available for ${tool}, applying update..."

			debug "installing ${tool}@${latest_version}"
			asdf install "${tool}" "${latest_version}"
			debug "applying ${tool}@${latest_version} locally"
			asdf local "${tool}" "${latest_version}"

			remaining_capacity=$((remaining_capacity - 1))
			debug "remaining update capacity: ${remaining_capacity}"

			if [ "${remaining_capacity}" -eq 0 ]; then
				info "finished updating after ${max_capacity} update(s)"
				exit 0
			fi
		else
			info "no update available for ${tool}"
		fi
		;;
	esac
done <".tool-versions"

group_end
