syntax enable
syntax on
set t_Co=256
set background=dark
colorscheme solarized

set cursorline
set cursorcolumn
set fencs=utf-8,big5
set fenc=utf-8
set enc=utf8
set mouse=nv
set number
set ic
set tabstop=4
set shiftwidth=4
set wrap
set hlsearch

"set laststatus=2
"set statusline=[%{expand('%:p')}][%{strlen(&fenc)?&fenc:&enc},\ %{&ff},\ %{strlen(&filetype)?&filetype:'plain'}]%{FileSize()}%{IsBinary()}%=%c,%l/%L\ [%3p%%]

hi StatuslineBufNr     cterm=none    ctermfg=black  ctermbg=cyan    gui=none guibg=#840c0c guifg=#ffffff
hi StatuslineFlag      cterm=none    ctermfg=black  ctermbg=cyan    gui=none guibg=#bc5b4c guifg=#ffffff
hi StatuslinePath      cterm=none    ctermfg=white  ctermbg=green   gui=none guibg=#8d6c47 guifg=black
hi StatuslineFileName  cterm=none    ctermfg=white  ctermbg=blue    gui=none guibg=#d59159 guifg=black
hi StatuslineFileEnc   cterm=none    ctermfg=white  ctermbg=yellow  gui=none guibg=#ffff77 guifg=black
hi StatuslineFileType  cterm=bold    ctermbg=white  ctermfg=black   gui=none guibg=#acff84 guifg=black
hi StatuslineTermEnc   cterm=none    ctermbg=white  ctermfg=yellow  gui=none guibg=#77cf77 guifg=black
hi StatuslineChar      cterm=none    ctermbg=white  ctermfg=yellow  gui=none guibg=#66b06f guifg=black
hi StatuslineSyn       cterm=none    ctermbg=white  ctermfg=yellow  gui=none guibg=#60af9f guifg=black
hi StatuslineRealSyn   cterm=none    ctermbg=white  ctermfg=yellow  gui=none guibg=#5881b7 guifg=black
hi StatusLine          cterm=none    ctermbg=white  ctermfg=yellow  gui=none guibg=#3f4d77 guifg=#729eb0
hi StatuslineTime      cterm=none    ctermfg=black  ctermbg=cyan    gui=none guibg=#3a406e guifg=#000000
hi StatuslineSomething cterm=reverse ctermfg=white  ctermbg=darkred gui=none guibg=#c0c0f0 guifg=black
hi StatusLineNC                                                     gui=none guibg=#304050 guifg=#70a0a0

let g:statusline_max_path = 20
fun! StatusLineGetPath() "{{{
  let p = expand('%:.:h') "relative to current path, and head path only
  let p = substitute(p,'\','/','g')
  let p = substitute(p, '^\V' . $HOME, '~', '')
  if len(p) > g:statusline_max_path
    let p = simplify(p)
    let p = pathshorten(p)
  endif
  return p
endfunction "}}}

nmap <Plug>view:switch_status_path_length :let g:statusline_max_path = 200 - g:statusline_max_path<cr>
nmap ,t <Plug>view:switch_status_path_length

set laststatus=2

augroup Statusline
    au! Statusline

    au BufEnter * call <SID>SetFullStatusline()
    au BufLeave,BufNew,BufRead,BufNewFile * call <SID>SetSimpleStatusline()
augroup END

fun! StatusLineRealSyn()
    let synId = synID(line('.'),col('.'),1)
    let realSynId = synIDtrans(synId)
    if synId == realSynId
        return 'Normal'
    else
        return synIDattr( realSynId, 'name' )
    endif
endfunction

fun! s:SetFullStatusline() "{{{
    setlocal statusline=
    setlocal statusline+=%#StatuslineBufNr#%-1.2n\                                               " buffer number
    setlocal statusline+=%h%#StatuslineFlag#%m%r%w                                               " flags
    setlocal statusline+=%#StatuslinePath#\ %-0.20{StatusLineGetPath()}%0*                       " path
    setlocal statusline+=%#StatuslineFileName#\/%t\                                              " file name

    setlocal statusline+=%#StatuslineFileEnc#\ %{&fileencoding}\                                 " file encoding
    setlocal statusline+=%#StatuslineFileType#\ %{strlen(&ft)?&ft:'**'}\ .                       " filetype
    setlocal statusline+=%#StatuslineFileType#%{&fileformat}\                                    " file format
    setlocal statusline+=%#StatuslineTermEnc#\ %{&termencoding}\                                 " encoding
    setlocal statusline+=%#StatuslineChar#\ %-2B\ %0*                                            " current char
    setlocal statusline+=%#StatuslineSyn#\ %{synIDattr(synID(line('.'),col('.'),1),'name')}\ %0* " syntax name
    setlocal statusline+=%#StatuslineRealSyn#\ %{StatusLineRealSyn()}\ %0*                       " real syntax name
    setlocal statusline+=%=
    setlocal statusline+=\ %-13.(%l/%L,%c-%v%)                                                   "position
    setlocal statusline+=%P                                                                      "position percentage
    setlocal statusline+=\ %#StatuslineTime#%{strftime(\"%m-%d\ %H:%M\")}                        " current time

endfunction "}}}

fun! s:SetSimpleStatusline() "{{{
    setlocal statusline=
    setlocal statusline+=%#StatuslineNC#%-0.20{StatusLineGetPath()}%0* " path
    setlocal statusline+=\/%t\                                         " file name
endfunction "}}}
 
function IsBinary()
    if (&binary == 0)
        return ""
    else
        return "[Binary]"
    endif
endfunction
 
function FileSize()
    let bytes = getfsize(expand("%:p"))
    if bytes <= 0
        return "[Empty]"
    endif
    if bytes < 1024
        return "[" . bytes . "B]"
    elseif bytes < 1048576
        return "[" . (bytes / 1024) . "KB]"
    else
        return "[" . (bytes / 1048576) . "MB]"
    endif
endfunction

set nobackup

let &titlestring = expand("%:p")
if &term == "screen"
  set t_ts=^[k
  set t_fs=^[\
endif
if &term == "screen" || &term == "xterm"
  set title
endif

nnoremap <silent> <F5> :NERDTree<CR>
let NERDTreeWinSize=22

