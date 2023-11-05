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

	Describe 'no options and everything is latest'
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

		It 'succeeds'
			When run script bin/update.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
			The file "${GITHUB_OUTPUT}" should satisfy contents "$(snapshot_outputs)"
		End
	End

	Describe 'no options and nothing is latest'
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
			#|shellcheck 0.8.0
			#|shellspec 0.28.0
			#|shfmt 3.6.1
		}

		snapshot_stdout() {
			%text
			#|::debug::initializing outputs to their default value
			#|::debug::checking if .tool-versions file exists
			#|::group::Updating tools
			#|::debug::starting with update capacity: 0
			#|::debug::processing line ('shellcheck 0.8.0')
			#|::debug::checking if shellcheck should be evaluated
			#|::debug::no exclusions configured
			#|::debug::no inclusions configured
			#|evaluating shellcheck...
			#|::debug::shellcheck current: 0.8.0, latest: 0.9.0
			#|update available for shellcheck
			#|::debug::no skips configured
			#|::debug::installing shellcheck@0.9.0
			#|::debug::applying shellcheck@0.9.0 locally
			#|::debug::remaining update capacity: -1
			#|::debug::overriding 'updated-count' output with new value
			#|::debug::processing line ('shellspec 0.28.0')
			#|::debug::checking if shellspec should be evaluated
			#|::debug::no exclusions configured
			#|::debug::no inclusions configured
			#|evaluating shellspec...
			#|::debug::shellspec current: 0.28.0, latest: 0.28.1
			#|update available for shellspec
			#|::debug::no skips configured
			#|::debug::installing shellspec@0.28.1
			#|::debug::applying shellspec@0.28.1 locally
			#|::debug::remaining update capacity: -2
			#|::debug::overriding 'updated-count' output with new value
			#|::debug::processing line ('shfmt 3.6.1')
			#|::debug::checking if shfmt should be evaluated
			#|::debug::no exclusions configured
			#|::debug::no inclusions configured
			#|evaluating shfmt...
			#|::debug::shfmt current: 3.6.1, latest: 3.7.0
			#|update available for shfmt
			#|::debug::no skips configured
			#|::debug::installing shfmt@3.7.0
			#|::debug::applying shfmt@3.7.0 locally
			#|::debug::remaining update capacity: -3
			#|::debug::overriding 'updated-count' output with new value
			#|::endgroup::
		}

		snapshot_outputs() {
			%text
			#|updated-count=0
			#|updated-count=1
			#|updated-count=2
			#|updated-count=3
		}

		It 'succeeds'
			When run script bin/update.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
			The file "${GITHUB_OUTPUT}" should satisfy contents "$(snapshot_outputs)"
		End
	End

	Describe 'maximum update count option'
		exclusions() {
			echo
		}

		inclusions() {
			echo
		}

		max_capacity() {
			echo '2'
		}

		skips() {
			echo
		}

		tool_versions() {
			%text
			#|shellcheck 0.8.0
			#|shellspec 0.28.0
			#|shfmt 3.6.1
		}

		snapshot_stdout() {
			%text
			#|::debug::initializing outputs to their default value
			#|::debug::checking if .tool-versions file exists
			#|::group::Updating tools
			#|::debug::starting with update capacity: 2
			#|::debug::processing line ('shellcheck 0.8.0')
			#|::debug::checking if shellcheck should be evaluated
			#|::debug::no exclusions configured
			#|::debug::no inclusions configured
			#|evaluating shellcheck...
			#|::debug::shellcheck current: 0.8.0, latest: 0.9.0
			#|update available for shellcheck
			#|::debug::no skips configured
			#|::debug::installing shellcheck@0.9.0
			#|::debug::applying shellcheck@0.9.0 locally
			#|::debug::remaining update capacity: 1
			#|::debug::overriding 'updated-count' output with new value
			#|::debug::processing line ('shellspec 0.28.0')
			#|::debug::checking if shellspec should be evaluated
			#|::debug::no exclusions configured
			#|::debug::no inclusions configured
			#|evaluating shellspec...
			#|::debug::shellspec current: 0.28.0, latest: 0.28.1
			#|update available for shellspec
			#|::debug::no skips configured
			#|::debug::installing shellspec@0.28.1
			#|::debug::applying shellspec@0.28.1 locally
			#|::debug::remaining update capacity: 0
			#|::debug::overriding 'updated-count' output with new value
			#|finished updating after 2 update(s)
			#|::endgroup::
		}

		snapshot_outputs() {
			%text
			#|updated-count=0
			#|updated-count=1
			#|updated-count=2
		}

		It 'succeeds'
			When run script bin/update.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
			The file "${GITHUB_OUTPUT}" should satisfy contents "$(snapshot_outputs)"
		End
	End

	Describe 'exclusions option'
		exclusions() {
			%text
			#|shellcheck
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
			#|shellcheck 0.8.0
			#|shellspec 0.28.0
		}

		snapshot_stdout() {
			%text
			#|::debug::initializing outputs to their default value
			#|::debug::checking if .tool-versions file exists
			#|::group::Updating tools
			#|::debug::starting with update capacity: 0
			#|::debug::processing line ('shellcheck 0.8.0')
			#|::debug::checking if shellcheck should be evaluated
			#|::debug::checking if shellcheck is in the exclusion input
			#|skipping shellcheck because it is in the exclusion input
			#|::debug::processing line ('shellspec 0.28.0')
			#|::debug::checking if shellspec should be evaluated
			#|::debug::checking if shellspec is in the exclusion input
			#|::debug::no inclusions configured
			#|evaluating shellspec...
			#|::debug::shellspec current: 0.28.0, latest: 0.28.1
			#|update available for shellspec
			#|::debug::no skips configured
			#|::debug::installing shellspec@0.28.1
			#|::debug::applying shellspec@0.28.1 locally
			#|::debug::remaining update capacity: -1
			#|::debug::overriding 'updated-count' output with new value
			#|::endgroup::
		}

		snapshot_outputs() {
			%text
			#|updated-count=0
			#|updated-count=1
		}

		It 'succeeds'
			When run script bin/update.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
			The file "${GITHUB_OUTPUT}" should satisfy contents "$(snapshot_outputs)"
		End
	End

	Describe 'inclusions option'
		exclusions() {
			echo
		}

		inclusions() {
			%text
			#|shellcheck
		}

		max_capacity() {
			echo '0'
		}

		skips() {
			echo
		}

		tool_versions() {
			%text
			#|shellcheck 0.8.0
			#|shellspec 0.28.0
		}

		snapshot_stdout() {
			%text
			#|::debug::initializing outputs to their default value
			#|::debug::checking if .tool-versions file exists
			#|::group::Updating tools
			#|::debug::starting with update capacity: 0
			#|::debug::processing line ('shellcheck 0.8.0')
			#|::debug::checking if shellcheck should be evaluated
			#|::debug::no exclusions configured
			#|::debug::checking if shellcheck is NOT in the inclusion input
			#|evaluating shellcheck...
			#|::debug::shellcheck current: 0.8.0, latest: 0.9.0
			#|update available for shellcheck
			#|::debug::no skips configured
			#|::debug::installing shellcheck@0.9.0
			#|::debug::applying shellcheck@0.9.0 locally
			#|::debug::remaining update capacity: -1
			#|::debug::overriding 'updated-count' output with new value
			#|::debug::processing line ('shellspec 0.28.0')
			#|::debug::checking if shellspec should be evaluated
			#|::debug::no exclusions configured
			#|::debug::checking if shellspec is NOT in the inclusion input
			#|skipping shellspec because it is NOT in the inclusion input
			#|::endgroup::
		}

		snapshot_outputs() {
			%text
			#|updated-count=0
			#|updated-count=1
		}

		It 'succeeds'
			When run script bin/update.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
			The file "${GITHUB_OUTPUT}" should satisfy contents "$(snapshot_outputs)"
		End
	End

	Describe 'skips option'
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
			%text
			#|
			#|shellcheck 0.9.0
		}

		tool_versions() {
			%text
			#|shellcheck 0.8.0
			#|shellspec 0.28.0
		}

		snapshot_stdout() {
			%text
			#|::debug::initializing outputs to their default value
			#|::debug::checking if .tool-versions file exists
			#|::group::Updating tools
			#|::debug::starting with update capacity: 0
			#|::debug::processing line ('shellcheck 0.8.0')
			#|::debug::checking if shellcheck should be evaluated
			#|::debug::no exclusions configured
			#|::debug::no inclusions configured
			#|evaluating shellcheck...
			#|::debug::shellcheck current: 0.8.0, latest: 0.9.0
			#|update available for shellcheck
			#|::debug::checking if shellcheck@0.9.0 is in the skip input
			#|::debug::skipping empty skip input line
			#|::debug::processing skip input line ('shellcheck 0.9.0')
			#|::debug::found skip mandate for shellcheck@0.9.0
			#|skipping shellcheck@0.9.0 because it is in the skip input
			#|::debug::processing line ('shellspec 0.28.0')
			#|::debug::checking if shellspec should be evaluated
			#|::debug::no exclusions configured
			#|::debug::no inclusions configured
			#|evaluating shellspec...
			#|::debug::shellspec current: 0.28.0, latest: 0.28.1
			#|update available for shellspec
			#|::debug::checking if shellspec@0.28.1 is in the skip input
			#|::debug::skipping empty skip input line
			#|::debug::processing skip input line ('shellcheck 0.9.0')
			#|::debug::found skip mandate for shellcheck@0.9.0
			#|::debug::installing shellspec@0.28.1
			#|::debug::applying shellspec@0.28.1 locally
			#|::debug::remaining update capacity: -1
			#|::debug::overriding 'updated-count' output with new value
			#|::endgroup::
		}

		snapshot_outputs() {
			%text
			#|updated-count=0
			#|updated-count=1
		}

		It 'succeeds'
			When run script bin/update.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
			The file "${GITHUB_OUTPUT}" should satisfy contents "$(snapshot_outputs)"
		End
	End
End
