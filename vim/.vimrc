set nocompatible

filetype plugin indent on

if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    set fileencodings=ucs-bom,utf-8,latin1
    set isprint=@,161-255
    set list listchars=tab:¶·,trail:·
else
    set list listchars=tab:P.,trail:.
endif

let mapleader=","
set number
set ruler
syntax on

set backspace=indent,eol,start
set scrolloff=3

" Relative line numbering
set relativenumber

" Whitespace
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full

set fileformats=unix,mac,dos

set magic
"Map Shift+Tab to insert tabs
inoremap <S-Tab> <C-V><Tab>

set history=500 "500 lines of command line history

set directory=~/vim/.swp,/tmp

set tabpagemax=40

" Status bar
set laststatus=2
