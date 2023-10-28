#!/bin/bash
# SPDX-License-Identifier: MIT

# --- Setup ------------------------------------------------------------------ #

set -eo pipefail

bin_dir=$(dirname "${BASH_SOURCE[0]}")
exclusions=${NOT}
inclusions=${ONLY}
max_capacity=${MAX}
remaining_capacity=${MAX}
updated_count=0

output_name_did_update='did-update'
output_name_updated_count='updated-count'

# --- Import ----------------------------------------------------------------- #

# shellcheck source=./lib/actions.sh
source "${bin_dir}/../lib/actions.sh"

# --- Script ----------------------------------------------------------------- #

debug "initializing outputs to their default value"
set_output "${output_name_did_update}" 'false'
set_output "${output_name_updated_count}" "${updated_count}"

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

		debug "checking if ${tool} should be evaluated"
		if [[ ${exclusions} =~ (^|,)" "*"${tool}"" "*($|,) ]]; then
			info "skipping ${tool} because it is configured in the exclusion rule"
			continue
		fi

		if [[ -n ${inclusions} ]]; then
			if [[ ! ${inclusions} =~ (^|,)" "*"${tool}"" "*($|,) ]]; then
				info "skipping ${tool} because it is NOT configured in the inclusion rule"
				continue
			fi
		fi

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

			debug "overriding '${output_name_did_update}' output to true"
			set_output "${output_name_did_update}" 'true'

			debug "overriding '${output_name_updated_count}' output with new value"
			((updated_count += 1))
			set_output "${output_name_updated_count}" "${updated_count}"

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
