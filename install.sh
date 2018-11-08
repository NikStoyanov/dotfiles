# Variables
dotfiles="$HOME/git/dotfiles"

# Delete existing dot files and folders
rm -rf "$HOME/.vim"
rm -rf "$HOME/.vimrc"
rm -rf "$HOME/.emacs.d"
rm "$HOME/.emacs"

# setup vim
echo "Setting up vim"

if [ ! -d "$HOME/.vim" ]; then
        mkdir "$HOME/.vim"
        mkdir "$HOME/.vim/autoload"
fi

if [ ! -d "$HOME/.vim/autoload/" ]; then
        mkdir "$HOME/.vim/autoload"
fi

echo "Clone Vim-Plug Plugin"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Vim setup done"

# setup emacs
echo "Setting up emacs"

if [ ! -d "$HOME/.emacs.d/" ]; then
	mkdir "$HOME/.emacs.d/"
fi

if [ ! -d "$HOME/.emacs.d/emacs_backup/" ]; then
        mkdir "$HOME/.emacs.d/emacs_backup"
fi

if [ ! -d "$HOME/.emacs.d/autosave/" ]; then
        mkdir "$HOME/.emacs.d/autosave/"
fi

if [ ! -d "$HOME/.emacs.d/lisp/" ]; then
        mkdir "$HOME/.emacs.d/lisp/"
fi

cp "$dotfiles/init.el" "$HOME/.emacs.d/init.el"
cp "$dotfiles/emacs.el" "$HOME/.emacs.d/config.el"
cp "$dotfiles/lisp/ox-rss.el" "$HOME/.emacs.d/lisp/ox-rss.el"
cp "$dotfiles/lisp/ox-word.el" "$HOME/.emacs.d/lisp/ox-word.el"

echo "Emacs setup done"

# symlink
ln -sf "$dotfiles/vimrc" "$HOME/.vimrc"
ln -sf "$dotfiles/emacs.el" "$HOME/.emacs.d/config.el"

# sync scripts
cp "$dotfiles/sync/gsync.sh" "$HOME/gsync.sh"
cp "$dotfiles/sync/sync.sh" "$HOME/sync.sh"
