" FILE: curl.vim
" AUTHOR: Toshiki Teramura <toshiki.teramura@gmail.com>
" LICENCE: MIT

let s:save_cpo = &cpo
set cpo&vim

function! curl#get(url, ...) abort
  " TODO: implement
endfunction

function! curl#post(url, data, ...) abort
  " TODO: implement
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
