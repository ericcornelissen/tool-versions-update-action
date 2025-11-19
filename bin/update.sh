#!/bin/bash
# SPDX-License-Identifier: MIT

# --- Setup ------------------------------------------------------------------ #

set -eo pipefail

## Inputs
exclusions=${NOT}
inclusions=${ONLY}
max_capacity=${MAX}
skips=${SKIP}

## Constants
output_name_updated_count="updated-count"
output_name_updated_tools="updated-tools"
output_name_updated_old_versions="updated-old-versions"
output_name_updated_new_versions="updated-new-versions"
output_name_updated_tools_json="updated-tools-json"
output_name_updated_tools_table="updated-tools-table"

## State
remaining_capacity=${max_capacity}
updated_tools=""
updated_old_versions=""
updated_new_versions=""
updated_tools_json="[]"
updated_tools_table=""

# --- Import ----------------------------------------------------------------- #

bin=$(dirname "${BASH_SOURCE[0]}")

# shellcheck source=./lib/actions.sh
source "${bin}/../lib/actions.sh"

# --- Helpers ---------------------------------------------------------------- #

extend_list() {
	if [ -z "$1" ]; then
		echo "$2"
	else
		echo "$1,$2"
	fi
}

json_escape() {
	local string="$1"
	# Escape backslashes, quotes, and common control characters
	string="${string//\\/\\\\}"  # Escape backslashes first
	string="${string//\"/\\\"}"  # Escape double quotes
	string="${string//$'\t'/\\t}" # Escape tabs
	string="${string//$'\n'/\\n}" # Escape newlines
	string="${string//$'\r'/\\r}" # Escape carriage returns
	echo "${string}"
}

add_to_json_array() {
	local json_array="$1"
	local tool_name="$2"
	local old_version="$3"
	local new_version="$4"

	# Escape values for JSON
	tool_name="$(json_escape "${tool_name}")"
	old_version="$(json_escape "${old_version}")"
	new_version="$(json_escape "${new_version}")"

	local new_item="{\"name\":\"${tool_name}\",\"oldVersion\":\"${old_version}\",\"newVersion\":\"${new_version}\"}"

	if [ "${json_array}" == "[]" ]; then
		echo "[${new_item}]"
	else
		# Remove the closing bracket and add the new item
		echo "${json_array%]},${new_item}]"
	fi
}

add_to_table() {
	local table="$1"
	local tool_name="$2"
	local old_version="$3"
	local new_version="$4"

	# Escape pipe characters to prevent breaking table formatting
	tool_name="${tool_name//|/\\|}"
	old_version="${old_version//|/\\|}"
	new_version="${new_version//|/\\|}"

	if [ -z "${table}" ]; then
		# Initialize table with header
		echo "| Tool | Old Version | New Version |
|------|-------------|-------------|
| ${tool_name} | ${old_version} | ${new_version} |"
	else
		# Add new row
		echo "${table}
| ${tool_name} | ${old_version} | ${new_version} |"
	fi
}

# --- Script ----------------------------------------------------------------- #

debug "initializing outputs to their default value"
set_output "${output_name_updated_count}" "0"
set_output "${output_name_updated_tools}" "${updated_tools}"
set_output "${output_name_updated_old_versions}" "${updated_old_versions}"
set_output "${output_name_updated_new_versions}" "${updated_new_versions}"
set_output "${output_name_updated_tools_json}" "${updated_tools_json}"
set_output "${output_name_updated_tools_table}" "${updated_tools_table}"

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

tool_versions="$(cat '.tool-versions')"

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
			asdf set "${tool}" "${latest_version}"

			remaining_capacity=$((remaining_capacity - 1))
			debug "remaining update capacity: ${remaining_capacity}"

			debug "overriding '${output_name_updated_count}' output with new value"
			set_output "${output_name_updated_count}" "$((max_capacity - remaining_capacity))"

			debug "overriding '${output_name_updated_tools}' output with new value"
			updated_tools="$(extend_list "${updated_tools}" "${tool}")"
			set_output "${output_name_updated_tools}" "${updated_tools}"

			debug "overriding '${output_name_updated_old_versions}' output with new value"
			updated_old_versions="$(extend_list "${updated_old_versions}" "${current_version}")"
			set_output "${output_name_updated_old_versions}" "${updated_old_versions}"

			debug "overriding '${output_name_updated_new_versions}' output with new value"
			updated_new_versions="$(extend_list "${updated_new_versions}" "${latest_version}")"
			set_output "${output_name_updated_new_versions}" "${updated_new_versions}"

			debug "overriding '${output_name_updated_tools_json}' output with new value"
			updated_tools_json="$(add_to_json_array "${updated_tools_json}" "${tool}" "${current_version}" "${latest_version}")"
			set_output "${output_name_updated_tools_json}" "${updated_tools_json}"

			debug "overriding '${output_name_updated_tools_table}' output with new value"
			updated_tools_table="$(add_to_table "${updated_tools_table}" "${tool}" "${current_version}" "${latest_version}")"
			set_output "${output_name_updated_tools_table}" "${updated_tools_table}"

			if [ "${remaining_capacity}" -eq 0 ]; then
				info "finished updating after ${max_capacity} update(s)"
				break
			fi
		else
			info "no update available for ${tool}"
		fi
		;;
	esac
done <<<"${tool_versions}"

group_end
