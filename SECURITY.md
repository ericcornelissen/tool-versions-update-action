<!-- SPDX-License-Identifier: CC0-1.0 -->

# Security Policy

The maintainers of the _Tool Versions Update Action_ project take security
issues seriously. We appreciate your efforts to responsibly disclose your
findings. Due to the non-funded and open-source nature of the project, we take a
best-efforts approach when it comes to engaging with security reports.

This document should be considered expired after 2027-01-01. If you are reading
this after that date, try to find an up-to-date version in the official source
repository.

## Supported Versions

The table below shows which versions of the project are currently supported with
security updates.

| Version | End-of-life |
| ------: | :---------- |
|   2.x.x | -           |
|   1.x.x | 2026-01-01  |
|   0.x.x | 2024-01-15  |

## Reporting a Vulnerability

To report a security issue in a supported version or the development head of the
project, either (in order of preference):

- [Report it through GitHub][new github advisory], or
- Send an email to [ericornelissen+security@gmail.com] with the terms "SECURITY"
  and "tool-versions-update-action" in the subject line.

Please do not open a regular issue or Pull Request in the public repository.

If a security issue only affects an unsupported version of the project, or the
latest version of a supported version range is not affected, please report it
publicly. For example, as a regular issue in the public repository. If in doubt,
report the issue privately.

[new github advisory]: https://github.com/ericcornelissen/tool-versions-update-action/security/advisories/new
[ericornelissen+security@gmail.com]: mailto:ericornelissen+security@gmail.com?subject=SECURITY%20%28tool-versions-update-action%29

### When to Report

Consider if the issue you found really is a security concern. Below you can find
guidelines for what is and is not considered a security issue. Any issue that
does not fall into one of the listed categories should be reported based on your
own judgement. If in doubt, report the issue privately.

Any issue that is out of scope should still be reported, but can be reported
publicly because it is not considered sensitive.

#### In Scope

- Violations of the confidentiality of the repository being operated on.
- Insecure suggestions or snippets in the documentation.
- Security misconfigurations in the continuous integration and delivery pipeline
  or software supply chain.

#### Out of Scope

- Bugs in code not part of a published artifact.
- Insecure defaults or confusing API design.
- Known vulnerabilities in third-party dependencies.

### What to Include in a Report

Try to include as many of the following items as possible in a security report:

- An explanation of the issue
- A proof of concept exploit
- A suggested severity
- Relevant [CWE] identifiers
- The latest affected version
- The earliest affected version
- A suggested patch
- An automated regression test
- A fuzz input seed or test

[cwe]: https://cwe.mitre.org/

## Threat Model

The action considers the GitHub Actions runner, Bash, `asdf`, any default and
user-specified `asdf` plugins, and any third-party GitHub Action used to be
trusted. All external inputs, including from the workflow and the target
repository, are considered untrusted. Any violation of confidentiality,
integrity, or availability is considered a security issue.

The project considers the GitHub infrastructure and all project maintainers to
be trusted. Any action that is performed on the repository by any other GitHub
user is considered untrusted.

## Advisories

An advisory will be created only if a vulnerability affects at least one
released versions of the project. The affected versions range of an advisory
will by default include all unsupported versions of the project at the time of
disclosure.

All advisories are listed in the table below, ordered most to least recent by
publication date.

| ID               | Date       | Affected version(s) | Patched version(s) |
| :--------------- | :--------- | :------------------ | :----------------- |
| -                | -          | -                   | -                  |

## Acknowledgments

If you conduct a security audit of this project we would like to acknowledge it.
If you found a security issue, you will be credited in the advisory. If you find
nothing but the audit report is publicly available we will acknowledge it too.

We would like to publicly thank the following reporters:

- _None yet_
