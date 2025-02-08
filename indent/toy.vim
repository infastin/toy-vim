" Vim indent file
" Language: Toy
" Maintainer: infastin <infastin@yandex.com>
" URL: https://github.com/infastin/vim-toy

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

" C indentation is too far off useful, mainly due to Go's := operator.
" Let's just define our own.
setlocal nolisp
setlocal autoindent
setlocal indentexpr=GoIndent(v:lnum)
setlocal indentkeys+=<:>,0=},0=)

let b:undo_indent = "setl ai< inde< indk< lisp<"

if exists('*GoIndent')
  finish
endif

function! GoIndent(lnum)
  let prevlnum = prevnonblank(a:lnum-1)
  if l:prevlnum == 0
    " top of file
    return 0
  endif

  " grab the previous and current line, stripping comments.
  let l:prevl = substitute(getline(l:prevlnum), '//.*$', '', '')
  let l:thisl = substitute(getline(a:lnum), '//.*$', '', '')
  let l:previ = indent(l:prevlnum)

  let l:ind = l:previ

  if l:prevl =~ '[\[({]\s*$'
    " previous line opened a block
    let l:ind += shiftwidth()
  endif

  if l:thisl =~ '^\s*[\])}]'
    " this line closed a block
    let l:ind -= shiftwidth()
  endif

  return l:ind
endfunction

" vim: sw=2 sts=2 et
