#!/bin/bash
# SPDX-License-Identifier: MIT

escape_markdown_table_pipes() {
	echo "${1//|/\\|}"
}
