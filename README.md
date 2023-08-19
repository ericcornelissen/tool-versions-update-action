# Tool Versions Update Action

A collection of [GitHub Actions] to automatically update the tools in your
`.tool-versions` file.

The actions use [asdf] and various other GitHub Actions to try and update any
tools defined in your project's `.tool-versions` and apply those updates to the
project.

## Early Development Notice

This project is currently in early development and so you should expect breaking
changes from one version to the next. When using this action it is advised to
pin to an exact version or commit SHA.

The first stable release (if reached) will be v1.0.0.

## Usage

```yml
- uses: ericcornelissen/tool-versions-update-action@v0
  with:
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
```

### Batteries Included

While the base action allows for more freedom, you can use one of this project's
sub-actions to get up-and-running quickly with one-step automated tooling jobs.

- [`tool-versions-update-action/commit`](./commit/README.md)
- [`tool-versions-update-action/pr`](./pr/README.md)

### Outputs

The following outputs are made available:

| Name         | Description                                                |
| ------------ | ---------------------------------------------------------- |
| `did-update` | `true` if at least one tool was updated, `false` otherwise |

For information on how to use outputs see the [GitHub Actions output docs].

### Full Example

This example is for a workflow that can be triggered manually to log available
updates for at most 2 tools defined in `.tool-versions` at the time.

```yml
name: Tooling
on:
  workflow_dispatch: ~

permissions: read-all

jobs:
  tooling:
    name: Update tooling
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3
      - name: Install asdf
        uses: asdf-vm/actions/install@v2
      # Optionally configure asdf plugins depending on your needs.
      # - name: Configure asdf plugins
      #   run: |
      #     asdf plugin add example https://github.com/ericcornelissen/asdf-example
      - name: Update tooling
        uses: ericcornelissen/tool-versions-update-action/commit@v0
        id: tooling
        with:
          max: 2
      - name: Log tooling changes
        if: steps.tooling.outputs.did-update == 'true'
        run: git diff .tool-versions
```

### Security

#### Permissions

This action requires no permissions.

#### Network

This action requires network access to all endpoints your [asdf] plugins use.

## License

All source code is licensed under the MIT license, see [LICENSE] for the full
license text. The contents of documentation is licensed under [CC BY 4.0].

[asdf]: https://asdf-vm.com/
[cc by 4.0]: https://creativecommons.org/licenses/by/4.0/
[github actions]: https://github.com/features/actions
[github actions output docs]: https://help.github.com/en/actions/reference/contexts-and-expression-syntax-for-github-actions#steps-context
[license]: ./LICENSE
