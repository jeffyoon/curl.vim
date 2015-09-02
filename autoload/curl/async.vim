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
    let [st, _]= obj.process.checkpid()
    if st != 'run'
      let res = curl#util#make_response(obj.settings)
      call obj.callback(res)
      call remove(g:curl#pool, id)
    endif
  endfor
  if len(g:curl#pool) == 0
    augroup plugin-curl-async
      autocmd!
    augroup END
  endif
endfunction

function! s:async(command, callback, settings) abort
  if type(a:callback) != 2 " function
    throw "curl.vim: callback is not a function"
  endif
  let pobj = vimproc#popen2(a:command)
  let id = localtime()
  let g:curl#pool[id] = {
        \ "callback": a:callback,
        \ "settings": a:settings,
        \ "process": pobj,
        \ }
  augroup plugin-curl-async
    autocmd! CursorHold,CursorHoldI * call s:execute_callback()
  augroup END
endfunction

function! curl#async#request(url, callback, settings) abort
  let command = curl#util#make_command(a:url, a:settings)
  call s:async(command, a:callback, a:settings)
endfunction

function! curl#async#get(url, callback, ...) abort
  if len(a:000) > 0 && type(a:1) == type({})
    let settings = a:1
  else
    let settings = {}
  endif
  let settings.method = "GET"
  return curl#async#request(a:url, a:callback, settings)
endfunction

function! curl#async#post(url, data, callback, ...) abort
  if len(a:000) > 0 && type(a:1) == type({})
    let settings = a:1
  else
    let settings = {}
  endif
  let settings.method = "POST"
  let settings.data = a:data
  return curl#async#request(a:url, a:callback, settings)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
