" FILE: curl/async.vim
" AUTHOR: Toshiki Teramura <toshiki.teramura@gmail.com>
" LICENCE: MIT

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:curl#pool")
  let g:curl#pool = {}
endif

function! s:execute_callback() abort
  for id in keys(g:curl#pool)
    let obj = g:curl#pool[id]
    let pobj = obj.process
    let [st, _]= pobj.checkpid()
    if st != 'run'
      call obj.callback({})
      call remove(g:curl#pool, id)
    endif
  endfor
  if len(g:curl#pool) == 0
    augroup curl-vimproc
      autocmd!
    augroup END
  endif
endfunction

function! s:async(command, callback) abort
  if type(a:callback) != 2 " function
    throw "curl.vim: callback is not a function"
  endif
  let pobj = vimproc#popen2(a:command)
  let id = localtime()
  let g:curl#pool[id] = {
        \ "callback": a:callback,
        \ "process": pobj
        \ }
  augroup curl-vimproc
    autocmd! CursorHold,CursorHoldI * call s:execute_callback()
  augroup END
endfunction

function! s:echo(res) abort
  echo a:res
endfunction

function! curl#async#get(callback, ...) abort
  call s:async("sleep 10", function("s:echo"))
  " TODO: implement
endfunction

function! curl#async#post(url, data, callback, ...) abort
  " TODO: implement
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
