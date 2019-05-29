call plug#begin('~/.vim/plugged')

" airline
Plug 'vim-airline/vim-airline'

" airline themes
Plug 'vim-airline/vim-airline-themes'

" git support
Plug 'tpope/vim-fugitive'

" Julia support
Plug 'JuliaEditorSupport/julia-vim'

" TOML support
Plug 'cespare/vim-toml'

" Git gutter
Plug 'airblade/vim-gitgutter'

" Julia support
Plug 'JuliaEditorSupport/julia-vim'

" Go support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

" Set color scheme
" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

try
    colorscheme desert
catch
endtry
set background=dark

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" wrap lines
set textwidth=80

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" show line numbers
set number

" alter line number color
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" highlight currect line
set cursorline

" set search
set incsearch " search as entering characters
set hlsearch " highligh matches
nnoremap <leader><space> :nohlsearch<CR> " turn off keeping highlight
" Ignore case when searching
set ignorecase
" When searching try to be smart about cases
set smartcase
" Highlight search results
set hlsearch
" Makes search act like search in modern browsers
set incsearch 

" set airline theme
let g:airline_theme='deus'

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Manage tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 

" Opens a new tab with the current buffer's path
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
