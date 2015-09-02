# curl.vim
An async HTTP client for vim/vimscript

## Usage

```vim
function! Echo(res) abort
  echo a:res
endfunction

let callback = function("Echo")
call curl#async#get("http://httpbin.org/ip", callback)
```

## TODOs
- [x] implement sync HTTP client (equivalent to the curl part of Vital.Web.HTTP)
- [x] implement async HTTP client using vimproc
- [ ] Add test and CI environment ([haya14busa/vim-ci-starterkit](https://github.com/haya14busa/vim-ci-starterkit) will be helpful)
