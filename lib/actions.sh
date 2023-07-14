#!/bin/bash

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
