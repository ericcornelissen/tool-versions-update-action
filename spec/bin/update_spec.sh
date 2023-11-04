# shellcheck shell=bash
# SPDX-License-Identifier: MIT

BeforeEach 'clear_github_output'

Describe 'update.sh'
	setup() {
		export NOT="$(exclusions)"
		export ONLY="$(inclusions)"
		export MAX="$(max_capacity)"
		export SKIP="$(skips)"

		mv .tool-versions .tool-versions.bak
		tool_versions >>.tool-versions
	}

	teardown() {
		mv .tool-versions.bak .tool-versions
	}

	BeforeEach 'setup'
	AfterEach 'teardown'

	exclusions() {
		echo
	}

	inclusions() {
		echo
	}

	max_capacity() {
		echo '0'
	}

	skips() {
		echo
	}

	tool_versions() {
		%text
		#|# file: .tool-versions
		#|
		#|shellcheck 0.9.0
		#|shellspec 0.28.1
		#|shfmt 3.7.0
	}

	snapshot_stdout() {
		%text
		#|::debug::initializing outputs to their default value
		#|::debug::checking if .tool-versions file exists
		#|::group::Updating tools
		#|::debug::starting with update capacity: 0
		#|::debug::skipping comment ('# file: .tool-versions')
		#|::debug::skipping empty line
		#|::debug::processing line ('shellcheck 0.9.0')
		#|::debug::checking if shellcheck should be evaluated
		#|::debug::no exclusions configured
		#|::debug::no inclusions configured
		#|evaluating shellcheck...
		#|::debug::shellcheck current: 0.9.0, latest: 0.9.0
		#|no update available for shellcheck
		#|::debug::processing line ('shellspec 0.28.1')
		#|::debug::checking if shellspec should be evaluated
		#|::debug::no exclusions configured
		#|::debug::no inclusions configured
		#|evaluating shellspec...
		#|::debug::shellspec current: 0.28.1, latest: 0.28.1
		#|no update available for shellspec
		#|::debug::processing line ('shfmt 3.7.0')
		#|::debug::checking if shfmt should be evaluated
		#|::debug::no exclusions configured
		#|::debug::no inclusions configured
		#|evaluating shfmt...
		#|::debug::shfmt current: 3.7.0, latest: 3.7.0
		#|no update available for shfmt
		#|::endgroup::
	}

	snapshot_outputs() {
		%text
		#|updated-count=0
	}

	Mock asdf
		case "$1" in
		"latest")
			case "$2" in
				"shellcheck")
					echo "0.9.0"
					;;
				"shellspec")
					echo "0.28.1"
					;;
				"shfmt")
					echo "3.7.0"
					;;
			esac
			;;
		esac
	End

	It 'installs and succeeds'
		When run script bin/update.sh
		The status should equal 0
		The output should equal "$(snapshot_stdout)"
		The file "${GITHUB_OUTPUT}" should satisfy contents "$(snapshot_outputs)"
	End
End
