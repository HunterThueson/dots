#!/usr/bin/env bash

# ~/.bash_profile

[[ -f ~/.config/bash/bashrc ]] && . ~/.config/bash/bashrc

export PATH=$HOME/.cargo/bin:$PATH:$HOME/bin

# Set XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

# Explicitly declare location of config files (even if not strictly necessary)
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship"
