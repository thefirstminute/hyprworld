#!/bin/bash
PACKAGES="
git
gvim
ripgrep
fd
fzf
rust-analyzer
typescript-language-server
typescript
vscode-css-languageserver
vscode-html-languageserver
vscode-json-languageserver
python-lsp-server
bash-language-server
arduino-language-server
"

sudo pacman -S --needed --noconfirm $PACKAGES

PACKAGES="
nodejs-intelephense
vim-lsp-git
"

yay -S --noconfirm --needed $PACKAGES
