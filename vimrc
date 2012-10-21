" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" =============== Pathogen Initialization ===============
" This loads all the plugins in ~/.vim/bundle
" Use tpope's pathogen plugin to manage all other plugins

call pathogen#infect()
call pathogen#helptags()

" ================ General Config ====================

set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
" set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on

color desert

" ================ Search Settings  =================

set incsearch            "Find the next match as we type the search
set ignorecase smartcase "Ignore case, unless capitals are used
set viminfo='100,f1      "Save up to 100 marks, enable capital marks

" ================ Swap Files ==============

set backupdir=$HOME/.vim/backups
set directory=$HOME/.vim/backups

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.

set undodir=~/.vim/backups
set undofile

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Powerline ========================

set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs

" ================ Mappings ========================

" Set <leader> to comma
let mapleader = ","

" Remap , because it's still useful
noremap \ ,

" edit in current directory
nmap <leader>e :e %%

" switch to last-used file
nmap <leader><leader> <C-^>

" When going to marks, go to character instead of line
nmap ' `

" %% becomes current directory in command mode
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Edit .vimrc easily
nmap <leader>ve :tabedit $MYVIMRC<CR>

" Source .vimrc easily
nmap <leader>vs :source $MYVIMRC<CR>

" MRU shortcut
nmap <leader>r :MRU<CR>

" ALPHABETIZATION!
nmap <leader>s vii:!sort<CR>
vmap <leader>s :!sort<CR>

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Easier first/last characters on current line
"unmap L
"unmap H
"nnoremap H ^
"nnoremap L $

" toggle hlsearch and report status with <F4>
noremap <F4> :set hlsearch! hlsearch?<CR>

" Map ctrl-n and ctrl-N to next and previous in location list (bad idea?)
"nmap <c-n> :lnext<CR>
"nmap <c-N> :lprevious<CR>

" ================ Command-T Folders ========================

nmap <leader>gs :CommandT ./app/assets/stylesheets<CR>
nmap <leader>gs :CommandT ./app/views/layouts<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rename file
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Motions / Text Objects
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" CSS Value
onoremap <silent>v :<C-U>normal! ^f:llvt;<CR>
"onoremap <silent>A :<C-U>normal! 

" indent object
onoremap <silent>ai :<C-U>cal <SID>IndTxtObj(0)<CR>
onoremap <silent>ii :<C-U>cal <SID>IndTxtObj(1)<CR>
vnoremap <silent>ai :<C-U>cal <SID>IndTxtObj(0)<CR><Esc>gv
vnoremap <silent>ii :<C-U>cal <SID>IndTxtObj(1)<CR><Esc>gv

function! s:IndTxtObj(inner)
  let curline = line(".")
  let lastline = line("$")
  let i = indent(line(".")) - &shiftwidth * (v:count1 - 1)
  let i = i < 0 ? 0 : i
  if getline(".") !~ "^\\s*$"
    let p = line(".") - 1
    let nextblank = getline(p) =~ "^\\s*$"
    while p > 0 && ((i == 0 && !nextblank) || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner)) || (nextblank && !a:inner))))
      -
      let p = line(".") - 1
      let nextblank = getline(p) =~ "^\\s*$"
    endwhile
    normal! 0V
    call cursor(curline, 0)
    let p = line(".") + 1
    let nextblank = getline(p) =~ "^\\s*$"
    while p <= lastline && ((i == 0 && !nextblank) || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner)) || (nextblank && !a:inner))))
      +
      let p = line(".") + 1
      let nextblank = getline(p) =~ "^\\s*$"
    endwhile
    normal! $
  endif
endfunction
