" FILE: curl/async.vim
" AUTHOR: Toshiki Teramura <toshiki.teramura@gmail.com>
" LICENCE: MIT

let s:save_cpo = &cpo
set cpo&vim

function! curl#async#get(url, callback, ...) abort
  " TODO: implement
endfunction

function! curl#async#post(url, data, callback, ...) abort
  " TODO: implement
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
