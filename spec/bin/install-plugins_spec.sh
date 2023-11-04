# shellcheck shell=bash
# SPDX-License-Identifier: MIT

BeforeEach 'clear_github_output'

Describe 'install-plugins.sh'
	setup() {
		export LIST="$(plugin_list)"
	}

	BeforeEach 'setup'

	Describe 'can install'
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

		It 'installs and succeeds'
			When run script bin/install-plugins.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
		End
	End

	Describe 'already installed'
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
			already_installed() {
				return 2
			}

			already_installed
		End

		It 'succeeds'
			When run script bin/install-plugins.sh
			The status should equal 0
			The output should equal "$(snapshot_stdout)"
		End
	End

	Describe 'cannot install'
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
			not_installed() {
				return 1
			}

			not_installed
		End

		It 'fails'
			When run script bin/install-plugins.sh
			The status should equal 1
			The output should equal "$(snapshot_stdout)"
		End
	End
End
