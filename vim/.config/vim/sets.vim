filetype plugin on

set autoread
set noautochdir
set lazyredraw

set iskeyword+=-         " hyphenated-words-are-one-word
set keymodel=startsel    " Allow select of text in insert mode using shift
set confirm              " confirm before doing 'major' stuff
" set noincsearch          " stop jumping to 'best match so far' as typed
set incsearch            " jumping to 'best match so far' as typed
set ignorecase smartcase " ignore case for search unless search includes caps
set wrapscan             " Searches wrap around the end of the file
set nowrap               " don't wrap my text

set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartindent
set smarttab
set expandtab

""" AutoCompleting:
set omnifunc=syntaxcomplete#Complete

set wildmenu
set formatoptions-=ro
set wildmenu
set wildmode=longest:full,full
set wildignore+=*.o,*.obj,*.pyc,*.class
set wildoptions=pum
set wildignorecase

""" swaps, backups, undos
" Ensure dump directories exist
for d in [
      \ expand('~/.vim/dump/swaps'),
      \ expand('~/.vim/dump/backups'),
      \ expand('~/.vim/dump/undos')
      \ ]
    if !isdirectory(d)
        call mkdir(d, 'p')
    endif
endfor
" Now safely set the paths
set directory=~/.vim/dump/swaps/
set backupdir=~/.vim/dump/backups/
set undodir=~/.vim/dump/undos/
set undofile
set undolevels=1000
set undoreload=1000
set foldmethod=marker
set foldlevel=1
set nofoldenable

""" Looks:
set title

let g:netrw_banner = 0

"See invisible chars:
set list
set listchars=tab:⎸\ ,nbsp:⎕
set listchars+=trail:

set signcolumn=yes
set scrolloff=10
set nocursorcolumn
set termguicolors

" basic statusline
set laststatus=2
set statusline=
set statusline+=%f          " filename (relative path)
set statusline+=%m          " modified flag [+] or [-]
set statusline+=%r          " readonly flag [RO]
set statusline+=%=          " switch to right side
set statusline+=%l/%L       " current line / total lines
set statusline+=\ %c        " column number
set statusline+=\ %P        " percentage through file
set statusline+=\ %y        " file type [vim], [python], etc.
