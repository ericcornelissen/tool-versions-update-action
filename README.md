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

## Actions

- [`tool-versions-update-action/commit`](./commit/README.md)
- [`tool-versions-update-action/pr`](./pr/README.md)

## License

All source code is licensed under the MIT license, see [LICENSE] for the full
license text. The contents of documentation is licensed under [CC BY 4.0].

[asdf]: https://asdf-vm.com/
[cc by 4.0]: https://creativecommons.org/licenses/by/4.0/
[github actions]: https://github.com/features/actions
[license]: ./LICENSE
