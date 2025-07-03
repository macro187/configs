. $HOTBOX/lib/sh.sh


echo_on
cd $HOME
mkdir -p .local/share/nvim/site/pack
cd .local/share/nvim/site/pack
rm -rf ron
mkdir -p ron/start
cd ron/start
echo_off

hotbox-git-clone-cached https://github.com/macro187/vim-macrobsidian.git
hotbox-git-clone-cached https://github.com/nvim-tree/nvim-web-devicons.git
hotbox-git-clone-cached https://github.com/nvim-tree/nvim-tree.lua.git
hotbox-git-clone-cached https://github.com/hrsh7th/nvim-cmp.git
hotbox-git-clone-cached https://github.com/hrsh7th/cmp-nvim-lsp.git
hotbox-git-clone-cached https://github.com/hrsh7th/cmp-nvim-lua.git
hotbox-git-clone-cached https://github.com/hrsh7th/cmp-cmdline.git
hotbox-git-clone-cached https://github.com/hrsh7th/cmp-path.git
hotbox-git-clone-cached https://github.com/hrsh7th/cmp-buffer.git
hotbox-git-clone-cached https://github.com/hrsh7th/vim-vsnip.git
hotbox-git-clone-cached https://github.com/hrsh7th/cmp-vsnip.git
hotbox-git-clone-cached https://github.com/Issafalcon/lsp-overloads.nvim.git
hotbox-git-clone-cached https://github.com/romgrk/barbar.nvim.git
