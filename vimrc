call plug#begin('~/.vim/plugged')
" theme
Plug 'drewtempelmeyer/palenight.vim'

" airline
Plug 'vim-airline/vim-airline'

" airline themes
Plug 'vim-airline/vim-airline-themes'

" git support
Plug 'tpope/vim-fugitive'

" Julia support
Plug 'JuliaEditorSupport/julia-vim'

call plug#end()

" set color scheme
set background=dark
colorscheme palenight

" set tab space
set tabstop=4 " read
set softtabstop=4 " write
set expandtab " sane tabulation (tab=space)

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

" set airline theme
let g:airline_theme='deus'

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
