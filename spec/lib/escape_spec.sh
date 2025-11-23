# shellcheck shell=bash
# SPDX-License-Identifier: MIT

Describe 'lib/escape.sh'
	Include lib/escape.sh

	Describe 'escape_markdown_table_pipes'
		Describe 'basic escaping'
			Parameters
				'hello' 'hello'
				'foo bar' 'foo bar'
			End

			It "escapes '$1' correctly"
				When call escape_markdown_table_pipes "$1"
				The output should equal "$2"
			End
		End

		Describe 'pipe characters'
			It 'can escape single pipe'
				When call escape_markdown_table_pipes 'foo|bar'
				The output should equal 'foo\|bar'
			End

			It 'can escape multiple pipes'
				When call escape_markdown_table_pipes 'a|b|c|d'
				The output should equal 'a\|b\|c\|d'
			End

			It 'can escape pipes at boundaries'
				When call escape_markdown_table_pipes '|start and end|'
				The output should equal '\|start and end\|'
			End

			It 'preserves other special characters'
				When call escape_markdown_table_pipes 'foo|bar "with" quotes'
				The output should equal 'foo\|bar "with" quotes'
			End
		End
	End
End
