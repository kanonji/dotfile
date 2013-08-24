if exists('b:did_indent')
  finish
endif


setlocal autoindent
setlocal indentexpr=GetYAMLIndent()
setlocal indentkeys=!^F,o,O

setlocal expandtab
setlocal tabstop<
setlocal softtabstop=2
setlocal shiftwidth=2

let b:undo_indent = 'setlocal '.join([
\   'autoindent<',
\   'expandtab<',
\   'indentexpr<',
\   'indentkeys<',
\   'shiftwidth<',
\   'softtabstop<',
\   'tabstop<',
\ ])


function! GetYAMLIndent()
  return -1
endfunction


let b:did_indent = 1
