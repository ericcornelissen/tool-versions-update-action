# Tool Versions Update Action - Pull Request

A [GitHub Action] to automatically update the tools in your `.tool-versions`
file through a Pull Request.

## Usage

```yml
- uses: ericcornelissen/tool-versions-update-action/pr@v0
  with:
    # A comma or newline-separated list of assignees for the Pull Request (by
    # their GitHub username).
    #
    # Default: ""
    assignees: ericcornelissen

    # The message to use for update commits.
    #
    # Default: Update .tool-versions
    commit-message: Update tooling

    # A comma or newline-separated list of labels.
    #
    # Default: *no labels*
    labels: tools

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

    # A list of newline-separated "plugin url" pairs that should be installed.
    # If omitted the default plugins will be available.
    #
    # Default: ""
    plugins: |
      actionlint https://github.com/crazy-matt/asdf-actionlint
      shellcheck https://github.com/luizm/asdf-shellcheck

    # The base branch to use for Pull Requests.
    #
    # Default: *current branch*
    pr-base: develop

    # The body text to use for Pull Requests.
    #
    # Default: Bump tools in `.tool-versions`
    pr-body: |
      _This Pull Request was generated using the `tool-versions-update-action`_

    # The title to use for Pull Requests.
    #
    # Default: Update `.tool-versions`
    pr-title: Update tooling

    # The $GITHUB_TOKEN or a repository scoped Personal Access Token (PAT).
    #
    # Default: $GITHUB_TOKEN
    token: ${{ github.token }}
```

### Outputs

The following outputs are made available:

| Name         | Description                                                |
| ------------ | ---------------------------------------------------------- |
| `commit-sha` | The SHA identifier of the created commit                   |
| `did-update` | `true` if at least one tool was updated, `false` otherwise |
| `pr-number`  | The number of the created Pull Request                     |

For information on how to use outputs see the [GitHub Actions output docs].

### Full Example

This example is for a workflow that can be triggered manually to create a Pull
Request to update at most 2 tools defined in `.tool-versions` at the time.

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
      pull-requests: write
    steps:
      - name: Update tooling
        uses: ericcornelissen/tool-versions-update-action/pr@v0
        with:
          max: 2
```

### Security

#### Permissions

This action requires the following permissions:

```yml
permissions:
  contents: write # To push a commit
  pull-requests: write # To open a Pull Request
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
