#!/usr/bin/env bash

script_echo() {
  command printf %s\\n "$*" 2>/dev/null || {
    script_echo() {
      # shellcheck disable=SC1001
      \printf %s\\n "$*" # on zsh, `command printf` sometimes fails
    }
    script_echo "$@"
  }
}

arcanist-manager() {
  if [ $# -lt 1 ]; then
    arcanist-manager --help
    return
  fi

  local COMMAND
  COMMAND="${1-}"
  shift

  # initialize local variables
  case $COMMAND in
    'help' | '--help' )
      script_echo "Here's some help"
  ;;
  case $COMMAND in
    'update' | 'upgrade' )
      script_echo "Upgrading ..."
  ;;
  * )
    >&2 nvm --help
      return 127
  ;;
  esac
}
