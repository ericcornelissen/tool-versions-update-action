#!/bin/bash
# SPDX-License-Identifier: MIT-0

# --- Setup ------------------------------------------------------------------ #

set -eo pipefail

type="$1"

version=$(grep -o '[^-]*$' <.version)
major=$(echo "${version}" | cut -d. -f1)
minor=$(echo "${version}" | cut -d. -f2)
patch=$(echo "${version}" | cut -d. -f3)

# --- Script ----------------------------------------------------------------- #

if [[ "${type}" == "patch" ]]; then
	patch=$((patch + 1))
elif [[ "${type}" == "minor" ]]; then
	minor=$((minor + 1))
	patch=0
elif [[ "${type}" == "major" ]]; then
	major=$((major + 1))
	minor=0
	patch=0
elif [[ -z "${type}" ]]; then
	echo "Provide an update type, one of 'major', 'minor', or 'patch'"
	exit 1
else
	echo "Unknown update type '${type}'"
	exit 1
fi

echo "${major}.${minor}.${patch}" >.version
