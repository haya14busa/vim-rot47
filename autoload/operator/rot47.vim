"=============================================================================
" FILE: autoload/operator/rot47.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" -- helper
" ref: https://github.com/kana/vim-operator-replace/blob/ea388421b0637b8dd68b3db669cb81029353e667/autoload/operator/replace.vim

function! s:visual_command_from_wise_name(wise_name) abort
  if a:wise_name ==# 'char'
    return 'v'
  elseif a:wise_name ==# 'line'
    return 'V'
  elseif a:wise_name ==# 'block'
    return "\<C-v>"
  else
    echoerr 'E1: Invalid wise name:' string(a:wise_name)
    return 'v'  " fallback
  endif
endfunction

function! s:deletion_moves_the_cursor_p(motion_wise,
\                                       motion_end_pos,
\                                       motion_end_last_col,
\                                       buffer_end_pos) abort
  let [buffer_end_line, buffer_end_col] = a:buffer_end_pos
  let [motion_end_line, motion_end_col] = a:motion_end_pos

  if a:motion_wise ==# 'char'
    return ((a:motion_end_last_col == motion_end_col)
    \       || (buffer_end_line == motion_end_line
    \           && buffer_end_col <= motion_end_col))
  elseif a:motion_wise ==# 'line'
    return buffer_end_line == motion_end_line
  elseif a:motion_wise ==# 'block'
    return 0
  else
    echoerr 'E2: Invalid wise name:' string(a:wise_name)
    return 0
  endif
endfunction

function! s:is_empty_region(begin, end) abort
  " Whenever 'operatorfunc' is called, '[ is always placed before '] even if
  " a backward motion is given to g@.  But there is the only one exception.
  " If an empty region is given to g@, '[ and '] are set to the same line, but
  " '[ is placed after '].
  return a:begin[1] == a:end[1] && a:end[2] < a:begin[2]
endfunction

" -- main

function! operator#rot47#do(motion_wise) abort
  let visual_command = s:visual_command_from_wise_name(a:motion_wise)
    " v:register will be overwritten by "_d, so that the current value of
    " v:register must be saved before deletion.  Without saving, it's not
    " possible to what "{register} user gives.
  let register = v:register != '' ? v:register : '"'

  let put_command = (s:deletion_moves_the_cursor_p(
  \                    a:motion_wise,
  \                    getpos("']")[1:2],
  \                    len(getline("']")),
  \                    [line('$'), len(getline('$'))]
  \                  )
  \                  ? 'p'
  \                  : 'P')

  if !s:is_empty_region(getpos("'["), getpos("']"))
    let save = getreg('"', 1)
    let save_type = getregtype('"')
    let original_selection = &g:selection
    let &g:selection = 'inclusive'
    try
      execute 'normal!' '`['.visual_command.'`]""d'
      let @" = rot47#text(@")
      execute 'normal!' '""'.put_command
    finally
      call setreg('"', save, save_type)
      let &g:selection = original_selection
    endtry
    return
  end
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
