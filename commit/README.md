<!-- SPDX-License-Identifier: CC-BY-4.0 -->

# Tool Versions Update Action - Commit

A [GitHub Action] to automatically update the tools in your `.tool-versions`
file through a commit.

## Usage

```yml
- uses: ericcornelissen/tool-versions-update-action/commit@v0
  with:
    # The branch to commit to.
    #
    # Default: *current or default branch*
    branch: develop

    # The message to use for commits.
    #
    # Default: "Update .tool-versions"
    commit-message: Update tooling

    # The maximum number of tools to update. 0 indicates no maximum.
    #
    # Default: 0
    max: 2

    # A comma-separated list of tools that should NOT be updated.
    #
    # Default: ""
    not: actionlint,shfmt

    # A comma-separated list of tools that should be updated, ignoring others.
    #
    # Default: ""
    only: shellcheck

    # A newline-separated list of "plugin url" pairs that should be installed.
    # If omitted the default plugins will be available.
    #
    # Default: ""
    plugins: |
      actionlint https://github.com/crazy-matt/asdf-actionlint
      shellcheck https://github.com/luizm/asdf-shellcheck

    # Add "Signed-off-by" line at the end of the commit message. See `--signoff`
    # in <https://git-scm.com/docs/git-commit> for more detail.
    #
    # Default: false
    signoff: true

    # A newline-separated list of "tool version" pairs that should NOT be
    # updated to.
    #
    # Default: ""
    skip: |
      shfmt 3.6.0
      yamllint 1.31.0

    # The $GITHUB_TOKEN or a repository scoped Personal Access Token (PAT).
    #
    # Default: $GITHUB_TOKEN
    token: ${{ github.token }}
```

### Outputs

The following outputs are made available:

| Name            | Description                                                |
| --------------- | ---------------------------------------------------------- |
| `commit-sha`    | The SHA identifier of the created commit                   |
| `did-update`    | `true` if at least one tool was updated, `false` otherwise |
| `updated-count` | The number of tools that were updated                      |
| `updated-tools` | A comma separated list of the names of the updated tools   |

For information on how to use outputs see the [GitHub Actions output docs].

### Full Example

This example is for a workflow that can be triggered manually to create a commit
to update at most 2 tools defined in `.tool-versions` at the time.

```yml
name: Tooling
on:
  workflow_dispatch: ~

permissions: read-all

jobs:
  tooling:
    name: Update tooling
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - name: Update tooling
        uses: ericcornelissen/tool-versions-update-action/commit@v0
        with:
          max: 2
```

### Runners

This action is tested on the official [`ubuntu-20.04`] and [`ubuntu-22.04`]
runner images. It is recommended to use one of these images when using this
action.

### Security

#### Permissions

This action requires the following permissions:

```yml
permissions:
  contents: write # To push a commit
```

#### Network

This action requires network access to:

```txt
github.com:443
objects.githubusercontent.com:443
```

in addition to any endpoints your [asdf] plugins use.

---

The contents of this document are licensed under [CC BY 4.0].

[asdf]: https://asdf-vm.com/
[cc by 4.0]: https://creativecommons.org/licenses/by/4.0/
[github action]: https://github.com/features/actions
[github actions output docs]: https://help.github.com/en/actions/reference/contexts-and-expression-syntax-for-github-actions#steps-context
[`ubuntu-20.04`]: https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2004-Readme.md
[`ubuntu-22.04`]: https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2204-Readme.md
