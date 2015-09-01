" FILE: curl.vim
" AUTHOR: Toshiki Teramura <toshiki.teramura@gmail.com>
" LICENCE: MIT

let s:save_cpo = &cpo
set cpo&vim

function! s:tempname() abort
  return tr(tempname(),'\','/')
endfunction

function! s:base_command() abort
  if executable("curl")
    return "curl"
  endif
  " TODO: for Windows?
  throw "curl.vim: curl does not found."
endfunction

function! s:quoted(str) abort
  let q = (&shellxquote == '"' ?  "'" : '"')
  return q . str . q
endfunction

function! s:make_header_args(headdata, option) abort
  let args = ''
  for [key, value] in items(a:headdata)
    if s:Prelude.is_windows()
      let value = substitute(value, '"', '"""', 'g')
    endif
    let args .= " " . a:option . " " . s:quoted(key . ": " . value)
  endfor
  return args
endfunction

function! s:add_option(setting, opt, prefix) abort
  if has(a:settings, opt)
    return " " . prefix . " " . a:settings[opt]
  endif
  return ""
endfunction

function! s:auth_option(settings) abort
  if !has_key(a:settings, 'username')
    return ""
  endif
  let auth = a:settings.username . ':' . get(a:settings, 'password', '')
  if has_key(a:settings, 'authMethod')
    if index(['basic', 'digest', 'ntlm', 'negotiate'], a:settings.authMethod) == -1
      throw 'curl.vim: Invalid authorization method: ' . a:settings.authMethod
    endif
    let method = a:settings.authMethod
  else
    let method = "anyauth"
  endif
  return ' --' . method . ' --user ' . s:quoted(auth)
endfunction

function! s:make_command(url, setting) abort
  let command = s:base_command()

  " output files
  let a:settings._file = {
        \ 'header': s:tempname(),
        \ 'body': get(a:settings, "outputFile", s:tempname())
        \ }
  let command .= ' --dump-header ' . s:quoted(a:settings._file.header)
  let command .= ' --output ' . s:quoted(a:settings._file.body)
  if has_key(a:settings, 'data')
    let a:settings._file.post = s:tempname()
    call writefile(a:settings.data, a:settings._file.post, 'b')
    let command .= ' --data-binary @' . s:quoted(a:settings._file.post)
  endif
  if has_key(a:settings, 'gzipDecompress') && a:settings.gzipDecompress
    let command .= ' --compressed'
  endif

  " basic
  let command .= ' -L' " location
  let command .= ' -s' " silent

  " network
  let command .= ' -k' " unsafe SSL
  let command .= s:add_option(a:settings, 'method', '-X')
  let command .= s:add_option(a:settings, 'maxRedirect', '--max-redirs')
  let command .= s:add_option(a:settings, 'timeout', '--max-time')
  let command .= s:add_option(a:settings, 'retry', '--retry')
  let command .= s:make_header_args(a:settings.headers, '-H')
  let command .= s:auth_option(a:settings)

  let command .= ' ' . s:quoted(a:url)
  return command
endfunction

function! curl#get(url, ...) abort
  " TODO: implement
endfunction

function! curl#post(url, data, ...) abort
  " TODO: implement
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
