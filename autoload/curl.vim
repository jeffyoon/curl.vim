" FILE: curl.vim
" AUTHOR: Toshiki Teramura <toshiki.teramura@gmail.com>
" LICENCE: MIT

let s:save_cpo = &cpo
set cpo&vim

function! curl#request(url, settings)abort
  let command = curl#util#make_command(a:url, a:settings)
  call vimproc#system(command)
  if vimproc#get_last_status() != 0
    throw 'curl.vim: curl command failed.'
  endif
  return curl#util#make_response(a:settings)
endfunction

function! curl#get(url, ...)abort
  if len(a:000) > 0 && type(a:1) == type({})
    let settings = a:1
  else
    let settings = {}
  endif
  let settings.method = "GET"
  return curl#request(a:url, settings)
endfunction

function! curl#post(url, data, ...) abort
  if len(a:000) > 0 && type(a:1) == type({})
    let settings = a:1
  else
    let settings = {}
  endif
  let settings.method = "POST"
  let settings.data = a:data
  return curl#request(a:url, settings)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
