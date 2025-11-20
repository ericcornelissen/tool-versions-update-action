# shellcheck shell=bash
# SPDX-License-Identifier: MIT

BeforeEach 'clear_github_output'

Describe 'lib/actions.sh'
	Include lib/actions.sh

	Describe 'debug logging'
		Describe 'single-line'
			Parameters
				'foobar'
				'Something happened'
			End

			It "can write a debug log ('$1')"
				When call debug "$1"
				The output should equal "::debug::$1"
			End
		End

		Describe 'multi-line'
			value() {
				%text
				#|foo
				#|bar
			}
			result() {
				%text
				#|::debug::foo
				#|::debug::bar
			}

			It 'can write an error log'
				When call debug "$(value)"
				The output should equal "$(result)"
			End
		End
	End

	Describe 'error logging'
		Describe 'single-line'
			Parameters
				'foobar'
				'That didn''t go well'
			End

			It "can write an error log ('$1')"
				When call error "$1"
				The output should equal "::error::$1"
			End
		End

		Describe 'multi-line'
			value() {
				%text
				#|hello
				#|world
			}
			result() {
				%text
				#|::error::hello
				#|::error::world
			}

			It 'can write an error log'
				When call error "$(value)"
				The output should equal "$(result)"
			End
		End
	End

	Describe 'info logging'
		Parameters
			'foobar'
			'Making progres'
		End

		It "can write an info log ('$1')"
			When call info "$1"
			The output should equal "$1"
		End
	End

	Describe 'log groups'
		Describe 'start'
			Parameters
				'foobar'
				'Stage 1'
			End

			It "can start a named group ('$1')"
				When call group_start "$1"
				The output should equal "::group::$1"
			End
		End

		It 'can end a group'
			When call group_end
			The output should equal '::endgroup::'
		End
	End

	Describe 'outputs'
		Describe 'single'
			Parameters
				'foo' 'bar'
				'answer' '42'
			End

			It "can set an output ('$1=$2')"
				When call set_output "$1" "$2"
				The output should equal ''
				The file "${GITHUB_OUTPUT}" should satisfy contents "$1=$2"
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

		It 'can output a multi-line value'
			value() {
				%text
				#|hello
				#|world
			}
			result() {
				%text
				#|multiline<<EOF
				#|hello
				#|world
				#|EOF
			}

			When call set_output 'multiline' "$(value)"
			The output should equal ''
			The file "${GITHUB_OUTPUT}" should satisfy contents "$(result)"
		End
	End

	Describe 'escape_json'
		Describe 'basic escaping'
			Parameters
				'hello' 'hello'
				'foo bar' 'foo bar'
			End

			It "escapes '$1' correctly"
				When call escape_json "$1"
				The output should equal "$2"
			End
		End

		Describe 'special characters'
			It 'can escape backslashes'
				When call escape_json 'path\to\file'
				The output should equal 'path\\to\\file'
			End

			It 'can escape double quotes'
				When call escape_json 'say "hello"'
				The output should equal 'say \"hello\"'
			End

			It 'can escape tabs'
				When call escape_json $'hello\tworld'
				The output should equal 'hello\tworld'
			End

			It 'can escape newlines'
				When call escape_json $'hello\nworld'
				The output should equal 'hello\nworld'
			End

			It 'can escape carriage returns'
				When call escape_json $'hello\rworld'
				The output should equal 'hello\rworld'
			End

			It 'can escape multiple special characters'
				When call escape_json $'path\\to\\"file"\nwith\ttabs'
				The output should equal 'path\\to\\\"file\"\nwith\ttabs'
			End
		End
	End

	Describe 'escape_pipes'
		Describe 'basic escaping'
			Parameters
				'hello' 'hello'
				'foo bar' 'foo bar'
			End

			It "escapes '$1' correctly"
				When call escape_pipes "$1"
				The output should equal "$2"
			End
		End

		Describe 'pipe characters'
			It 'can escape single pipe'
				When call escape_pipes 'foo|bar'
				The output should equal 'foo\|bar'
			End

			It 'can escape multiple pipes'
				When call escape_pipes 'a|b|c|d'
				The output should equal 'a\|b\|c\|d'
			End

			It 'can escape pipes at boundaries'
				When call escape_pipes '|start and end|'
				The output should equal '\|start and end\|'
			End

			It 'preserves other special characters'
				When call escape_pipes 'foo|bar "with" quotes'
				The output should equal 'foo\|bar "with" quotes'
			End
		End
	End
End
