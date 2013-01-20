" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pathogen Initialization
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This loads all the plugins in ~/.vim/bundle
" Use tpope's pathogen plugin to manage all other plugins

call pathogen#infect()
call pathogen#helptags()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
" set visualbell                "No sounds
set autoread                    "Reload files changed outside vim
set iskeyword+=-                "Include hyphens in words 

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on

" Remove delay when escaping
set ttimeoutlen=100

color desert

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search Settings 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set incsearch            "Find the next match as we type the search
set ignorecase smartcase "Ignore case, unless capitals are used
set viminfo='100,f1      "Save up to 100 marks, enable capital marks

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Swap Files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set backupdir=$HOME/.vim/backups
set directory=$HOME/.vim/backups

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Persistent Undo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keep undo history across sessions, by storing in file.
" Only works all the time.

set undodir=~/.vim/backups
set undofile

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation & Formatting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

filetype plugin on
filetype indent on

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

set formatoptions-=cro

" Set weird filetypes
au! BufNewFile,BufRead *.cshtml set filetype=html


""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folds
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Completion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~,*.psd,*.jpg,*.png,*.ai "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Scrolling
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Statusline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs

set statusline=%t       "tail of the filename
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Indent text object
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

" Rename file
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
" Command-T Folders
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <leader>gs :CommandT ./app/assets/stylesheets<CR>
nmap <leader>gl :CommandT ./app/views/layouts<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Motions / Text Objects
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" CSS Value
onoremap <silent>V :<C-U>normal! ^f:lvt;<CR>

" CSS Attribute
onoremap <silent>A :<C-U>normal! ^vt:<CR>

" indent object
onoremap <silent>ai :<C-U>cal <SID>IndTxtObj(0)<CR>
onoremap <silent>ii :<C-U>cal <SID>IndTxtObj(1)<CR>
vnoremap <silent>ai :<C-U>cal <SID>IndTxtObj(0)<CR><Esc>gv
vnoremap <silent>ii :<C-U>cal <SID>IndTxtObj(1)<CR><Esc>gv

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set <leader> to comma
let mapleader = ","

" Remap "," because it's still useful
noremap \ ,

" switch to last-used file
nmap <leader><leader> <C-^>

" easily set filetype
nnoremap <leader>f :set filetype=

" Edit .vimrc easily
nmap <leader>ve :tabedit $MYVIMRC<CR>

" Source .vimrc easily
nmap <leader>vs :source $MYVIMRC<CR>

" Alphabetize stuff
nmap <leader>s vii:!sort<CR>
xmap <leader>s :!sort<CR>

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" toggle search highlighting and report status with <F4>
noremap <F4> :set hlsearch! hlsearch?<CR>

" auto-indent pastes
nnoremap p p=`]

" Y acts like it should
nnoremap Y y$

" === Lists ===

" browse argument list easily
nnoremap ]a :next<CR>
nnoremap [a :prev<CR>
nnoremap ]A :last<CR>
nnoremap [A :first<CR>

" browse buffer list easily
nnoremap ]b :bnext<CR>
nnoremap [b :bprev<CR>
nnoremap ]B :blast<CR>
nnoremap [B :bfirst<CR>

" browse quickfix list easily
nnoremap ]c :cnext<CR>
nnoremap [c :cprev<CR>
nnoremap ]C :clast<CR>
nnoremap [C :cfirst<CR>

" browse location list easily
nnoremap ]l :lnext<CR>
nnoremap [l :lprev<CR>
nnoremap ]L :llast<CR>
nnoremap [L :lfirst<CR>

" easy dashrocket
imap <C-f> ->

" easy hashrocket
imap <C-h> =>

source ~/.vim/plugin_config.vim

" === Temporary ===

" Load generated CSS to clipboard
nnoremap <leader>c :let @+ = join(readfile("stylesheets/base.css"), "\n")<CR>
