# shellcheck shell=bash disable=SC2155,SC2218,SC2317,SC2329
# SPDX-License-Identifier: MIT

BeforeEach 'clear_github_output'

Describe 'bin/update.sh'
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
		command="$1"
		case "${command}" in
		'latest')
			tool="$2"
			case "${tool}" in
				'actionlint')
					echo '1.7.0'
					;;
				'shellcheck')
					echo '0.9.0'
					;;
				'shellspec')
					echo '0.28.1'
					;;
				'shfmt')
					echo '3.7.0'
					;;
			esac
			;;
		'install')
			# Nothing to do..
			;;
		'local')
			tool="$2"
			version="$3"
			sed -i "s/^${tool}.*$/${tool} ${version}/g" .tool-versions
			;;
		*)
			exit 127
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
			#|::debug::no exclusions configured
			#|::debug::no inclusions configured
			#|::debug::no skips configured
			#|::group::Updating tools
			#|::debug::starting with update capacity: 0
			#|::debug::skipping comment ('# file: .tool-versions')
			#|::debug::skipping empty line
			#|::debug::processing line ('shellcheck 0.9.0')
			#|evaluating shellcheck...
			#|::debug::shellcheck current: 0.9.0, latest: 0.9.0
			#|no update available for shellcheck
			#|::debug::processing line ('shellspec 0.28.1')
			#|evaluating shellspec...
			#|::debug::shellspec current: 0.28.1, latest: 0.28.1
			#|no update available for shellspec
			#|::debug::processing line ('shfmt 3.7.0')
			#|evaluating shfmt...
			#|::debug::shfmt current: 3.7.0, latest: 3.7.0
			#|no update available for shfmt
			#|::endgroup::
		}

		snapshot_outputs() {
			%text
			#|updated-count=0
			#|updated-tools=
			#|updated-old-versions=
			#|updated-new-versions=
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
			#|::debug::no exclusions configured
			#|::debug::no inclusions configured
			#|::debug::no skips configured
			#|::group::Updating tools
			#|::debug::starting with update capacity: 0
			#|::debug::processing line ('shellcheck 0.8.0')
			#|evaluating shellcheck...
			#|::debug::shellcheck current: 0.8.0, latest: 0.9.0
			#|update available for shellcheck
			#|::debug::installing shellcheck@0.9.0
			#|::debug::applying shellcheck@0.9.0 locally
			#|::debug::remaining update capacity: -1
			#|::debug::overriding 'updated-count' output with new value
			#|::debug::overriding 'updated-tools' output with new value
			#|::debug::overriding 'updated-old-versions' output with new value
			#|::debug::overriding 'updated-new-versions' output with new value
			#|::debug::processing line ('shellspec 0.28.0')
			#|evaluating shellspec...
			#|::debug::shellspec current: 0.28.0, latest: 0.28.1
			#|update available for shellspec
			#|::debug::installing shellspec@0.28.1
			#|::debug::applying shellspec@0.28.1 locally
			#|::debug::remaining update capacity: -2
			#|::debug::overriding 'updated-count' output with new value
			#|::debug::overriding 'updated-tools' output with new value
			#|::debug::overriding 'updated-old-versions' output with new value
			#|::debug::overriding 'updated-new-versions' output with new value
			#|::debug::processing line ('shfmt 3.6.1')
			#|evaluating shfmt...
			#|::debug::shfmt current: 3.6.1, latest: 3.7.0
			#|update available for shfmt
			#|::debug::installing shfmt@3.7.0
			#|::debug::applying shfmt@3.7.0 locally
			#|::debug::remaining update capacity: -3
			#|::debug::overriding 'updated-count' output with new value
			#|::debug::overriding 'updated-tools' output with new value
			#|::debug::overriding 'updated-old-versions' output with new value
			#|::debug::overriding 'updated-new-versions' output with new value
			#|::endgroup::
		}

		snapshot_outputs() {
			%text
			#|updated-count=0
			#|updated-tools=
			#|updated-old-versions=
			#|updated-new-versions=
			#|updated-count=1
			#|updated-tools=shellcheck
			#|updated-old-versions=0.8.0
			#|updated-new-versions=0.9.0
			#|updated-count=2
			#|updated-tools=shellcheck,shellspec
			#|updated-old-versions=0.8.0,0.28.0
			#|updated-new-versions=0.9.0,0.28.1
			#|updated-count=3
			#|updated-tools=shellcheck,shellspec,shfmt
			#|updated-old-versions=0.8.0,0.28.0,3.6.1
			#|updated-new-versions=0.9.0,0.28.1,3.7.0
		}

		It 'succeeds'
			When run script bin/update.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
			The file "${GITHUB_OUTPUT}" should satisfy contents "$(snapshot_outputs)"
		End
	End

	Describe 'an update shortens the .tool-versions file mid-updating'
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
			#|actionlint 1.6.27
			#|shellspec 0.28.1
		}

		snapshot_stdout() {
			%text
			#|::debug::initializing outputs to their default value
			#|::debug::checking if .tool-versions file exists
			#|::debug::no exclusions configured
			#|::debug::no inclusions configured
			#|::debug::no skips configured
			#|::group::Updating tools
			#|::debug::starting with update capacity: 0
			#|::debug::processing line ('actionlint 1.6.27')
			#|evaluating actionlint...
			#|::debug::actionlint current: 1.6.27, latest: 1.7.0
			#|update available for actionlint
			#|::debug::installing actionlint@1.7.0
			#|::debug::applying actionlint@1.7.0 locally
			#|::debug::remaining update capacity: -1
			#|::debug::overriding 'updated-count' output with new value
			#|::debug::overriding 'updated-tools' output with new value
			#|::debug::overriding 'updated-old-versions' output with new value
			#|::debug::overriding 'updated-new-versions' output with new value
			#|::debug::processing line ('shellspec 0.28.1')
			#|evaluating shellspec...
			#|::debug::shellspec current: 0.28.1, latest: 0.28.1
			#|no update available for shellspec
			#|::endgroup::
		}

		snapshot_outputs() {
			%text
			#|updated-count=0
			#|updated-tools=
			#|updated-old-versions=
			#|updated-new-versions=
			#|updated-count=1
			#|updated-tools=actionlint
			#|updated-old-versions=1.6.27
			#|updated-new-versions=1.7.0
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
			#|::debug::no exclusions configured
			#|::debug::no inclusions configured
			#|::debug::no skips configured
			#|::group::Updating tools
			#|::debug::starting with update capacity: 2
			#|::debug::processing line ('shellcheck 0.8.0')
			#|evaluating shellcheck...
			#|::debug::shellcheck current: 0.8.0, latest: 0.9.0
			#|update available for shellcheck
			#|::debug::installing shellcheck@0.9.0
			#|::debug::applying shellcheck@0.9.0 locally
			#|::debug::remaining update capacity: 1
			#|::debug::overriding 'updated-count' output with new value
			#|::debug::overriding 'updated-tools' output with new value
			#|::debug::overriding 'updated-old-versions' output with new value
			#|::debug::overriding 'updated-new-versions' output with new value
			#|::debug::processing line ('shellspec 0.28.0')
			#|evaluating shellspec...
			#|::debug::shellspec current: 0.28.0, latest: 0.28.1
			#|update available for shellspec
			#|::debug::installing shellspec@0.28.1
			#|::debug::applying shellspec@0.28.1 locally
			#|::debug::remaining update capacity: 0
			#|::debug::overriding 'updated-count' output with new value
			#|::debug::overriding 'updated-tools' output with new value
			#|::debug::overriding 'updated-old-versions' output with new value
			#|::debug::overriding 'updated-new-versions' output with new value
			#|finished updating after 2 update(s)
			#|::endgroup::
		}

		snapshot_outputs() {
			%text
			#|updated-count=0
			#|updated-tools=
			#|updated-old-versions=
			#|updated-new-versions=
			#|updated-count=1
			#|updated-tools=shellcheck
			#|updated-old-versions=0.8.0
			#|updated-new-versions=0.9.0
			#|updated-count=2
			#|updated-tools=shellcheck,shellspec
			#|updated-old-versions=0.8.0,0.28.0
			#|updated-new-versions=0.9.0,0.28.1
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
			#|::debug::no inclusions configured
			#|::debug::no skips configured
			#|::group::Updating tools
			#|::debug::starting with update capacity: 0
			#|::debug::processing line ('shellcheck 0.8.0')
			#|::debug::checking if shellcheck is in the exclusion input
			#|skipping shellcheck because it is in the exclusion input
			#|::debug::processing line ('shellspec 0.28.0')
			#|::debug::checking if shellspec is in the exclusion input
			#|evaluating shellspec...
			#|::debug::shellspec current: 0.28.0, latest: 0.28.1
			#|update available for shellspec
			#|::debug::installing shellspec@0.28.1
			#|::debug::applying shellspec@0.28.1 locally
			#|::debug::remaining update capacity: -1
			#|::debug::overriding 'updated-count' output with new value
			#|::debug::overriding 'updated-tools' output with new value
			#|::debug::overriding 'updated-old-versions' output with new value
			#|::debug::overriding 'updated-new-versions' output with new value
			#|::endgroup::
		}

		snapshot_outputs() {
			%text
			#|updated-count=0
			#|updated-tools=
			#|updated-old-versions=
			#|updated-new-versions=
			#|updated-count=1
			#|updated-tools=shellspec
			#|updated-old-versions=0.28.0
			#|updated-new-versions=0.28.1
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
			#|::debug::no exclusions configured
			#|::debug::no skips configured
			#|::group::Updating tools
			#|::debug::starting with update capacity: 0
			#|::debug::processing line ('shellcheck 0.8.0')
			#|::debug::checking if shellcheck is NOT in the inclusion input
			#|evaluating shellcheck...
			#|::debug::shellcheck current: 0.8.0, latest: 0.9.0
			#|update available for shellcheck
			#|::debug::installing shellcheck@0.9.0
			#|::debug::applying shellcheck@0.9.0 locally
			#|::debug::remaining update capacity: -1
			#|::debug::overriding 'updated-count' output with new value
			#|::debug::overriding 'updated-tools' output with new value
			#|::debug::overriding 'updated-old-versions' output with new value
			#|::debug::overriding 'updated-new-versions' output with new value
			#|::debug::processing line ('shellspec 0.28.0')
			#|::debug::checking if shellspec is NOT in the inclusion input
			#|skipping shellspec because it is NOT in the inclusion input
			#|::endgroup::
		}

		snapshot_outputs() {
			%text
			#|updated-count=0
			#|updated-tools=
			#|updated-old-versions=
			#|updated-new-versions=
			#|updated-count=1
			#|updated-tools=shellcheck
			#|updated-old-versions=0.8.0
			#|updated-new-versions=0.9.0
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
			#|::debug::no exclusions configured
			#|::debug::no inclusions configured
			#|::group::Updating tools
			#|::debug::starting with update capacity: 0
			#|::debug::processing line ('shellcheck 0.8.0')
			#|evaluating shellcheck...
			#|::debug::shellcheck current: 0.8.0, latest: 0.9.0
			#|update available for shellcheck
			#|::debug::checking if shellcheck@0.9.0 is in the skip input
			#|::debug::skipping empty skip input line
			#|::debug::processing skip input line ('shellcheck 0.9.0')
			#|::debug::found skip mandate for shellcheck@0.9.0
			#|skipping shellcheck@0.9.0 because it is in the skip input
			#|::debug::processing line ('shellspec 0.28.0')
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
			#|::debug::overriding 'updated-tools' output with new value
			#|::debug::overriding 'updated-old-versions' output with new value
			#|::debug::overriding 'updated-new-versions' output with new value
			#|::endgroup::
		}

		snapshot_outputs() {
			%text
			#|updated-count=0
			#|updated-tools=
			#|updated-old-versions=
			#|updated-new-versions=
			#|updated-count=1
			#|updated-tools=shellspec
			#|updated-old-versions=0.28.0
			#|updated-new-versions=0.28.1
		}

		It 'succeeds'
			When run script bin/update.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
			The file "${GITHUB_OUTPUT}" should satisfy contents "$(snapshot_outputs)"
		End
	End

	Describe 'asdf failure'
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
		}

		Describe 'latest could not be obtained'
			Mock asdf
				case "$1" in
				'latest')
					exit 1
					;;
				'install')
					;;
				'local')
					;;
				*)
					exit 127
					;;
				esac
			End

			It 'fails'
				When run script bin/update.sh
				The status should equal 1
				The output should not equal ''
			End
		End

		Describe 'latest could not be installed'
			Mock asdf
				case "$1" in
				'latest')
					echo '0.9.0'
					;;
				'install')
					exit 2
					;;
				'local')
					;;
				*)
					exit 127
					;;
				esac
			End

			It 'fails'
				When run script bin/update.sh
				The status should equal 2
				The output should not equal ''
			End
		End

		Describe 'latest could not be applied locally'
			Mock asdf
				case "$1" in
				'latest')
					echo '0.9.0'
					;;
				'install')
					;;
				'local')
					exit 3
					;;
				*)
					exit 127
					;;
				esac
			End

			It 'fails'
				When run script bin/update.sh
				The status should equal 3
				The output should not equal ''
			End
		End
	End

	Describe 'no .tool-versions file'
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
			echo
		}

		snapshot_stdout() {
			%text
			#|::debug::initializing outputs to their default value
			#|::debug::checking if .tool-versions file exists
			#|::error::no .tool-versions file found, it must be present at the root of your project in order for this action to work
		}

		snapshot_outputs() {
			%text
			#|updated-count=0
			#|updated-tools=
			#|updated-old-versions=
			#|updated-new-versions=
		}

		remove_tool_versions() {
			rm -f .tool-versions
		}

		BeforeEach 'remove_tool_versions'

		It 'succeeds'
			When run script bin/update.sh
			The status should equal 1
			The output should equal "$(snapshot_stdout)"
			The file "${GITHUB_OUTPUT}" should satisfy contents "$(snapshot_outputs)"
		End
	End
End
