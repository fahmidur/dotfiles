let mapleader=","

"set colorcolumn=80

" Hack to allow saving when not started in sudo
noremap <Leader>W :w !sudo tee % > /dev/null
noremap <Leader>q :q<CR>
noremap ; :
noremap <Leader>f :Ack 
"noremap <Leader>o
"inoremap jj <esc>

"set runtimepath^=~/.vim/plugin/ctrlp.vim

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
"set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME

" Bugfix for slow Ruby syntax highlighting
" Forces VIM to use an older and better regex engine.
set re=1

set path+=**
set wildmenu


set t_Co=256

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup
  set backupdir=~/.vim/backupdir//
  set directory=~/.vim/swpdir//
  set undofile
  set undodir=~/.vim/undodir//
  set undolevels=1000
  set undoreload=10000
endif
set nobackup
set noswapfile

set history=50		" keep 50 lines of command line history
set ruler		    " show the cursor position all the time
set showcmd		    " display incomplete commands
set incsearch		" do incremental searching


" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern. -- NO
if &t_Co > 2 || has("gui_running")
  syntax on
  " set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  augroup END
else
  set autoindent		" always set autoindenting on
endif " has("autocmd")a

set autoindent

" write whenever focus is lost
au FocusLost * silent! :wa

" autosave when changing buffers
set autowriteall


au BufNewFile,BufRead *.ejs set filetype=html

set cursorline
set expandtab " Use spaces instead of tabs
set tabstop=2
set shiftwidth=2
set nu
set clipboard=unnamedplus " The x11 clipboard

" highlight Normal ctermfg=white ctermbg=black
" colorscheme delek
" colorscheme delek
colorscheme predawn

"set background=dark
"colorscheme material-theme

let g:airline_theme='wombat'
let g:airline_powerline_fonts=1
set laststatus=2

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

call plug#begin('~/.vim/plugged')
Plug 'kien/ctrlp.vim'           " Fuzzy file/buffer search
Plug 'airblade/vim-gitgutter'   " Git changes in the gutter
Plug 'ervandew/supertab'
Plug 'scrooloose/nerdtree'      " Side file tree
Plug 'majutsushi/tagbar'        " Tagbar
Plug 'mileszs/ack.vim'          " Search entire repo
Plug 'scrooloose/nerdcommenter' " Comment and Uncomment
Plug 'tpope/vim-fugitive'       " For things like Gblame
Plug 'Yggdroot/indentLine'      " Display indentation using pipes
Plug 'SirVer/ultisnips'         " Snippets Engine
Plug 'honza/vim-snippets'       " Snippets Collection
"Plug 'junegunn/goyo.vim'       " Distraction-Free Mode
"Plug 'mhinz/vim-signify'
"Plug 'Valloric/YouCompleteMe'  " Magical auto-completion
"Plug 'vim-scripts/AutoComplPop' " Auto trigger completion
"Plug 'nathanaelkane/vim-indent-guides'
call plug#end()

"let g:NERDTreeQuitOnOpen = 1
" Does not behave as expected

"BEG. Configure ctrlp
"let g:ctrlp_clear_cache_on_exit = 0
"let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

let g:snips_author = 'SFR'

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }
"END. Configure ctrlp

let g:indentLine_char = '│'


nmap <silent> <c-n> :NERDTreeToggle<CR>
nmap <silent> <Leader>n :NERDTreeFind<CR>
nmap <silent> <Leader>m :only<CR>
" nmap <c-_> gcc " Does not work as expected

nmap <silent> <Leader>r :TagbarToggle<CR> <c-w>w
"nmap <silent> <Leader>w <c-w>w
"imap <silent> <Leader>w <c-w>w
"nmap <c-p> :find 
nmap <c-b> :CtrlPBuffer<CR>

command W w

if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

filetype plugin on

set guioptions -=m " Remove menubar
set guioptions -=T " Remove toobar
set guioptions -=r " Remove Right-hand scroll-bar
set guioptions -=L " Remove Left-hand scroll-bar

" Change background color based on Normal/Insert Move
"au InsertEnter * hi Normal ctermbg=234 guibg=#000000
"au InsertLeave * hi Normal ctermbg=232 guibg=#1b1d1e

let NERDTreeShowHidden=1