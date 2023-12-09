# shellcheck shell=bash disable=SC2155,SC2317
# SPDX-License-Identifier: MIT

BeforeEach 'clear_github_output'

Describe 'bin/templating.sh'
	setup() {
		export UPDATED_COUNT=2
		export UPDATED_TOOLS='shellcheck,shellspec'
		export TEMPLATE="$(input)"
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

	Describe '{{updated-tools}}'
		input() {
			%text
			#|Update tool(s) {{updated-tools}}
		}

		snapshot_stdout() {
			%text
			#|::debug::input for templating is 'Update tool(s) {{updated-tools}}'
			#|::debug::substitute '{{updated-count}}' for '2'
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
