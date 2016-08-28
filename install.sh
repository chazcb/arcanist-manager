#!/usr/bin/env bash

{ # this ensures the entire script is downloaded #


package_name() {
  echo "arcanist-manager"
}
package_space() {
  echo "ARCANIST_MANAGER"
}

install_source_uri() {
  echo "https://github.com/chazcb/arcanist-manager.git"
}

command_available() {
  type "$1" > /dev/null 2>&1
}

install_directory() {
  echo "$HOME/.$(package_name)"
}

detect_user_profile() {
  if [ -n "${PROFILE}" ] && [ -f "${PROFILE}" ]; then
    echo "${PROFILE}"
    return
  fi

  local DETECTED_PROFILE
  DETECTED_PROFILE=''
  local SHELLTYPE
  SHELLTYPE="$(basename "/$SHELL")"

  if [ "$SHELLTYPE" = "bash" ]; then
    if [ -f "$HOME/.bashrc" ]; then
      DETECTED_PROFILE="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
      DETECTED_PROFILE="$HOME/.bash_profile"
    fi
  elif [ "$SHELLTYPE" = "zsh" ]; then
    DETECTED_PROFILE="$HOME/.zshrc"
  fi

  if [ -z "$DETECTED_PROFILE" ]; then
    if [ -f "$HOME/.profile" ]; then
      DETECTED_PROFILE="$HOME/.profile"
    elif [ -f "$HOME/.bashrc" ]; then
      DETECTED_PROFILE="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
      DETECTED_PROFILE="$HOME/.bash_profile"
    elif [ -f "$HOME/.zshrc" ]; then
      DETECTED_PROFILE="$HOME/.zshrc"
    fi
  fi

  if [ ! -z "$DETECTED_PROFILE" ]; then
    echo "$DETECTED_PROFILE"
  fi
}

install_with_git() {
  local INSTALL_DIR
  INSTALL_DIR="$(install_directory)"

  if [ -d "$INSTALL_DIR/.git" ]; then
    echo "=> $(package_name) is already installed in $INSTALL_DIR, trying to update using git"
    command printf "\r=> "
    command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" fetch 2> /dev/null || {
      echo >&2 "Failed to update $(package_name), run 'git fetch' in $INSTALL_DIR yourself."
      exit 1
    }
  else
    # Cloning to $INSTALL_DIR
    echo "=> Downloading $(package_name) from git to '$INSTALL_DIR'"
    command printf "\r=> "
    mkdir -p "${INSTALL_DIR}"
    if [ "$(ls -A "${INSTALL_DIR}")" ]; then
      command git init "${INSTALL_DIR}" || {
        echo >&2 "Failed to initialize $(package_name) repo. Please report this!"
        exit 2
      }
      command git --git-dir="${INSTALL_DIR}/.git" remote add origin "$(install_source_uri)" 2> /dev/null \
        || command git --git-dir="${INSTALL_DIR}/.git" remote set-url origin "$(install_source_uri)" || {
        echo >&2 'Failed to add remote "origin" (or set the URL). Please report this!'
        exit 2
      }
      command git --git-dir="${INSTALL_DIR}/.git" fetch origin --tags || {
        echo >&2 'Failed to fetch origin with tags. Please report this!'
        exit 2
      }
    else
      command git clone "$(install_source_uri)" "${INSTALL_DIR}" || {
        echo >&2 'Failed to clone nvm repo. Please report this!'
        exit 2
      }
    fi
  fi
  command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" checkout -f --quiet "master"
  if [ ! -z "$(command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" show-ref refs/heads/master)" ]; then
    if command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" branch --quiet 2>/dev/null; then
      command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" branch --quiet -D master >/dev/null 2>&1
    else
      echo >&2 "Your version of git is out of date. Please update it!"
      command git --git-dir="$INSTALL_DIR"/.git --work-tree="$INSTALL_DIR" branch -D master >/dev/null 2>&1
    fi
  fi
  return
}

do_install() {
  if command_available git; then
    install_with_git
  else
    echo >&2 "You need git to install $(package_name)"
    exit 1
  fi

  echo

  local USER_PROFILE
  USER_PROFILE="$(detect_user_profile)"
  local INSTALL_DIR
  INSTALL_DIR="$(install_directory)"

  SOURCE_STR="\nexport $(package_space)_DIR=\"$INSTALL_DIR\"\n[ -s \"\$$(package_space)_DIR/$(package_name).sh\" ] && . \"\$$(package_space)_DIR/$(package_name).sh\"  # This loads $(package_name)\n"

  if [ -z "${USER_PROFILE-}" ] ; then
    echo "=> Profile not found. Tried ${USER_PROFILE} (as defined in \$PROFILE), ~/.bashrc, ~/.bash_profile, ~/.zshrc, and ~/.profile."
    echo "=> Create one of them and run this script again"
    echo "=> Create it (touch ${USER_PROFILE}) and run this script again"
    echo "   OR"
    echo "=> Append the following lines to the correct file yourself:"
    command printf "${SOURCE_STR}"
  else
    if ! command grep -qc "/$(package_name).sh" "$USER_PROFILE"; then
      echo "=> Appending source string to $USER_PROFILE"
      command printf "$SOURCE_STR" >> "$USER_PROFILE"
    else
      echo "=> Source string already in ${USER_PROFILE}"
    fi
  fi

  # Source package
  # shellcheck source=/dev/null
  . "${INSTALL_DIR}/$(package_name).sh"

  cleanup_install

  echo "=> Close and reopen your terminal to start using $(package_name) or run the following to use it now:"
  command printf "$SOURCE_STR"
}

cleanup_install() {
  unset -f \
    package_name \
    package_space \
    install_source_uri \
    command_available \
    install_directory \
    detect_user_profile \
    install_with_git \
    do_install \
    cleanup_install
}

do_install


} # this ensures the entire script is downloaded #

