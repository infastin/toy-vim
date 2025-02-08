" Vim filetype plugin file
" Language: Toy
" Maintainer: infastin <infastin@yandex.com>
" URL: https://github.com/infastin/vim-toy

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s
