"=============================================================================
" FILE: autoload/rot47.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" { 's': Numer, 'e': Numer, 'n': Numer }
let s:rot = {}

function! s:rot._pattern() abort
  return printf('\([%s-%s]\)', nr2char(self.s), nr2char(self.e))
endfunction

function! s:rot.char(c) abort
  let cn = char2nr(a:c)
  if cn < self.s || self.e < cn
    return a:c
  endif
  let r = cn + self.n
  return nr2char(r > self.e ? r - (self.e - self.s + 1) : r)
endfunction

function! s:rot.text(text) abort
  return substitute(a:text, self._pattern(), '\=self.char(submatch(1))', 'g')
endfunction

" @start char to start or the number value of it
" @n numer like 47 or the end char
function! rot47#new(n, ...) abort
  let start = get(a:, 1, 33)
  let s = type(start) == type('') ? char2nr(start) : start
  let e = type(a:n)   == type('') ? char2nr(a:n)     : (s + (a:n * 2 - 1))
  let n = (e - s + 1) / 2
  return extend(deepcopy(s:rot), {'s': s, 'e': e, 'n': n})
endfunction

let s:rot47 = rot47#new(47, '!')

function! rot47#text(text) abort
  return s:rot47.text(a:text)
endfunction

" 33                                                                                          126
" !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
" 80                                                                                           79
" PQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~!"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNO

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker

