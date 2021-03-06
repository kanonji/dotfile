if exists('b:did_indent')
  finish
endif

setlocal autoindent
setlocal indentexpr=GetPHPIndent()
setlocal indentkeys=!^F,o,O

setlocal expandtab
setlocal tabstop<
setlocal softtabstop=4
setlocal shiftwidth=4

let b:undo_indent = 'setlocal '.join([
\   'autoindent<',
\   'expandtab<',
\   'indentexpr<',
\   'indentkeys<',
\   'shiftwidth<',
\   'softtabstop<',
\   'tabstop<',
\ ])


function! GetPHPIndent()
  return -1
endfunction


let b:did_indent = 1
