# shellcheck shell=bash
# SPDX-License-Identifier: MIT

BeforeEach 'clear_github_output'

Describe 'actions.sh'
	Include lib/actions.sh

	Describe 'debug logging'
		Parameters
			'#1' 'foobar'
			'#2' 'Something interesting happened'
		End

		It "can write a debug log (case $1)"
			When call debug "$2"
			The output should equal "::debug::$2"
		End
	End

	Describe 'error logging'
		Parameters
			'#1' 'foobar'
			'#2' 'That didn''t go well'
		End

		It "can write an error log (case $1)"
			When call error "$2"
			The output should equal "::error::$2"
		End
	End

	Describe 'info logging'
		Parameters
			'#1' 'foobar'
			'#2' 'Making progres...'
		End

		It "can write an info log (case $1)"
			When call info "$2"
			The output should equal "$2"
		End
	End

	Describe 'log groups'
		It 'can start a (named) group'
			When call group_start name
			The output should equal '::group::name'
		End

		It 'can end a group'
			When call group_end
			The output should equal '::endgroup::'
		End
	End

	Describe 'outputs'
		Describe 'single'
			Parameters
				'#1' 'foo' 'bar'
				'#2' 'answer' '42'
			End

			It "can set an output (case $1)"
				When call set_output "$2" "$3"
				The output should equal ''
				The file "${GITHUB_OUTPUT}" should satisfy contents "$2=$3"
			End
		End

		Describe 'multiple'
			It 'can set multiple different outputs'
				result() {
					%text
					#|foo=bar
					#|hello=world
				}

				When call set_output 'foo' 'bar' && set_output 'hello' 'world'
				The output should equal ''
				The file "${GITHUB_OUTPUT}" should satisfy contents "$(result)"
			End

			It 'can set the same output multiple times'
				result() {
					%text
					#|foo=bar
					#|foo=baz
				}

				When call set_output 'foo' 'bar' && set_output 'foo' 'baz'
				The output should equal ''
				The file "${GITHUB_OUTPUT}" should satisfy contents "$(result)"
			End
		End
	End
End
