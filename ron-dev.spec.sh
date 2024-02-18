. $HOTBOX/lib/spec.sh


include dev

include _vim

feature ron-vim-plugins
feature ron-nvim-plugins

if [ "$HOTBOX_TARGET" = "container" ] ; then
    feature container-cook
    feature container-hotbox
else
    feature cook
    feature hotbox
fi
