# shellcheck shell=bash disable=SC2155,SC2317
# SPDX-License-Identifier: MIT

BeforeEach 'clear_github_output'

Describe 'bin/install-plugins.sh'
	setup() {
		export LIST="$(plugin_list)"
	}

	BeforeEach 'setup'

	Describe 'installation possible'
		plugin_list() {
			%text
			#|
			#|actionlint https://github.com/crazy-matt/asdf-actionlint
			#|
			#|shellcheck https://github.com/luizm/asdf-shellcheck
		}

		snapshot_stdout() {
			%text
			#|::group::Configuring asdf plugins
			#|::debug::skipping empty line
			#|::debug::processing line ('actionlint https://github.com/crazy-matt/asdf-actionlint')
			#|::debug::provided url for actionlint is 'https://github.com/crazy-matt/asdf-actionlint'
			#|installing plugin for actionlint...
			#|plugin actionlint installed
			#|::debug::skipping empty line
			#|::debug::processing line ('shellcheck https://github.com/luizm/asdf-shellcheck')
			#|::debug::provided url for shellcheck is 'https://github.com/luizm/asdf-shellcheck'
			#|installing plugin for shellcheck...
			#|plugin shellcheck installed
			#|::endgroup::
		}

		Mock asdf
			# Nothing to do
		End

		It 'can install and succeeds'
			When run script bin/install-plugins.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
		End
	End

	Describe 'installion unnecessary'
		plugin_list() {
			%text
			#|actionlint https://github.com/crazy-matt/asdf-actionlint
		}

		snapshot_stdout() {
			%text
			#|::group::Configuring asdf plugins
			#|::debug::processing line ('actionlint https://github.com/crazy-matt/asdf-actionlint')
			#|::debug::provided url for actionlint is 'https://github.com/crazy-matt/asdf-actionlint'
			#|installing plugin for actionlint...
			#|plugin actionlint already installed
			#|::endgroup::
		}

		Mock asdf
			exit 2
		End

		It 'does nothing and succeeds'
			When run script bin/install-plugins.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
		End
	End

	Describe 'installation impossible'
		plugin_list() {
			%text
			#|shellcheck https://github.com/luizm/asdf-shellcheck
		}

		snapshot_stdout() {
			%text
			#|::group::Configuring asdf plugins
			#|::debug::processing line ('shellcheck https://github.com/luizm/asdf-shellcheck')
			#|::debug::provided url for shellcheck is 'https://github.com/luizm/asdf-shellcheck'
			#|installing plugin for shellcheck...
			#|plugin shellcheck could not be installed
			#|::endgroup::
		}

		Mock asdf
			exit 1
		End

		It 'fails gracefully'
			When run script bin/install-plugins.sh
			The status should equal 1
			The output should equal "$(snapshot_stdout)"
		End
	End
End
