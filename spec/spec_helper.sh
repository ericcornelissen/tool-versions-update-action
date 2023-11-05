# shellcheck shell=bash
# SPDX-License-Identifier: MIT

# --- Environment ------------------------------------------------------------ #

export GITHUB_OUTPUT='.tmp/github_output'

# --- Hooks ------------------------------------------------------------------ #

clear_github_output() {
	rm -f "${GITHUB_OUTPUT}"
}

# --- Matchers --------------------------------------------------------------- #

contents() {
	file=${contents:?}
	test "$(cat "${file}")" "=" "$1"
}
