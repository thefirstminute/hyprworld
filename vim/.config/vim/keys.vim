" Modified Vimdamentals:
"{{{

"visual block seems more useful for my workflow:
nnoremap <Leader>v v
nnoremap v <C-v>

" can't we just all agree that's what we mean - you can still use ce/de
nnoremap cw ciw
nnoremap dw daw

" Yank Line And Put Below...
nnoremap yp yyp
vnoremap yp yp
" & comment one...I do this too much
nnoremap ycp yypk:TComment<CR>j
vnoremap ycp ypgv:TComment<CR>j

" when jumping to next find, center on screen
nnoremap n nzOzz
nnoremap N NzOzz

" Start an external command with a single bang
nnoremap ! :!

" ctrl+hjkl are arrows in command mode
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>

"}}}

" There Is No Escape:
" {{{
" You Can't Do This - it slows down navigating to next char!!! nnoremap ;i <Esc>
vnoremap <Leader><space> <Esc>:noh<CR>
nnoremap <Leader><space> <Esc>:noh<CR>
inoremap kj <Esc>l
" vnoremap kj <Esc>
cnoremap kj <c-c>
tnoremap kj <c-c>

inoremap KJ <Esc>:call CapsOff()<CR>:<Backspace>
tnoremap KJ <Esc>:call CapsOff()<CR>:<Backspace>
cnoremap KJ <c-c>:call CapsOff()<CR>:<Backspace>

" }}}

" My Capital Ideas:
" {{{
" make Y work like D
nnoremap Y y$

" simpler redo:
nnoremap U <C-r>

" Jump to mark `m
nnoremap M `m

" Big Jumps
"{{{
nnoremap J <c-d>zz
nnoremap K <c-u>zz
vnoremap J <c-d>zz
vnoremap K <c-u>zz

" map J so we can still Join lines (and keep cursor in position):
vnoremap <Leader>j J
nnoremap <Leader>j mzJ`z
" map K so we can still see info
nnoremap <Leader>kk K
vnoremap <Leader>kk K

vnoremap H ^
nnoremap H ^
nnoremap L $
vnoremap L $
xnoremap L $

" mapping so we can still go to top of screen (I use alt l-h for tab navigating)
vnoremap gt H
nnoremap gt H
" mapping so we can still go to bottom of screen (whatever this bookmarks thing does, I don't use)
nnoremap gb L
vnoremap gb L
"}}}

" Quick Macros:
"{{{
nnoremap Q @q
vnoremap Q :norm @q<CR>
"don't lose ex mode:
nnoremap <Leader>xm Q
"}}}

" My Capital Ideas }}}

" YankPut Copy:
"{{{
" nmap <C-v> "+P
nmap vv "+P
set pastetoggle=<F10>
" inoremap <C-v> <F10><C-r>+<F10>
inoremap vv <F10><C-r>+<F10>
inoremap qv <C-r>"
vnoremap <C-c> "*y :let @+=@*<CR>:echo "a vim noob just copied something"<CR>gv
vnoremap gy "*y :let @+=@*<CR>gv
" vnoremap <C-v> "+P
vnoremap vv c<F10><C-r>+<F10><Esc>
" TODO: the temp file copy/paste hack

" yank from 'x' lines up/down and paste line here
nnoremap <expr> <Leader>yk "mm". input("How many lines up? ") ."kyy'mp"
nnoremap <expr> <Leader>yj "mm". input("How many lines down? ") ."jyy'mp"
" move from 'x' lines up/down and put line here
nnoremap <expr> <Leader>pk "mm". input("How many lines up? ") ."kdd'mp"
nnoremap <expr> <Leader>pj "mm". input("How many lines down? ") ."jdd'mp"

" delete from 'x' lines up/down
nnoremap <expr> <Leader>dk "mm". input("How many lines up? ") ."kdd`m"
nnoremap <expr> <Leader>dj "mm". input("How many lines down? ") ."jdd`m"

"}}}

" Shift Or Control Pain:
"{{{
nnoremap <Leader>; :
vnoremap <Leader>; :
nnoremap <Leader>w <c-w>

" use q to exit help buffer
nnoremap <expr> <CR> &buftype ==# 'help' ? ":q<CR>" : 'q'

"}}}

" Searching Moving Around And Leaving Buffers N Tabs:
"{{{
nnoremap <Leader>qq :qa!<CR>
nnoremap <Leader>QQ :qa!<CR>
vnoremap <Leader>qq :qa!<CR>
xnoremap <Leader>qq :qa!<CR>
vnoremap <Leader>QQ :qa!<CR>
nnoremap <Leader>wa :wa<CR>: echo "Saving All"<CR>
nnoremap <Leader>wq :wqa<CR>
nnoremap <Leader>ee :bd!<CR>
nnoremap <Leader>bd :bd!<CR>
nnoremap <Leader>bo :%bd\|e#<CR>
nnoremap <Leader>bb :b#<cr>

" Navigating Files
nnoremap <leader>ls :ls<CR>:b
nnoremap <leader>fj :ls<CR>:b 
vnoremap <leader>fj <Esc>:ls<CR>:b 
nnoremap <leader>fe :Lex 22<CR>

" Tab Movements
nnoremap <Tab>   :tabn<CR>
nnoremap <S-Tab> :tabp<CR>
nnoremap <C-l>   :tabn<CR>
nnoremap <C-h>   :tabp<CR>
vnoremap <Tab>   :tabn<CR>
vnoremap <S-Tab> :tabp<CR>
vnoremap <C-l>   :tabn<CR>
vnoremap <C-h>   :tabp<CR>

" Buffer Movements
nnoremap <C-j>  :bn<CR>
nnoremap <C-k>  :bp<CR>

"}}}

" 'Z' Commands:
"{{{
" fold selection (forces manual so it works always)
vnoremap za <Esc>:set foldmethod=manual<CR>gvzf

" Enter Folds Text, Except in QuickFix!
nnoremap <expr> <CR> &buftype ==# 'quickfix' ? "\<CR>" : 'za'
vnoremap <expr> <CR> &buftype ==# 'quickfix' ? "\<CR>" : 'za'

" accounting for scrolloff - I usually actually want the line AT the top/bottom
nnoremap zt 3jzt
nnoremap zb 3kzb
"}}}

" Search N Replace:
"{{{
" Open a search results window for selected:
nnoremap <silent> <Leader>S msyiw:lcd %:p:h<CR>:execute 'vimgrep <C-r>" **/*'<CR>:copen<CR>
vnoremap <silent> <Leader>S msy:lcd %:p:h<CR>:execute 'vimgrep <C-r>" **/*'<CR>:copen<CR>

" open quick fix
nnoremap <silent> gq :lcd %:p:h<CR>:execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

nnoremap <silent> <Leader>/ msyiw/\V<C-R>"<CR>
vnoremap <silent> <Leader>/ msy/\V<C-R>"<CR>

" change word under cursor...
" in buffer
nnoremap <Leader>cw zzyiw:%s/<C-r>"/
vnoremap <Leader>cw zzy:%s/<C-r>"/
" on line
nnoremap <Leader>cl :s/<C-r><C-w>//g<left><left>
vnoremap <Leader>cl y:s/<C-r>"//g<left><left>
nnoremap cl :s/<C-r><C-w>//g<left><left>
vnoremap cl y:s/<C-r>"//g<left><left>

" Change in line (no confirm)
nnoremap cil yiw:s/<C-r>"//g<left><left>
xnoremap cil y:s/<C-r>"//g<left><left>

" Change in document (with confirm)
nnoremap cid yiw:%s/<C-r>"/gc<left><left><left>
xnoremap cid y:%s/<C-r>"/gc<left><left><left>



"delete word under cursor...
" in buffer
nnoremap <Leader>dw zzyiw:%s/<C-r>"//gc<CR>
vnoremap <Leader>dw zzy:%s/<C-r>"//gc<CR>
" on line
nnoremap <Leader>dl zzyiw:s/<C-r>"//gc<CR>
vnoremap <Leader>dl zzy:s/<C-r>"//gc<CR>

" FZF Needed For These:
nnoremap <leader>rg :Rg<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fo :History<CR>
nnoremap <leader>fj :Buffers<CR>
nnoremap <leader>fq :CList<CR>
nnoremap <leader>fh :Helptags<CR>
nnoremap <leader>fb :Blines<CR>

" find in project:
nnoremap <leader>fp :call fzf#vim#grep(
      \ 'rg --column --line-number --no-heading --color=always --smart-case ""',
      \ 1,
      \ fzf#vim#with_preview('down:66%'),
      \ 0)<CR>


"}}}

" Create Marks Before Searches:
" {{{
vnoremap gg mggg
vnoremap G mgG
nnoremap gg mggg
nnoremap G mgG

nnoremap / ms/
nnoremap ? ms?

nnoremap % ms%

nnoremap # ms#
nnoremap * ms*
" }}}

" Insert Spaces UpDownAround:
"{{{
nnoremap gk m`O<Esc>``
nnoremap gj m`o<Esc>``
nnoremap gS m`O<Esc>``m`o<Esc>``
nnoremap gh i <Esc>l
nnoremap gl a <Esc>h
nnoremap gs i <Esc>la <Esc>h
nnoremap ga m`O<Esc>``m`o<Esc>``
vnoremap ga dO<CR><C-r>"<Esc>'[V']=
"}}}

" Normally Insert:
"{{{
" exit insert mode and start moving up, down...
inoremap ;h <Left>
inoremap ;H <Esc>I
inoremap ;l <Right>
inoremap ;L <Esc>A
inoremap ;j <Esc>o
inoremap ;k <Esc>O
inoremap ;w <Esc>lW
inoremap ;e <Esc>lE
inoremap ;b <Esc>B
inoremap ;. <Esc>f>la
inoremap ;' <Esc>f'a
inoremap ;" <Esc>f"a
inoremap ;o <Esc>o
inoremap ;O <Esc>O

"delete word
inoremap ;dw <Esc>bciw
"delete line
inoremap ;dl <Esc>^C
"delete to end of line
inoremap ;de <Esc>lC
"delete to start of line
inoremap ;ds <Esc>lc^

"next empty tag
inoremap ;ne <Esc>/><<CR>:noh<CR>a
"next tag
inoremap ;nt <Esc>/><CR>n:noh<CR>a
"next empty quotes
inoremap ;n" <Esc>/""<CR>:noh<CR>a
inoremap ;nq <Esc>/""<CR>:noh<CR>a
inoremap ;n' <Esc>/''<CR>:noh<CR>a

"prev empty tag
inoremap ;pe <Esc>?><<CR>:noh<CR>a
"prev tag
inoremap ;pt <Esc>?><CR>n:noh<CR>a
"prev empty quotes
inoremap ;p" <Esc>?""<CR>:noh<CR>a
inoremap ;pq <Esc>?""<CR>:noh<CR>a
inoremap ;p' <Esc>?''<CR>:noh<CR>a


" [Q]uick omnis
inoremap qp <C-p>
inoremap qn <C-n>
inoremap qf <C-x><C-f>
inoremap qo <C-x><C-o>
inoremap ;r <C-r>

"}}}

" Placeholder Jumper:
" {{{
" [ Move to Mark (next)] :
inoremap ;mm <Esc>/<++><Enter>va<"_c
inoremap <F4> <Esc>/<++><Enter>va<"_c
nnoremap <F4> /<++><Enter>va<"_c
nnoremap <Leader>mm /<++><Enter>va<"_c

" [ Mark Previous ] :
inoremap ;mp <Esc>?<++><Enter>va<"_c
nnoremap <Leader>mp ?<++><Enter>va<"_c
inoremap <F2> <Esc>?<++><Enter>va<"_c
nnoremap <F2> ?<++><Enter>va<"_c

" [ Mark Repeat - adds same text as last time ] :
inoremap ;mr <Esc>/<++><Enter>.
nnoremap <Leader>mr /<++><Enter>.
inoremap <F3> <Esc>/<++><Enter>.
nnoremap <F3> /<++><Enter>.

" }}}

" Indenting:
"{{{
nnoremap == m`=ip``
vnoremap = =gv
vnoremap < <gv
vnoremap > >gv
nnoremap > m`>>``ll
nnoremap < m`<<``hh

"indent html head
nnoremap =h /<head><CR>V100<<Esc>jV/<\/head<CR>=
"indent html body
nnoremap =b /<body<CR>V100<<Esc>jV/<\/body<CR>=
" indent inside tag
nnoremap =t vitB$oW0=
" indent paragraph
nnoremap =p =ip

" indent in brackets
nnoremap =[ mm=i{`m=i[`m=i(`m
"}}}

" Stop Interfering With Them Damned Yanks:
"{{{
nnoremap x "_x
vnoremap x "_x
nnoremap C "_C
vnoremap C "_C
nnoremap c "_c
vnoremap c "_c
vnoremap p "_dP
"}}}

" Random Cool Leader Commands:
"{{{
" file save
nnoremap <Leader>fs :w<CR>:echo "File Saved"<CR>

" Set working directory to current file path
nnoremap <leader>wd :lcd %:p:h<CR>

" Toggle Wraping Text
nnoremap <leader>wt :set wrap!<CR>

" window 'focus' makes current pane most of the screen
nnoremap <silent> <Leader>wf <C-w>j:let &winheight = &lines * 7 / 10<CR><C-w>j:let &winwidth = &columns * 7 / 10<CR>

" select inside multi-line tag, but DON'T include the surrounding tag
nnoremap <Leader>vit vitB$oW0

" select previously put text
nnoremap <Leader>gv '[V']

" CHANGE TAG (need to start on first letter of opeining tag)
nnoremap <Leader>ct mA:norm %<CR>ci</CHANGEZTAG<Esc>`AcwCHANGEZTAG<Esc>:%s/CHANGEZTAG//g<left><left>

" Remove spaces at the end of lines
nnoremap <Leader>r<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>:echo "Removed EOL Spaces"<CR>

" remove end of line chars from file
nnoremap <Leader>eol :%s/\r//g<CR>:echo "removed end of line chars"<CR>

" Remove blank lines
nnoremap <Leader>rbl :g/^$/d<CR>:echo "Removed Blank Lines"<CR>

" Delete Tag
nnoremap <Leader>dt 0Wlmd%dd'ddd

" Edit macro 'q'
nnoremap <Leader>q :let @q='q'

" source my vimrc:
nnoremap <Leader>so :w<CR>:so ~/.vimrc<CR>:echo " How Re-Sourceful!"<CR>

" Theme Controls:
nnoremap <leader>C :colorscheme habamax<CR>
nnoremap <leader>TT :hi Normal guibg=NONE ctermbg=NONE<CR>
nnoremap <leader>Th :colorscheme habamax<CR>
nnoremap <leader>Tu :colorscheme unokai<CR>
function! Set_Theme()
  source ~/.cache/wal/vim-colors.vim
  hi Normal guibg=NONE ctermbg=NONE
endfunction
nnoremap <Leader>st :call Set_Theme()<CR>

" Make current file executable
nnoremap <leader>X :!chmod +x %<CR>

" swap camelCase into snake_case
nnoremap <Leader>scc :s/\v([a-z])([A-Z])/\1_\L\2/g<CR>
vnoremap <Leader>scc :s/\%V\v([a-z])([A-Z])/\1_\L\2/g<CR>
" swap snake_case into camelCase
nnoremap <Leader>ssc :s/\v_([a-z])/\u\1/g<CR>
vnoremap <Leader>ssc :s/\%V\v_([a-z])/\u\1/g<CR>


"}}}

" Other Misc Improvements:
"{{{

" repeat last command
nnoremap <c-p> :<c-p>

"}}}
