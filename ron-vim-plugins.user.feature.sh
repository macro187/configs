. $HOTBOX/lib/sh.sh


echo_on
cd $HOME
mkdir -p .vim/pack
cd .vim/pack
rm -rf ron
mkdir -p ron/start
cd ron/start
echo_off

$HOTBOX/lib/git-clone-cached https://github.com/macro187/vim-macrobsidian.git
$HOTBOX/lib/git-clone-cached https://github.com/ryanoasis/vim-devicons.git
$HOTBOX/lib/git-clone-cached https://github.com/gelguy/wilder.nvim.git
$HOTBOX/lib/git-clone-cached https://github.com/preservim/nerdtree.git
$HOTBOX/lib/git-clone-cached https://github.com/prabirshrestha/vim-lsp.git
$HOTBOX/lib/git-clone-cached https://github.com/prabirshrestha/asyncomplete.vim.git
$HOTBOX/lib/git-clone-cached https://github.com/prabirshrestha/asyncomplete-lsp.vim.git
