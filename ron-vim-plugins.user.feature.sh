. hotbox-use-shell.sh


echo_on
cd $HOME
mkdir -p .vim/pack
cd .vim/pack
rm -rf ron
mkdir -p ron/start
cd ron/start
echo_off

hotbox-git-clone-cached https://github.com/macro187/vim-macrobsidian.git
hotbox-git-clone-cached https://github.com/ryanoasis/vim-devicons.git
hotbox-git-clone-cached https://github.com/gelguy/wilder.nvim.git
hotbox-git-clone-cached https://github.com/preservim/nerdtree.git
hotbox-git-clone-cached https://github.com/prabirshrestha/vim-lsp.git
hotbox-git-clone-cached https://github.com/prabirshrestha/asyncomplete.vim.git
hotbox-git-clone-cached https://github.com/prabirshrestha/asyncomplete-lsp.vim.git
