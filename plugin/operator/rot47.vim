"=============================================================================
" FILE: plugin/operator/rot47.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
if expand('%:p') ==# expand('<sfile>:p')
  unlet! g:loaded_rot47
endif
if exists('g:loaded_rot47')
  finish
endif
let g:loaded_rot47 = 1
let s:save_cpo = &cpo
set cpo&vim

call operator#user#define('rot47', 'operator#rot47#do')

if !hasmapto('<Plug>(operator-rot47)')
  map g! <Plug>(operator-rot47)
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
