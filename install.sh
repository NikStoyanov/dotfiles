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

echo "Copying .vimrc"
cp -f .vimrc $HOME/

echo "Vim setup done"
