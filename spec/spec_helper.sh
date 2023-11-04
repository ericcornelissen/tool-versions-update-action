# shellcheck shell=bash
# SPDX-License-Identifier: MIT

# --- ENVIRONMENT --------------------------------------------------------------

export GITHUB_OUTPUT='github_output'

# --- HOOKS --------------------------------------------------------------------

clear_github_output() {
	rm -rf "${GITHUB_OUTPUT}"
}

# --- MATCHERS -----------------------------------------------------------------

contents() {
	file=${contents:?}
	test "$(cat "${file}")" "=" "$1"
}
