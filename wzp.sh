#!/usr/bin/env bash
# Wezterm Project - Start a new wezterm project

PROJECTS_DIR="$HOME/.config/wezterm/projects"

project=""

if [[ -z "$1" ]]; then
	# List all files in projects directory. Only keep the file name without the extension
	project=$(fd --glob "*.lua" "$PROJECTS_DIR" | fzf --cycle --layout=reverse --delimiter / --with-nth -1 | xargs basename | sed "s/\.lua//")
else
	if [[ ! -e "$PROJECTS_DIR/$1.lua" ]]; then
		echo "The project file '$PROJECTS_DIR/$1.lua' not exists"
		exit 1
	fi
	project="$1"
fi

if [[ -z $project ]]; then
	echo "No project selected"
	exit 1
fi

echo $project

# WZ_PROJECT="$project" wezterm connect --new-tab local
WZ_PROJECT="$project" wezterm start --always-new-process &
