<!-- SPDX-License-Identifier: CC0-1.0 -->

# Security Policy

The maintainers of the _Tool Versions Update Action_ project take security
issues seriously. We appreciate your efforts to responsibly disclose your
findings. Due to the non-funded and open-source nature of the project, we take a
best-efforts approach when it comes to engaging with security reports.

This document should be considered expired after 2026-01-01. If you are reading
this after that date you should try to find an up-to-date version in the
official source repository.

## Supported Versions

The table below shows which versions of the project are currently supported
with security updates.

| Version | End-of-life |
| ------: | :---------- |
|   2.x.x | -           |
|   1.x.x | 2026-01-01  |
|   0.x.x | 2024-01-15  |

_This table only includes information on versions `<3.0.0`._

## Reporting a Vulnerability

To report a security issue in the latest version of a supported version range,
either (in order of preference):

- [Report it through GitHub][new github advisory], or
- Send an email to [security@ericcornelissen.dev] with the terms "SECURITY" and
  "tool-versions-update-action" in the subject line.

Please do not open a regular issue or Pull Request in the public repository.

To report a security issue in an unsupported version of the project, or if the
latest version of a supported version range isn't affected, please report it
publicly. For example, as a regular issue in the public repository. If in doubt,
report the issue privately.

[new github advisory]: https://github.com/ericcornelissen/tool-versions-update-action/security/advisories/new
[security@ericcornelissen.dev]: mailto:security@ericcornelissen.dev?subject=SECURITY%20%28tool-versions-update-action%29

### What to Include in a Report

Try to include as many of the following items as possible in a security report:

- An explanation of the issue
- A proof of concept exploit
- A suggested severity
- Relevant [CWE] identifiers
- The latest affected version
- The earliest affected version
- A suggested patch

[cwe]: https://cwe.mitre.org/

### Threat Model

The action considers the GitHub Actions runner, Bash, `asdf`, any default and
user-specified `asdf` plugins, and any third-party GitHub Action used to be
trusted. All external inputs, including from the workflow and the target
repository, are considered untrusted. Any violation of confidentiality,
integrity, or availability is considered a security issue.

The project considers the GitHub infrastructure and all project maintainers to
be trusted. Any action that is performed on the repository by any other GitHub
user is considered untrusted.

## Advisories

> **Note**: Advisories will be created only for vulnerabilities present in
> released versions of the project.

| ID               | Date       | Affected versions | Patched versions |
| :--------------- | :--------- | :---------------- | :--------------- |
| -                | -          | -                 | -                |

_This table is ordered most to least recent._

## Acknowledgments

We would like to publicly thank the following reporters:

- _None yet_
