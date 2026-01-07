" LEADER: make space the leader, make it stop moving us & give us a bit more time
nnoremap <Space> <Nop>
vnoremap <Space> <Nop>
let g:mapleader="\<Space>"

""" Sets:   ₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪
"{{{
set timeoutlen=1200 " modify leader time
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab " make tabs 2 spaces
set hidden "let me move around without saving EVERY DAMNED TIME
set nu rnu "relative numbers and current line number in gutter
set mouse=na "I know...but come on.
"}}}


""" Moving Around Tabs Buffers Panes And Text:   ₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪
"{{{
" quick tab
nnoremap <Leader>t  :tab
" quick tab next
nnoremap <Leader>tl  :tabn<CR>
" quick tab prev
nnoremap <Leader>th  :tabp<CR>
" quick buffer
nnoremap <Leader>b  :b
" quick buffer next
nnoremap <Leader>bl  :bn<CR>
" quick buffer prev
nnoremap <Leader>bh  :bp<CR>
" List Buffers, then start next buffer command
nnoremap <leader>ls :ls<CR>:b
" quick pane moves
nnoremap <Leader>w <c-w>

" when jumping to next find, center on screen
nnoremap n nzz
nnoremap N Nzz
"}}}

""" Escaping Insert Mode::   ₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪
"{{{
imap <silent> <Esc> <Esc>`^
inoremap ;i <Esc>`^
inoremap ;I <Esc>`^
vnoremap ;i <Esc>`^
vnoremap <Leader>i <Esc>
nnoremap <Leader>i <Esc>
vnoremap <Leader>I <Esc>:call CapsOff()<CR>:<Backspace>
nnoremap <Leader>I <Esc>:call CapsOff()<CR>:<Backspace>
"}}}

" Placeholder Jumper:   ₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪
" {{{
" [ Move to Mark ] :
inoremap ;mm <Esc>/<++><Enter>va<"_c
" [ Mark Repeat ] :
inoremap ;mr <Esc>/<++><Enter>.
nnoremap <Leader>mm /<++><Enter>va<"_c
nnoremap <Leader>mn ?<++><Enter>va<"_c
nnoremap <Leader>mr /<++><Enter>.
" }}}

""" Slick Quick Commands:    ₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪
"{{{

" file save
nnoremap <Leader>fs :w<CR>:echo "File Saved"<CR>

" source vimrc
nnoremap <Leader>so :so $MYVIMRC<CR>:echo "Sourced VimRC"<CR>

" Indenting
"{{{
vnoremap = =gv
vnoremap < <gv
vnoremap > >gv
nnoremap > m`>>``ll
nnoremap < m`<<``hh
"}}}

" Set working directory to current file path
nnoremap <leader>wd :lcd %:p:h<CR>

" Insert space(s) up/down/surround
"{{{
nnoremap gk m`O<Esc>``
nnoremap gj m`o<Esc>``
nnoremap gs m`O<Esc>``m`o<Esc>``
nnoremap gh i <Esc>l
nnoremap gl a <Esc>h
"}}}

" END Slick Quick Commands }}}


""" My "Simpler" Remaps:   ₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪₪
"{{{
"visual block seems more useful for my workflow:
" (still saving 'regular' v with leader)
nnoremap <Leader>v v
nnoremap v <C-v>

" Command Start
nnoremap <Leader>; :

" make Y work like D
nnoremap Y y$

" simpler redo:
nnoremap U <C-r>

" Quick Macros:
"{{{
nnoremap Q @q
vnoremap Q :norm @q<CR>
"don't lose ex mode:
nnoremap <Leader>xm Q
"}}}

" JustKiddings: (J&K)
"{{{
" allow navigating wrapped lines (plus I stole gj gk for adding lines)
nnoremap j gj
nnoremap k gk
" map J so we can still Join lines (and keep cursor in position):
vnoremap <Leader>jl J
nnoremap <Leader>jl mzJ`z
" map K so we can still see info
nnoremap <Leader>kk K
vnoremap <Leader>kk K
" Shift Jumps
nmap J <PageDown>4kzz
nmap K <PageUp>4jzz
vmap J <PageDown>4kzz
vmap K <PageUp>4jzz
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $
"}}}

" mapping so we can still go to top of screen (I use alt l-h for tab navigating)
vnoremap gt H
nnoremap gt H
" mapping so we can still go to bottom of screen (whatever this bookmarks thing does, I don't use)
nnoremap gb L
vnoremap gb L

" END My "Simpler" Remaps }}}
