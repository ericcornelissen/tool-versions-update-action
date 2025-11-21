#!/bin/bash
# SPDX-License-Identifier: MIT

info() {
	echo "$1"
}

debug() {
	awk '{print "::debug::"$0}' <<<"$1"
}

error() {
	awk '{print "::error::"$0}' <<<"$1"
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
