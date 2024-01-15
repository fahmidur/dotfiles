"------------------------------------------------------------------------------
"--- BEG. Options
"------------------------------------------------------------------------------

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set guioptions-=m " Remove menubar
set guioptions-=T " Remove toobar
set guioptions-=r " Remove Right-hand scroll-bar
set guioptions-=L " Remove Left-hand scroll-bar

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

"set t_Co=256 # SFR: no long advised, let vim decide based on $TERM
" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on
endif

if has("gui_running")
  "set guifont=Source\ Code\ Pro\ 11
  "set guifont=Monospace\ Regular\ 11
  set guifont=Courier\ Prime\ 11
endif

" prevent comma in text from auto-indenting
autocmd FileType text setlocal nocindent

let g:vim_json_syntax_conceal = 0

"------------------------------------------------------------------------------
"--- END. Options
"------------------------------------------------------------------------------

"------------------------------------------------------------------------------
"--- BEG. Plugins
"------------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')
  Plug 'vim-airline/vim-airline'  " Airline
  Plug 'vim-airline/vim-airline-themes'
  Plug 'flazz/vim-colorschemes'   " Large collection of colorschemes
  Plug 'kien/ctrlp.vim'           " Fuzzy file/buffer search
  Plug 'airblade/vim-gitgutter'   " Git changes in the gutter
  Plug 'scrooloose/nerdtree'      " Side file tree
  "Plug 'majutsushi/tagbar'        " Tagbar
  Plug 'preservim/tagbar'
  "Plug 'liuchengxu/vista.vim'
  Plug 'mileszs/ack.vim'          " Search entire repo
  Plug 'scrooloose/nerdcommenter' " Comment and Uncomment
  Plug 'tpope/vim-fugitive'       " For things like Gblame
  Plug 'Yggdroot/indentLine'      " Display indentation using pipes
  Plug 'SirVer/ultisnips'         " Snippets Engine
  Plug 'honza/vim-snippets'       " Snippets Collection
  Plug 'ervandew/supertab'
  Plug 'posva/vim-vue'
  Plug 'ziglang/zig.vim'
  "Plug 'junegunn/goyo.vim'
  "Plug 'sheerun/vim-polyglot'    "Annoying
  "Plug '907th/vim-auto-save'     " Defective
  " themes
  Plug 'NLKNguyen/papercolor-theme'
  Plug 'arcticicestudio/nord-vim', {'branch': 'main'}
  "Plug 'dense-analysis/ale'
  "Plug 'psf/black', { 'branch': 'stable' } " Python linting
call plug#end()
"------------------------------------------------------------------------------
"--- END. Plugins
"------------------------------------------------------------------------------

"------------------------------------------------------------------------------
"--- BEG. Key Mappings
"------------------------------------------------------------------------------
let mapleader=","

nmap <silent> <c-n> :NERDTreeToggle<CR>
nmap <silent> <Leader>n :NERDTreeFind<CR>
nmap <silent> <Leader>m :only<CR>
nmap <silent> <Leader>r :TagbarToggle<CR> <c-w>w
nmap <silent> <Leader>b :CtrlPBuffer<CR>

" SFR: Hack to allow saving when not started in sudo
noremap <Leader>W :w !sudo tee % > /dev/null


" SFR: I love this one
noremap ; :

noremap <Leader>f :Ack 

"noremap <Leader>q :q<CR>
noremap <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>
"------------------------------------------------------------------------------
"--- END. Key Mappings
"------------------------------------------------------------------------------

"------------------------------------------------------------------------------
" --- --- DISORGANIZED STUFF BELOW --- ---
"------------------------------------------------------------------------------

if has("vms")
  set nobackup		  " do not keep a backup file, use versions instead
  set noswapfile    " do not make swap files
else
  set backup
  set backupdir=~/.vim/backupdir//
  set directory=~/.vim/swpdir//
  set undofile
  set undodir=~/.vim/undodir//
endif

set undolevels=10000
set undoreload=10000
set history=50		" keep 50 lines of command line history
set ruler		      " show the cursor position all the time
set showcmd		    " display incomplete commands
set incsearch		  " do incremental searching


" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
  "set cindent!

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " Set syntax for Rexfile (a Perl configuration management package)
  autocmd BufNewFile,BufRead Rexfile set syntax=perl

  " For all text files set 'textwidth' to 80 characters.
  "autocmd FileType text setlocal textwidth=80

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
" au FocusLost * silent! :wa

" autosave when changing buffers
set autowriteall
"let g:auto_save = 1  " enable AutoSave on Vim startup
"let g:auto_save_write_all_buffers = 1  " write all open buffers as if you would use :wa

au BufNewFile,BufRead *.ejs set filetype=html

"set cursorline
set expandtab " use spaces instead of tabs
set tabstop=2
set shiftwidth=2
set nu
set clipboard=unnamedplus " use the x11 clipboard

" highlight Normal ctermfg=white ctermbg=black
"colorscheme predawn
"colorscheme dracula
"colorscheme atom
"if has("gui_running")
  "colorscheme gotham
"else
  "colorscheme gotham256
"endif
set background=dark
colorscheme PaperColor
"colorscheme materialbox
"colorscheme nord
"---
"let g:airline_theme='nord'
"let g:airline_theme='wombat'
"let g:airline_theme='papercolor'
"if has("gui_running")
  "" airline fonts are broken on gvim for some reason
  ""let g:airline_powerline_fonts=0
  ""let g:airline_powerline_fonts=1
"else
  ""let g:airline_powerline_fonts=1
  "" SFR: > nevermind, powerline does not look that great anyway.
  ""let g:airline_powerline_fonts=0
"endif
let g:airline_powerline_fonts=1

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

"--- BEG. Configure ctrlp
"let g:ctrlp_clear_cache_on_exit = 0
"let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:snips_author = 'SFR'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules|out|docs|dlcache)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }
 
let g:ctrlp_cmd='CtrlP :pwd'
"--- END. Configure ctrlp

let g:indentLine_char = '│'

command W w

if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

filetype plugin on

" Change background color based on Normal/Insert Move
"au InsertEnter * hi Normal ctermbg=234 guibg=#000000
"au InsertLeave * hi Normal ctermbg=232 guibg=#1b1d1e

autocmd BufNewFile,BufRead *.sh.ejs set syntax=sh

let NERDTreeShowHidden=1
" Workaround for NerdTree + Vim9 compatibility issue
" https://github.com/preservim/nerdtree/issues/1321
let g:NERDTreeMinimalMenu=1

highlight ColorColumn ctermbg=235 guibg=#232323
"let &colorcolumn=join(range(81,999),",")

augroup custom001
  au!
  autocmd BufNewFile,BufRead *.sh.ejs   set syntax=sh
  autocmd BufNewFile,BufRead *.js.ejs   set syntax=javascript
augroup END

set viminfo+=n~/.vim/viminfo
set conceallevel=0

set belloff=all


" { fix-airline {
" https://vi.stackexchange.com/questions/3359/how-do-i-fix-the-status-bar-symbols-in-the-airline-plugin
" air-line
"if has('gui_running') 
  "set guifont="monospace"
"endif
"if !exists('g:airline_symbols')
  "let g:airline_symbols = {}
"endif

"" unicode symbols
"let g:airline_left_sep = '»'
"let g:airline_left_sep = '▶'
"let g:airline_right_sep = '«'
"let g:airline_right_sep = '◀'
"let g:airline_symbols.linenr = '␊'
"let g:airline_symbols.linenr = '␤'
"let g:airline_symbols.linenr = '¶'
"let g:airline_symbols.branch = '⎇'
"let g:airline_symbols.paste = 'ρ'
"let g:airline_symbols.paste = 'Þ'
"let g:airline_symbols.paste = '∥'
"let g:airline_symbols.whitespace = 'Ξ'

"" airline symbols
"let g:airline_left_sep = ''
"let g:airline_left_alt_sep = ''
"let g:airline_right_sep = ''
"let g:airline_right_alt_sep = ''
"let g:airline_symbols.branch = ''
"let g:airline_symbols.readonly = ''
"let g:airline_symbols.linenr = ''
" } fix-airline }


