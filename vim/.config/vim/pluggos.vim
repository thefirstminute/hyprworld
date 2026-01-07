let s:p_dir = expand('~/.vim/pluggos')

function! s:pluggo(repo)
  let name = fnamemodify(a:repo, ':t')
  let path = s:p_dir . '/' . name

  if !isdirectory(path)
    if !isdirectory(s:p_dir)
      call mkdir(s:p_dir, 'p')
    endif

    let cmd = ['git', 'clone', '--depth=1',
          \ 'https://github.com/' . a:repo, path]

    if exists('*job_start')
      call job_start(cmd)
    else
      execute '!' . join(cmd, ' ')
    endif
  endif

  execute 'set runtimepath+=' . fnameescape(path)
endfunction

call s:pluggo('junegunn/fzf')
call s:pluggo('junegunn/fzf.vim')

"Lsp Stuff:
call s:pluggo('prabirshrestha/vim-lsp')
call s:pluggo('mattn/vim-lsp-settings')
call s:pluggo('prabirshrestha/async.vim')

