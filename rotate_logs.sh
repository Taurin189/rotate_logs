#!/bin/bash
function usage {
    cat <<EOF
$(basename ${0}) is a tool for rotate *.log files.

Usage:
  $(basename ${0}) [command] ([options])

options:
  --exec-path=<path>   set rotate target path
  --rotate-path=<path> set rotate target path
  --config-path=<path> set config file path

commands:
  [no commands]: display usage or display
  all: rotate all (.log) files ignoring target_files which are written in config file.
  targets: rotate only target_files (.log) files which are written in config file.
EOF
}

usage
