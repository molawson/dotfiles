# asdf-alias: automatic version aliases for asdf
#
# After `asdf install ruby 3.5.1`, automatically creates symlink aliases
# like `3.5 -> 3.5.1` and `3 -> 3.5.1` so that .ruby-version files
# containing short versions (e.g. "3.5") resolve correctly.
#
# Usage:
#   asdf install ruby 3.5.1      # wrapper auto-runs aliases after install
#   asdf-alias ruby --auto        # manually refresh all aliases for a plugin
#   asdf-alias ruby 3.5 3.5.1    # manually create a single alias

asdf-alias() {
  local plugin="$1"

  if [[ -z "$plugin" ]]; then
    echo "Usage: asdf-alias <plugin> --auto"
    echo "       asdf-alias <plugin> <alias> <version>"
    return 1
  fi

  local install_dir="$HOME/.asdf/installs/$plugin"
  if [[ ! -d "$install_dir" ]]; then
    echo "No installed versions found for $plugin"
    return 1
  fi

  # Manual mode: asdf-alias ruby 3.3 3.3.9
  if [[ "$2" != "--auto" && -n "$2" && -n "$3" ]]; then
    local alias_name="$2"
    local target="$3"

    if [[ ! -d "$install_dir/$target" ]]; then
      echo "Version $target is not installed for $plugin"
      return 1
    fi

    ln -sfn "$target" "$install_dir/$alias_name"
    asdf reshim "$plugin" "$alias_name"
    echo "$plugin $alias_name -> $target"
    return 0
  fi

  if [[ "$2" != "--auto" ]]; then
    echo "Usage: asdf-alias <plugin> --auto"
    echo "       asdf-alias <plugin> <alias> <version>"
    return 1
  fi

  # Auto mode: create aliases for all installed versions
  local versions=()
  for d in "$install_dir"/*/; do
    d="${d%/}"
    d="${d##*/}"
    [[ -L "$install_dir/$d" ]] && continue
    versions+=("$d")
  done

  if [[ ${#versions[@]} -eq 0 ]]; then
    echo "No installed versions found for $plugin"
    return 1
  fi

  local sorted=($(printf '%s\n' "${versions[@]}" | sort -V))

  # For A.B.C, create A.B -> latest A.B.x and A -> latest A.x
  # Ascending sort means later (higher) versions naturally win
  local -A aliases
  for v in "${sorted[@]}"; do
    local major="${v%%.*}"
    local rest="${v#*.}"
    local minor="${rest%%.*}"

    aliases[$major]="$v"
    [[ "$v" == *.*.* ]] && aliases[$major.$minor]="$v"
  done

  for alias_name in "${(@k)aliases}"; do
    local target="${aliases[$alias_name]}"
    [[ "$alias_name" == "$target" ]] && continue

    local current="$(readlink "$install_dir/$alias_name" 2>/dev/null)"
    if [[ "$current" == "$target" ]]; then
      echo "$plugin $alias_name -> $target (unchanged)"
    else
      ln -sfn "$target" "$install_dir/$alias_name"
      asdf reshim "$plugin" "$alias_name"
      echo "$plugin $alias_name -> $target (updated)"
    fi
  done
}

# Wrap asdf so aliases are refreshed automatically after installs
asdf() {
  command asdf "$@"
  local exit_code=$?

  if [[ "$1" == "install" && $exit_code -eq 0 && -n "$2" ]]; then
    asdf-alias "$2" --auto
  fi

  return $exit_code
}
