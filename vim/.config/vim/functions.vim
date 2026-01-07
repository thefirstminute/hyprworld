function! StripTrailingSpace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction
nnoremap STS :call StripTrailingSpace()<CR>

function! ToggleComment()
    let line = getline('.')
    let indent = matchstr(line, '^\s*')
    let stripped = substitute(line, '^\s*', '', '')
    let ft = &filetype

    if ft == 'html'
        let com_start = '<!--'
        let com_end = '-->'
        if stripped =~ '^' . com_start . '.*' . com_end . '$'
            let stripped = substitute(stripped, '^' . com_start . '\s*', '', '')
            let stripped = substitute(stripped, '\s*' . com_end . '$', '', '')
        else
            let stripped = com_start . ' ' . stripped . ' ' . com_end
        endif
    elseif ft == 'css'
        let com_start = '\/\*'
        let com_end = '\*\/'
        if stripped =~ '^' . com_start . '.*' . com_end . '$'
            let stripped = substitute(stripped, '^' . com_start . '\s*', '', '')
            let stripped = substitute(stripped, '\s*' . com_end . '$', '', '')
        else
            let stripped = com_start . ' ' . stripped . ' ' . com_end
        endif
    elseif ft == 'php'
        let com = '\/\/'
        if stripped =~ '^' . com
            let stripped = substitute(stripped, '^' . com . '\s*', '', '')
        else
            let stripped = com . ' ' . stripped
        endif
    elseif ft == 'vim'
        let com = '"'
        if stripped =~ '^' . com
            let stripped = substitute(stripped, '^' . com . '\s*', '', '')
        else
            let stripped = com . ' ' . stripped
        endif
    else
        let com = '#'
        if stripped =~ '^' . com
            let stripped = substitute(stripped, '^' . com . '\s*', '', '')
        else
            let stripped = com . ' ' . stripped
        endif
    endif

    call setline('.', indent . stripped)
endfunction

nnoremap gc :call ToggleComment()<CR>
vnoremap gc :call ToggleComment()<CR>


function! s:smart_change_in_quotes() abort
  let c = getline('.')[col('.') - 1]

  " If cursor is on a quote, use that quote
  if c =~ '["''`]'
    return 'ci' . c
  endif

  " Otherwise: search backward for nearest quote on this line
  let line = getline('.')
  let pos = col('.')
  let before = line[0 : pos - 2]

  " Find last quote before cursor
  let m = matchstr(before, '["''`]\zs.*$')
  if m !=# ''
    let q = before[match(before, '["''`]')]
    return 'ci' . q
  endif

  " Fallback: default to double quotes
  return 'ci"'
endfunction
nnoremap <expr> ciq <SID>smart_change_in_quotes()

function! s:smart_change_in_brackets() abort
  let c = getline('.')[col('.') - 1]

  " If cursor is on a bracket, use that bracket
  if c =~# '[(){}[\]<>]'
    return 'ci' . c
  endif

  " otherwise search backward on the line for nearest opening bracket
  let line = getline('.')
  let pos = col('.')
  let before = line[0 : pos - 2]

  " Find last opening bracket before cursor
  let idx = match(before, '[([{<]')
  if idx >= 0
    let q = before[idx]
    return 'ci' . q
  endif

  " Fallback
  return 'ci('
endfunction
nnoremap <expr> cib <SID>smart_change_in_brackets()


"https://vim.fandom.com/wiki/Switching_case_of_characters
function! TwiddleCase(str)
	if a:str ==# toupper(a:str)
		let result = tolower(a:str)
	elseif a:str ==# tolower(a:str)
		let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
	else
		let result = toupper(a:str)
	endif
	return result
endfunction
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv
