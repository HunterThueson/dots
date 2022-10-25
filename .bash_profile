#!/usr/bin/env bash

# ~/.bash_profile

[[ -f ~/.config/bash/bashrc ]] && . ~/.config/bash/bashrc

export PATH=$HOME/.cargo/bin:$PATH:$HOME/bin

# Set XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
