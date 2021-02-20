#!/bin/bash
set -u

# Needs a valid token
# /bin/bash -c "$(curl -fsSL -H "Authorization: token $TOKEN" -H 'Accept: application/vnd.github.v3.raw' https://raw.github.pie.apple.com/Fargo-Tools/documentation-core/task/Transition_demo/bin/install.sh)"

# OR
#
# Use the URL that can be copy pasted from safari :) but with the accept header
# /bin/bash -c "$(curl -fsSL -H 'Accept: application/vnd.github.v3.raw' https://raw.github.pie.apple.com/Fargo-Tools/documentation-core/task/Transition_demo/bin/install.sh\?token\=AAALRJE2K6KZTEZQY4PJICC7W7DCQ)"


# On macOS, this script installs to /usr/local only.
INSTALL_PREFIX="/usr/local"
JAZZY_REPOSITORY="/usr/local/fargo-tools-jazzy-fork"

STAT="stat -f"
CHOWN="/usr/sbin/chown"
CHGRP="/usr/bin/chgrp"
GROUP="admin"
TOUCH="/usr/bin/touch"

BREW_REPO="git@github.pie.apple.com:Fargo-Tools/jazzy.git"

# For Homebrew on Linux
REQUIRED_RUBY_VERSION=2.6  # https://github.com/Homebrew/brew/pull/6556
REQUIRED_GLIBC_VERSION=2.13  # https://docs.brew.sh/Homebrew-on-Linux#requirements

# string formatters
if [[ -t 1 ]]; then
  tty_escape() { printf "\033[%sm" "$1"; }
else
  tty_escape() { :; }
fi
tty_mkbold() { tty_escape "1;$1"; }
tty_underline="$(tty_escape "4;39")"
tty_blue="$(tty_mkbold 34)"
tty_red="$(tty_mkbold 31)"
tty_bold="$(tty_mkbold 39)"
tty_reset="$(tty_escape 0)"

have_sudo_access() {
  local -a args
  if [[ -n "${SUDO_ASKPASS-}" ]]; then
    args=("-A")
  fi

  if [[ -z "${HAVE_SUDO_ACCESS-}" ]]; then
    if [[ -n "${args[*]-}" ]]; then
      /usr/bin/sudo "${args[@]}" -l mkdir &>/dev/null
    else
      /usr/bin/sudo -l mkdir &>/dev/null
    fi
    HAVE_SUDO_ACCESS="$?"
  fi

  if [[ -z "${HOMEBREW_ON_LINUX-}" ]] && [[ "$HAVE_SUDO_ACCESS" -ne 0 ]]; then
    abort "Need sudo access on macOS (e.g. the user $USER to be an Administrator)!"
  fi

  return "$HAVE_SUDO_ACCESS"
}

shell_join() {
  local arg
  printf "%s" "$1"
  shift
  for arg in "$@"; do
    printf " "
    printf "%s" "${arg// /\ }"
  done
}

chomp() {
  printf "%s" "${1/"$'\n'"/}"
}

ohai() {
  printf "${tty_blue}==>${tty_bold} %s${tty_reset}\n" "$(shell_join "$@")"
}

warn() {
  printf "${tty_red}Warning${tty_reset}: %s\n" "$(chomp "$1")"
}

abort() {
  printf "%s\n" "$1"
  exit 1
}

execute() {
  if ! "$@"; then
    abort "$(printf "Failed during: %s" "$(shell_join "$@")")"
  fi
}

execute_sudo() {
  local -a args=("$@")
  if [[ -n "${SUDO_ASKPASS-}" ]]; then
    args=("-A" "${args[@]}")
  fi
  if have_sudo_access; then
    ohai "/usr/bin/sudo" "${args[@]}"
    execute "/usr/bin/sudo" "${args[@]}"
  else
    ohai "${args[@]}"
    execute "${args[@]}"
  fi
}

getc() {
  local save_state
  save_state=$(/bin/stty -g)
  /bin/stty raw -echo
  IFS= read -r -n 1 -d '' "$@"
  /bin/stty "$save_state"
}

wait_for_user() {
  local c
  echo
  echo "Press RETURN to continue or any other key to abort"
  getc c
  # we test for \r and \n because some stuff does \r instead
  if ! [[ "$c" == $'\r' || "$c" == $'\n' ]]; then
    exit 1
  fi
}

major_minor() {
  echo "${1%%.*}.$(x="${1#*.}"; echo "${x%%.*}")"
}

if [[ -z "${HOMEBREW_ON_LINUX-}" ]]; then
  macos_version="$(major_minor "$(/usr/bin/sw_vers -productVersion)")"
fi

version_gt() {
  [[ "${1%.*}" -gt "${2%.*}" ]] || [[ "${1%.*}" -eq "${2%.*}" && "${1#*.}" -gt "${2#*.}" ]]
}
version_ge() {
  [[ "${1%.*}" -gt "${2%.*}" ]] || [[ "${1%.*}" -eq "${2%.*}" && "${1#*.}" -ge "${2#*.}" ]]
}
version_lt() {
  [[ "${1%.*}" -lt "${2%.*}" ]] || [[ "${1%.*}" -eq "${2%.*}" && "${1#*.}" -lt "${2#*.}" ]]
}

get_permission() {
  $STAT "%A" "$1"
}

user_only_chmod() {
  [[ -d "$1" ]] && [[ "$(get_permission "$1")" != "755" ]]
}

exists_but_not_writable() {
  [[ -e "$1" ]] && ! [[ -r "$1" && -w "$1" && -x "$1" ]]
}

get_owner() {
  $STAT "%u" "$1"
}

file_not_owned() {
  [[ "$(get_owner "$1")" != "$(id -u)" ]]
}

get_group() {
  $STAT "%g" "$1"
}

file_not_grpowned() {
  [[ " $(id -G "$USER") " != *" $(get_group "$1") "*  ]]
}

# Please sync with 'test_ruby()' in 'Library/Homebrew/utils/ruby.sh' from Homebrew/brew repository.
test_ruby () {
  if [[ ! -x $1 ]]
  then
    return 1
  fi

  "$1" --enable-frozen-string-literal --disable=gems,did_you_mean,rubyopt -rrubygems -e \
    "abort if Gem::Version.new(RUBY_VERSION.to_s.dup).to_s.split('.').first(2) != \
              Gem::Version.new('$REQUIRED_RUBY_VERSION').to_s.split('.').first(2)" 2>/dev/null
}

no_usable_ruby() {
  local ruby_exec
  IFS=$'\n' # Do word splitting on new lines only
  for ruby_exec in $(which -a ruby); do
    if test_ruby "$ruby_exec"; then
      IFS=$' \t\n' # Restore IFS to its default value
      return 1
    fi
  done
  IFS=$' \t\n' # Restore IFS to its default value
  return 0
}

outdated_glibc() {
  local glibc_version
  glibc_version=$(ldd --version | head -n1 | grep -o '[0-9.]*$' | grep -o '^[0-9]\+\.[0-9]\+')
  version_lt "$glibc_version" "$REQUIRED_GLIBC_VERSION"
}

if [[ -n "${HOMEBREW_ON_LINUX-}" ]] && no_usable_ruby && outdated_glibc
then
    abort "$(cat <<-EOFABORT
	Fargo-Tools Jazzy fork requires Ruby $REQUIRED_RUBY_VERSION which was not found on your system.
	Fargo-Tools Jazzy fork portable Ruby requires Glibc version $REQUIRED_GLIBC_VERSION or newer,
	and your Glibc version is too old.
	See ${tty_underline}https://docs.brew.sh/Homebrew-on-Linux#requirements${tty_reset}
	Install Ruby $REQUIRED_RUBY_VERSION and add its location to your PATH.
	EOFABORT
    )"
fi

# USER isn't always set so provide a fall back for the installer and subprocesses.
if [[ -z "${USER-}" ]]; then
  USER="$(chomp "$(id -un)")"
  export USER
fi

# Invalidate sudo timestamp before exiting (if it wasn't active before).
if ! /usr/bin/sudo -n -v 2>/dev/null; then
  trap '/usr/bin/sudo -k' EXIT
fi

# Things can fail later if `pwd` doesn't exist.
# Also sudo prints a warning message for no good reason
cd "/usr" || exit 1

####################################################################### script
if ! command -v git >/dev/null; then
    abort "$(cat <<EOABORT
You must install Git before installing Fargo-Tools Jazzy fork.
EOABORT
)"
fi

if ! command -v curl >/dev/null; then
    abort "$(cat <<EOABORT
You must install cURL before installing Fargo-Tools Jazzy fork.
EOABORT
)"
fi

if [[ "$UID" == "0" ]]; then
  abort "Don't run this as root!"
elif [[ -d "$INSTALL_PREFIX" && ! -x "$INSTALL_PREFIX" ]]; then
  abort "$(cat <<EOABORT
The Fargo-Tools jazzy fork installation directory, ${INSTALL_PREFIX}, exists but is not searchable. If this is
not intentional, please restore the default permissions and try running the
installer again:
    sudo chmod 775 ${INSTALL_PREFIX}
EOABORT
)"
fi

UNAME_MACHINE="$(uname -m)"

if [[ -n "${HOMEBREW_ON_LINUX-}" ]] && [[ "$UNAME_MACHINE" == "arm64" ]]; then
  abort "$(cat <<EOABORT
Fargo-Tools jazzy fork is not (yet) supported on ARM processors!
Rerun the Fargo-Tools jazzy fork installer under Rosetta 2.
EOABORT
)"
fi

ohai "This script will install:"
echo "${INSTALL_PREFIX}/bin/jazzy"
echo "${INSTALL_PREFIX}/bin/sourcekitten"
echo "${JAZZY_REPOSITORY}"

# Keep relatively in sync with
# https://github.com/Homebrew/brew/blob/master/Library/Homebrew/keg.rb
directories=(bin fargo-tools-jazzy-fork)
group_chmods=()
for dir in "${directories[@]}"; do
  if exists_but_not_writable "${INSTALL_PREFIX}/${dir}"; then
    group_chmods+=("${INSTALL_PREFIX}/${dir}")
  fi
done

# zsh refuses to read from these directories if group writable
directories=(share/zsh share/zsh/site-functions)
zsh_dirs=()
for dir in "${directories[@]}"; do
  zsh_dirs+=("${INSTALL_PREFIX}/${dir}")
done

directories=(bin fargo-tools-jazzy-fork)
mkdirs=()
for dir in "${directories[@]}"; do
  if ! [[ -d "${INSTALL_PREFIX}/${dir}" ]]; then
    mkdirs+=("${INSTALL_PREFIX}/${dir}")
  fi
done

user_chmods=()
if [[ "${#zsh_dirs[@]}" -gt 0 ]]; then
  for dir in "${zsh_dirs[@]}"; do
    if user_only_chmod "${dir}"; then
      user_chmods+=("${dir}")
    fi
  done
fi

chmods=()
if [[ "${#group_chmods[@]}" -gt 0 ]]; then
  chmods+=("${group_chmods[@]}")
fi
if [[ "${#user_chmods[@]}" -gt 0 ]]; then
  chmods+=("${user_chmods[@]}")
fi

chowns=()
chgrps=()
if [[ "${#chmods[@]}" -gt 0 ]]; then
  for dir in "${chmods[@]}"; do
    if file_not_owned "${dir}"; then
      chowns+=("${dir}")
    fi
    if file_not_grpowned "${dir}"; then
      chgrps+=("${dir}")
    fi
  done
fi

if [[ "${#group_chmods[@]}" -gt 0 ]]; then
  ohai "The following existing directories will be made group writable:"
  printf "%s\n" "${group_chmods[@]}"
fi
if [[ "${#user_chmods[@]}" -gt 0 ]]; then
  ohai "The following existing directories will be made writable by user only:"
  printf "%s\n" "${user_chmods[@]}"
fi
if [[ "${#chowns[@]}" -gt 0 ]]; then
  ohai "The following existing directories will have their owner set to ${tty_underline}${USER}${tty_reset}:"
  printf "%s\n" "${chowns[@]}"
fi
if [[ "${#chgrps[@]}" -gt 0 ]]; then
  ohai "The following existing directories will have their group set to ${tty_underline}${GROUP}${tty_reset}:"
  printf "%s\n" "${chgrps[@]}"
fi
if [[ "${#mkdirs[@]}" -gt 0 ]]; then
  ohai "The following new directories will be created:"
  printf "%s\n" "${mkdirs[@]}"
fi

if [[ -t 0 && -z "${CI-}" ]]; then
  wait_for_user
fi

if [[ -d "${INSTALL_PREFIX}" ]]; then
  if [[ "${#chmods[@]}" -gt 0 ]]; then
    execute_sudo "/bin/chmod" "u+rwx" "${chmods[@]}"
  fi
  if [[ "${#group_chmods[@]}" -gt 0 ]]; then
    execute_sudo "/bin/chmod" "g+rwx" "${group_chmods[@]}"
  fi
  if [[ "${#user_chmods[@]}" -gt 0 ]]; then
    execute_sudo "/bin/chmod" "755" "${user_chmods[@]}"
  fi
  if [[ "${#chowns[@]}" -gt 0 ]]; then
    execute_sudo "$CHOWN" "$USER" "${chowns[@]}"
  fi
  if [[ "${#chgrps[@]}" -gt 0 ]]; then
    execute_sudo "$CHGRP" "$GROUP" "${chgrps[@]}"
  fi
else
  execute_sudo "/bin/mkdir" "-p" "${INSTALL_PREFIX}"
  if [[ -z "${HOMEBREW_ON_LINUX-}" ]]; then
    execute_sudo "$CHOWN" "root:wheel" "${INSTALL_PREFIX}"
  else
    execute_sudo "$CHOWN" "$USER:$GROUP" "${INSTALL_PREFIX}"
  fi
fi

if [[ "${#mkdirs[@]}" -gt 0 ]]; then
  execute_sudo "/bin/mkdir" "-p" "${mkdirs[@]}"
  execute_sudo "/bin/chmod" "g+rwx" "${mkdirs[@]}"
  execute_sudo "$CHOWN" "$USER" "${mkdirs[@]}"
  execute_sudo "$CHGRP" "$GROUP" "${mkdirs[@]}"
fi

ohai "Downloading and installing Fargo-Tools jazzy fork..."
(
  cd "${JAZZY_REPOSITORY}" >/dev/null || return

  # we do it in four steps to avoid merge errors when reinstalling
  execute "git" "init" "-q"

  # "git remote add" will fail if the remote is defined in the global config
  execute "git" "config" "remote.origin.url" "${BREW_REPO}"
  execute "git" "config" "remote.origin.fetch" "+refs/heads/*:refs/remotes/origin/*"

  # ensure we don't munge line endings on checkout
  execute "git" "config" "core.autocrlf" "false"

  execute "git" "fetch" "origin" "--force"
  execute "git" "fetch" "origin" "--tags" "--force"

  execute "git" "reset" "--hard" "origin/master"

  execute "sudo" "gem" "uninstall" "jazzy"
  execute "sudo" "gem" "install" "jazzy-0.13.6.1.gem"

  #execute "${INSTALL_PREFIX}/bin/brew" "update" "--force"
) || exit 1

if [[ ":${PATH}:" != *":${INSTALL_PREFIX}/bin:"* ]]; then
  warn "${INSTALL_PREFIX}/bin is not in your PATH."
fi

ohai "Installation successful!"
echo

# Use the shell's audible bell.
if [[ -t 1 ]]; then
  printf "\a"
fi

#ohai "Next steps:"
#echo "- Run \`brew help\` to get started"
#echo "- Further documentation: "
#echo "    ${tty_underline}https://docs.brew.sh${tty_reset}"

#if [[ -n "${HOMEBREW_ON_LINUX-}" ]]; then
  #case "$SHELL" in
    #*/bash*)
      #if [[ -r "$HOME/.bash_profile" ]]; then
        #shell_profile="$HOME/.bash_profile"
      #else
        #shell_profile="$HOME/.profile"
      #fi
      #;;
    #*/zsh*)
      #shell_profile="$HOME/.zprofile"
      #;;
    #*)
      #shell_profile="$HOME/.profile"
      #;;
  #esac
#EOS
#fi
