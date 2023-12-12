#!/bin/bash
# SPDX-License-Identifier: MIT

info() {
	echo "$1"
}

debug() {
	echo "::debug::$1"
}

error() {
	echo "::error::$1"
}

group_start() {
	echo "::group::$1"
}

group_end() {
	echo "::endgroup::"
}

set_output() {
	if [[ "$(wc -l <<<"$2")" -gt 1 ]]; then
		{
			echo "$1<<EOF"
			echo "$2"
			echo "EOF"
		} >>"${GITHUB_OUTPUT}"
	else
		echo "$1=$2" >>"${GITHUB_OUTPUT}"
	fi
}
