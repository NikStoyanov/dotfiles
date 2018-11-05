# Variables
dotfiles = ~/git/dotfiles

# Delete existing dot files and folders
sudo rm -rf ~/.vim > /dev/null 2>&1
sudo rm -rf ~/.vimrc > /dev/null 2>&1
sudo rm -rf ~/.emacs.d > /dev/null 2>&1

# symlink
ln -sf $dotfiles/vimrc ~/.vimrc
ln -sf $dotfiles/emacs ~/.emacs.d/config.el

# setup vim
echo "Setting up vim"

if [ ! -d "$HOME/.vim" ]; then
        mkdir $HOME/.vim
        mkdir $HOME/.vim/autoload
fi

if [ ! -d "$HOME/.vim/autoload/" ]; then
        mkdir $HOME/.vim/autoload
fi

echo "Clone Vim-Plug Plugin"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Vim setup done"

# setup emacs
echo "Setting up emacs"

if [ ! d "$HOME/.emacs.d/emacs_backup/" ]; then
        mkdir $HOME/.emacs.d/emacs_backup
fi

if [ ! d "$HOME/.emacs.d/autosave/"]; then
        mkdir $HOME/.emacs.d/autosave/
fi

if [ ! d "$HOME/.emacs.d/lisp/"]; then
        mkdir $HOME/.emacs.d/lisp/
fi

cp $dotfiles/lisp/ox-rss.el $HOME/.emacs.d/lisp/ox-rss.el
cp $dotfiles/lisp/ox-word.el $HOME/.emacs.d/lisp/ox-word.el

echo "Emacs setup done"

# sync scripts
cp $dotfiles/sync/gsync.sh $HOME/gsync.sh
cp $dotfiles/sync/sync.sh $HOME/sync.sh
