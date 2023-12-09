#!/bin/bash
# SPDX-License-Identifier: MIT

# --- Setup ------------------------------------------------------------------ #

set -eo pipefail

exclusions=${NOT}
inclusions=${ONLY}
max_capacity=${MAX}
remaining_capacity=${MAX}
skips=${SKIP}
updated_tools=""

output_name_updated_count="updated-count"
output_name_updated_tools="updated-tools"

# --- Import ----------------------------------------------------------------- #

bin=$(dirname "${BASH_SOURCE[0]}")

# shellcheck source=./lib/actions.sh
source "${bin}/../lib/actions.sh"

# --- Script ----------------------------------------------------------------- #

debug "initializing outputs to their default value"
set_output "${output_name_updated_count}" "0"
set_output "${output_name_updated_tools}" "${updated_tools}"

debug "checking if .tool-versions file exists"
if [[ ! -f ".tool-versions" ]]; then
	error "no .tool-versions file found, it must be present at the root of your project in order for this action to work"
	exit 1
fi

if [[ -z ${exclusions} ]]; then
	debug "no exclusions configured"
fi
if [[ -z ${inclusions} ]]; then
	debug "no inclusions configured"
fi
if [[ -z ${skips} ]]; then
	debug "no skips configured"
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

		if [[ -n ${exclusions} ]]; then
			debug "checking if ${tool} is in the exclusion input"
			if [[ ${exclusions} =~ (^|,)" "*"${tool}"" "*($|,) ]]; then
				info "skipping ${tool} because it is in the exclusion input"
				continue
			fi
		fi

		if [[ -n ${inclusions} ]]; then
			debug "checking if ${tool} is NOT in the inclusion input"
			if [[ ! ${inclusions} =~ (^|,)" "*"${tool}"" "*($|,) ]]; then
				info "skipping ${tool} because it is NOT in the inclusion input"
				continue
			fi
		fi

		info "evaluating ${tool}..."

		current_version="$(echo "${line}" | awk '{print $2}')"
		latest_version="$(asdf latest "${tool}")"
		debug "${tool} current: ${current_version}, latest: ${latest_version}"

		if [ "${current_version}" != "${latest_version}" ]; then
			info "update available for ${tool}"

			if [[ -n ${skips} ]]; then
				debug "checking if ${tool}@${latest_version} is in the skip input"
				while read -r line; do
					case "${line}" in
					"")
						debug "skipping empty skip input line"
						;;
					*)
						debug "processing skip input line ('${line}')"

						name="$(echo "${line}" | awk '{print $1}')"
						version="$(echo "${line}" | awk '{print $2}')"
						debug "found skip mandate for ${name}@${version}"

						if [ "${name}" == "${tool}" ] && [ "${version}" == "${latest_version}" ]; then
							info "skipping ${name}@${version} because it is in the skip input"
							continue 2
						fi
						;;
					esac
				done <<<"${skips}"
			fi

			debug "installing ${tool}@${latest_version}"
			asdf install "${tool}" "${latest_version}"
			debug "applying ${tool}@${latest_version} locally"
			asdf local "${tool}" "${latest_version}"

			remaining_capacity=$((remaining_capacity - 1))
			debug "remaining update capacity: ${remaining_capacity}"

			debug "overriding '${output_name_updated_count}' output with new value"
			set_output "${output_name_updated_count}" "$((max_capacity - remaining_capacity))"

			debug "overriding '${output_name_updated_tools}' output with new value"
			if [ -z "${updated_tools}" ]; then
				updated_tools="${tool}"
			else
				updated_tools="${updated_tools},${tool}"
			fi
			set_output "${output_name_updated_tools}" "${updated_tools}"

			if [ "${remaining_capacity}" -eq 0 ]; then
				info "finished updating after ${max_capacity} update(s)"
				break
			fi
		else
			info "no update available for ${tool}"
		fi
		;;
	esac
done <".tool-versions"

group_end
