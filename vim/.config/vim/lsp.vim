let s:lsp_servers = [
\ { 'name': 'intelephense',
\   'cmd': ['intelephense', '--stdio'],
\   'allow': ['php'] },
\ { 'name': 'cssls',
\   'cmd': ['vscode-css-languageserver', '--stdio'],
\   'allow': ['css'] },
\ { 'name': 'html',
\   'cmd': ['vscode-html-languageserver', '--stdio'],
\   'allow': ['html'] },
\ { 'name': 'pyright',
\   'cmd': ['pyright-langserver', '--stdio'],
\   'allow': ['python'] },
\ { 'name': 'bashls',
\   'cmd': ['bash-language-server', 'start'],
\   'allow': ['sh', 'bash'] },
\ { 'name': 'clangd',
\   'cmd': ['clangd'],
\   'allow': ['c', 'cpp'] },
\ { 'name': 'tsserver',
\   'cmd': ['typescript-language-server', '--stdio'],
\   'allow': ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'] },
\ { 'name': 'arduino',
\   'cmd': [
\     'arduino-language-server',
\     '-cli', 'arduino-cli',
\     '-clangd', 'clangd',
\     '-cli-config', expand('~/.arduino15/arduino-cli.yaml')
\   ],
\   'allow': ['arduino', 'ino'] }
\ ]


augroup LspAutoRegister
  autocmd!
  autocmd User lsp_setup call s:register_all()
augroup END

function! s:register_all() abort
  for server in s:lsp_servers
    call lsp#register_server({
    \ 'name': server.name,
    \ 'cmd': server.cmd,
    \ 'allowlist': server.allow,
    \ })
  endfor
endfunction


nnoremap gd :LspDefinition<CR>
