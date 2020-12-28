# Variables
dotfiles="$HOME/git/dotfiles"

# Delete existing dot files and folders
rm -rf "$HOME/.vim"
rm -rf "$HOME/.vimrc"
rm -rf "$HOME/.emacs.d"
rm "$HOME/.emacs"
rm -rf "$HOME/.gitconfig"
rm -rf "$HOME/.gitignore_global"
rm -rf "$HOME/.bashrc"
rm -rf "$HOME/.tmux.conf"
rm -rf "$HOME/.julia/config/startup.jl"
rm -rf "$HOME/.Xmodmap"
rm "$HOME/.config/fish/config.fish"
rm -rf "$HOME/.config/i3/config"
rm -rf "$HOME/.config/polybar"

# Setup vim
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

# Setup nvim
echo "Setting up neovim"
if [ ! -d "$HOME/.config/nvim/init.vim" ]; then
	mkdir "$HOME/.config/nvim"
	mkdir "$HOME/.config/nvim/scripts"
fi
ln -sf "$dotfiles/vimrc" "$HOME/.vimrc"
ln -sf "$dotfiles/init.vim" "$HOME/.config/nvim/init.vim"
ln -sf "$dotfiles/nvim/scripts/spacetab.vim" "$HOME/.config/nvim/scripts/spacetab.vim"
echo "Neovim setup done"

# Setup alacritty
echo "Setting up alacritty"
if [ ! -d "$HOME/.config/alacritty/alacritty.yml"]; then
	mkdir "$HOME/.config/alacritty"
fi
ln -sf "$dotfiles/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
echo "Alacritty setup done"

# Setup i3
echo "Setting up i3"
if [ ! -d "$HOME/.config/i3/"]; then
	mkdir "$HOME/.config/i3"
fi
ln -sf "$dotfiles/i3/config" "$HOME/.config/i3/config"
echo "i3 setup done"

# Setup Polybar
echo "Setting up Polybar"
if [! -d "$HOME/.config/polybar/"]; then
	mkdir "$HOME/.config/polybar"
fi
ln -sf "$dotfiles/polybar/config" "$HOME/.config/polybar/config"
ln -sf "$dotfiles/polybar/launch.sh" "$HOME/.config/polybar/launch.sh"
echo "Polybar setup done"

# Setup custom bins
echo "Setting up custom bins"
if [! -d "$HOME/bin/"]; then
	mkdir "$HOME/bin/"
fi
ln -sf "$dotfiles/bin/monitor-plug.sh" "$HOME/bin/monitor-plug.sh"
ln -sf "$dotfiles/bin/brightness.sh" "$HOME/bin/brightness.sh"
ln -sf "$dotfiles/bin/shutdown.sh" "$HOME/bin/shutdown.sh"
ln -sf "$dotfiles/bin/suspend.sh" "$HOME/bin/suspend.sh"
echo "Custom bins setup done"

# Setup julia
echo "Setting up julia"
if [! -d "$HOME/.julia/config/"]; then
	mkdir "$HOME/.julia/config"
fi
ln -sf "$dotfiles/startup.jl" "$HOME/.julia/config/startup.jl"
echo "Julia setup done"

# Setup emacs
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
ln -sf "$dotfiles/emacs.el" "$HOME/.emacs.d/config.el"
cp "$dotfiles/init.el" "$HOME/.emacs.d/init.el"
cp "$dotfiles/emacs.el" "$HOME/.emacs.d/config.el"
cp "$dotfiles/lisp/ox-rss.el" "$HOME/.emacs.d/lisp/ox-rss.el"
cp "$dotfiles/lisp/ox-word.el" "$HOME/.emacs.d/lisp/ox-word.el"
echo "Emacs setup done"

# General symlinks
ln -sf "$dotfiles/gitconfig" "$HOME/.gitconfig"
ln -sf "$dotfiles/gitignore_global" "$HOME/.gitignore_global"
ln -sf "$dotfiles/bashrc" "$HOME/.bashrc"
ln -sf "$dotfiles/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$dotfiles/.Xmodmap" "$HOME/.Xmodmap"
ln -sf "$dotfiles/config.fish" "$HOME/.config/fish/config.fish"

# Sync scripts
cp "$dotfiles/sync/gsync.sh" "$HOME/gsync.sh"
cp "$dotfiles/sync/sync.sh" "$HOME/sync.sh"
