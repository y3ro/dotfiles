#!/usr/bin/bash

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
cd $SCRIPT_DIR

TMUX_DOTFILE=$HOME/.tmux.conf
NVIM_CONFIG_DIR=$HOME/.config/nvim
NVIM_DOTFILE=$NVIM_CONFIG_DIR/init.lua
VIM_DOTFILE=$HOME/.vimrc

echo "Backup existing dotfiles?"
DO_BACKUP=$(read)
NOW=$(date "+%y%m%d%H%M%S")

case $DO_BACKUP in
	y|Y)
		if [ -f $TMUX_DOTFILE ]; then
			cp $TMUX_DOTFILE $TMUX_DOTFILE.$NOW
		fi

		if [ -f $NVIM_DOTFILE ]; then
			cp $NVIM_DOTFILE $NVIM_DOTFILE.$NOW
		fi

		if [ -f $VIM_DOTFILE ]; then
			cp $VIM_DOTFILE $VIM_DOTFILE.$NOW
		fi
esac

cp tmux.conf $TMUX_DOTFILE

mkdir -p $NVIM_CONFIG_DIR
cp nvim-init.lua $NVIM_DOTFILE

cp vimrc $VIM_DOTFILE
