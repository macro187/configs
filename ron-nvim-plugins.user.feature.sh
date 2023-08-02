. $HOTBOX/lib/sh.sh


echo_on
cd $HOME
mkdir -p .local/share/nvim/site/pack
cd .local/share/nvim/site/pack
rm -rf ron
mkdir -p ron/start
cd ron/start
echo_off

$HOTBOX/lib/git-clone-cached https://github.com/macro187/vim-macrobsidian.git
$HOTBOX/lib/git-clone-cached https://github.com/nvim-tree/nvim-web-devicons.git
$HOTBOX/lib/git-clone-cached https://github.com/nvim-tree/nvim-tree.lua.git
$HOTBOX/lib/git-clone-cached https://github.com/hrsh7th/nvim-cmp.git
$HOTBOX/lib/git-clone-cached https://github.com/hrsh7th/cmp-nvim-lsp.git
$HOTBOX/lib/git-clone-cached https://github.com/hrsh7th/cmp-nvim-lua.git
$HOTBOX/lib/git-clone-cached https://github.com/hrsh7th/cmp-cmdline.git
$HOTBOX/lib/git-clone-cached https://github.com/hrsh7th/cmp-path.git
$HOTBOX/lib/git-clone-cached https://github.com/hrsh7th/cmp-buffer.git
$HOTBOX/lib/git-clone-cached https://github.com/hrsh7th/vim-vsnip.git
$HOTBOX/lib/git-clone-cached https://github.com/hrsh7th/cmp-vsnip.git
$HOTBOX/lib/git-clone-cached https://github.com/Issafalcon/lsp-overloads.nvim.git
