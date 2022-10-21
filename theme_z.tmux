#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get-tmux-option() {
  local option value default
  option="$1"
  default="$2"
  value="$(tmux show-option -gqv "$option")"

  if [ -n "$value" ]; then
    echo "$value"
  else
    echo "$default"
  fi
}

main() {
  local theme
  theme="$(get-tmux-option "@z" "z")"

  # prefix-highlight-mod
  local prefix_highlight="$(tmux show-option -gqv "@z-prefix-highlight-conf")"
  if [[ "${prefix_highlight}" = "on" ]];then
    tmux run-shell "$CURRENT_DIR/scripts/prefix_highlight_mod.tmux"
  fi

  # load theme
  if [ -f "$CURRENT_DIR/${theme}.tmuxtheme" ]; then
    tmux source-file "$CURRENT_DIR/${theme}.tmuxtheme"
  else
    tmux source-file "$CURRENT_DIR/z.tmuxtheme"
  fi

  # split_status_bar
  local split_statusbar="$(tmux show-option -gqv "@z-split-statusbar")"
  if [[ ! "${split_statusbar}" = "off" ]];then
    tmux run-shell "$CURRENT_DIR/scripts/split_status_bar_mod.tmux"
  fi
}

main "$@"
