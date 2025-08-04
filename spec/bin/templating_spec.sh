# shellcheck shell=bash disable=SC2155,SC2218,SC2317,SC2329
# SPDX-License-Identifier: MIT

BeforeEach 'clear_github_output'

Describe 'bin/templating.sh'
	setup() {
		export UPDATED_COUNT=2
		export UPDATED_NEW_VERSIONS='0.9.0,0.28.1'
		export UPDATED_OLD_VERSIONS='0.8.0,0.28.0'
		export UPDATED_TOOLS='shellcheck,shellspec'
		export TEXT="$(input)"
	}

	BeforeEach 'setup'

	Describe '{{updated-count}}'
		input() {
			%text
			#|Update {{updated-count}} tool(s)
		}

		snapshot_stdout() {
			%text
			#|::debug::input for templating is 'Update {{updated-count}} tool(s)'
			#|::debug::substitute '{{updated-count}}' for '2'
			#|::debug::substitute '{{updated-new-versions}}' for '0.9.0,0.28.1'
			#|::debug::substitute '{{updated-old-versions}}' for '0.8.0,0.28.0'
			#|::debug::substitute '{{updated-tools}}' for 'shellcheck,shellspec'
			#|::debug::setting output
		}

		snapshot_output() {
			%text
			#|value=Update 2 tool(s)
		}

		It 'works for a simple example'
			When run script bin/templating.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
			The file "${GITHUB_OUTPUT}" should satisfy contents "$(snapshot_output)"
		End
	End

	Describe '{{updated-new-versions}}'
		input() {
			%text
			#|The new versions are {{updated-new-versions}}
		}

		snapshot_stdout() {
			%text
			#|::debug::input for templating is 'The new versions are {{updated-new-versions}}'
			#|::debug::substitute '{{updated-count}}' for '2'
			#|::debug::substitute '{{updated-new-versions}}' for '0.9.0,0.28.1'
			#|::debug::substitute '{{updated-old-versions}}' for '0.8.0,0.28.0'
			#|::debug::substitute '{{updated-tools}}' for 'shellcheck,shellspec'
			#|::debug::setting output
		}

		snapshot_output() {
			%text
			#|value=The new versions are 0.9.0,0.28.1
		}

		It 'works for a simple example'
			When run script bin/templating.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
			The file "${GITHUB_OUTPUT}" should satisfy contents "$(snapshot_output)"
		End
	End

	Describe '{{updated-old-versions}}'
		input() {
			%text
			#|The old versions are {{updated-old-versions}}
		}

		snapshot_stdout() {
			%text
			#|::debug::input for templating is 'The old versions are {{updated-old-versions}}'
			#|::debug::substitute '{{updated-count}}' for '2'
			#|::debug::substitute '{{updated-new-versions}}' for '0.9.0,0.28.1'
			#|::debug::substitute '{{updated-old-versions}}' for '0.8.0,0.28.0'
			#|::debug::substitute '{{updated-tools}}' for 'shellcheck,shellspec'
			#|::debug::setting output
		}

		snapshot_output() {
			%text
			#|value=The old versions are 0.8.0,0.28.0
		}

		It 'works for a simple example'
			When run script bin/templating.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
			The file "${GITHUB_OUTPUT}" should satisfy contents "$(snapshot_output)"
		End
	End

	Describe '{{updated-tools}}'
		input() {
			%text
			#|Update tool(s) {{updated-tools}}
		}

		snapshot_stdout() {
			%text
			#|::debug::input for templating is 'Update tool(s) {{updated-tools}}'
			#|::debug::substitute '{{updated-count}}' for '2'
			#|::debug::substitute '{{updated-new-versions}}' for '0.9.0,0.28.1'
			#|::debug::substitute '{{updated-old-versions}}' for '0.8.0,0.28.0'
			#|::debug::substitute '{{updated-tools}}' for 'shellcheck,shellspec'
			#|::debug::setting output
		}

		snapshot_output() {
			%text
			#|value=Update tool(s) shellcheck,shellspec
		}

		It 'works for a simple example'
			When run script bin/templating.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
			The file "${GITHUB_OUTPUT}" should satisfy contents "$(snapshot_output)"
		End
	End
End
