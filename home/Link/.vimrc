" Link's stuff
" UTF-8
set encoding=utf-8
" When opening a new line and no filetype-specific indenting is enabled, keep the same indent as the line you're currently on.
set autoindent
" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
" Set the command window height to 2 lines, to avoid many cases of having to press <Enter> to continue
set cmdheight=2
" Display the cursor position on the last line of the screen or in the status line of a window
set ruler
" Always display the status line, even if only one window is displayed
set laststatus=2
" Display line numbers on the left
set nonumber " disabled
" Switch on search pattern highlighting.
set hlsearch
" Set enrcyption method to blowfish
set cryptmethod=blowfish
" Spellcheck dictionary
set spelllang=en
" Turn spellcheck off
set nospell
" Make vim case insensitive...
set ignorecase
" ...Except when we explicitly type a capital
set smartcase
" Jump to matches as you search
set incsearch
" Turn wrapping off
set nowrap
" Wrap per word, not character
set lbr
" Number of characters from right window border where newline is inserted (wrap long lines for copying). 0 disables.
set wrapmargin=0
" Max # of chars before newline autoinsert. Keeps text readable.
"set textwidth=75
" Apply formatting options automatically (tw)
set formatoptions-=a
" Set some GUI specific options
if has("gui_running")
	" Hide mouse while typing. GVIM only
	set mousehide
	" Toggle menubar with \mb
	nnore <expr><leader>mb &go =~# 'm' ? ":\<C-U>set go-=m\<CR>" : ":\<C-U>set go+=m\<CR>"
	" tearoff menubar menus
	set guioptions=t
	" Set a consistent font size across all systems
	set guifont=Courier_New:h10
	" Set font for unicode characters
	set guifontwide=DFKai-SB:h12
endif

" Set pate mode under *nix
"if has("unix")
"	inoremap <S-Insert> <ESC>:set paste<CR>i<S-Insert><ESC>:set nopaste<CR>i
"	set paste
"endif

" Syntax highlighting. If you turn it on more than once it screws up colors, hence the if statement
if !exists("syntax_on")
	syntax on
endif

" Redraw screen + search highlighting off until search
nnoremap <C-L> :nohl<CR><C-L>
" Call SkyBison with \;
nnoremap <leader>; :<c-u>call SkyBison("")<cr>
let g:skybison_fuzz = 2
" Exit insert mode with jj
inoremap jj <Esc>
" Hide vim pr0n
"noremap <F3> mzggVGg?`z
if has('win32') || has('win64')
	" Build C++ amd64 binary with Visual Studio 2013
	noremap <F7> :VimShellBufferDir -popup<CR><ESC>:wincmd p<CR>:call vimshell#interactive#send("C:/PROGRA~2/MICROS~1.0/VC/bin/amd64/vcvars64.bat & cl /EHsc <C-r>=expand("%:t")<CR>")<CR>
	" Build C++ binary with MinGW G++
	noremap <F8> :VimShellBufferDir -popup<CR><ESC>:wincmd p<CR>:call vimshell#interactive#send("C:/MinGW/bin/g++ -o gccbuild.exe <C-r>=expand("%:t")<CR>")<CR>
endif
" Show VimFiler
noremap <F10> :VimFilerExplorer<CR>
" Unite search recently used, sub directories, and recent directories
nnoremap <C-p> :Unite -start-insert file_mru directory_mru<cr>
" Unite quick select buffers
nnoremap <space>s :Unite -quick-match buffer<cr>
" Unite yank history
let g:unite_source_history_yank_enable = 1
nnoremap <space>y :Unite history/yank<cr>

" VimShell. Shell window will be auto closed after termination
" Ctrl_W e opens up a vimshell in a horizontally split window
nnoremap <C-W>e :new \| VimShell<CR>
" Ctrl_W E opens up a vimshell in a vertically split window
nnoremap <C-W>E :vnew \| VimShell<CR>

" Fix temp folder under Windows
" breaks vundle
"if has('win32') || has('win64')
"	let $TMP="$TEMP"
"endif

"Elevate vim under windows.
if has('win32') || has('win64')
	noremap <C-e> :mksession! ~/vimfiles/elevate.vim<Return>:silent exec '!elevate.exe ' . v:progname '-S C:/Users/Link/vimfiles/elevate.vim --cmd "let $HOME=''C:\Users\Link\''"'<Return>:q<Return>
endif

" Detects if vim is opened without a file, moves to my documents for easy saving.
" add a || win64 when you can test it
if argc() == 0 && has('vim_starting') && has('win32')
  cd $OneDrive\Documents
endif

" Stop vim from writing stuff to viminfo if an encrypted file is being edited.
augroup Security
	autocmd vimleavepre * if strlen(&key) | set viminfo= | endif
augroup End

" Copy sprunge urls to the external clipboard
let sprunge_clipboard = 'external'
" Highlight strings inside C comments
let c_comment_strings=1

" NeoComplete Stuff
" Enable NeoComplete
let g:neocomplete#enable_at_startup = 1
" Enable SmartCase in neocomplete
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }
" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()
" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

" Theme stuff
colorscheme torte
highlight Comment ctermfg=8 guifg=#808080
hi StatusLine   guibg=#c2bfa5 guifg=black  gui=none cterm=bold,reverse
hi StatusLineNC guibg=#c2bfa5 guifg=grey40 gui=none cterm=reverse

" Vimshell stuff
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
"let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
if has('win32') || has('win64')
	" Display user name on Windows.
	let g:vimshell_prompt = $USERNAME."% "
else
	" Display user name on Linux.
	let g:vimshell_prompt = $USER."% "
endif
" Initialize execute file list.
let g:vimshell_execute_file_list = {}
"call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
let g:vimshell_execute_file_list['rb'] = 'ruby'
let g:vimshell_execute_file_list['pl'] = 'perl'
let g:vimshell_execute_file_list['py'] = 'python'
"call vimshell#set_execute_file('html,xhtml', 'gexe firefox')
autocmd FileType vimshell
\ call vimshell#altercmd#define('g', 'git')
\| call vimshell#altercmd#define('i', 'iexe')
\| call vimshell#altercmd#define('l', 'll')
\| call vimshell#altercmd#define('ll', 'ls -l')
\| call vimshell#hook#add('chpwd', 'my_chpwd', 'MyChpwd')
function! MyChpwd(args, context)
	call vimshell#execute('ls')
endfunction
autocmd FileType int-* call s:interactive_settings()
function! s:interactive_settings()
endfunction

" ----------------------------------------------        
" Vundle stuff
set nocompatible
filetype off
if has('win32') || has('win64')
        if !isdirectory(expand("C:/Users/Link/vimfiles/bundle/Vundle.vim")) && executable('git')
                !git clone https://github.com/gmarik/Vundle.vim.git C:/Users/Link/vimfiles/bundle/Vundle.vim
                so C:/Users/Link/.vimrc
        elseif !executable('git')
		echo "You need git and curl for the vundle plugin, ignore if you don't care"
		filetype plugin indent on
		finish
	elseif !executable('curl')
		echo "You need git and curl for the vundle plugin, ignore if you don't care"
		filetype plugin indent on
		finish
	endif
	set rtp+=~/vimfiles/bundle/Vundle.vim/
	let path='~/vimfiles/bundle'
	call vundle#begin(path)
else
	if !isdirectory(expand("~/.vim/bundle/Vundle.vim")) && executable('git')
		!git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
		so ~/.vimrc
	elseif or(!executable('git'), !executable('curl'))
		echo "You need git and curl for the vundle plugin, ignore if you don't care"
		filetype plugin indent on
		finish
	endif
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()
endif

" let Vundle manage Vundle
" required! 
Plugin 'gmarik/vundle'
" original repos on GitHub
Plugin 'chilicuil/vim-sprunge'
Plugin 'paradigm/SkyBison'
Plugin 'AnsiEsc.vim'
Plugin 'Shougo/neocomplete.vim'
Plugin 'Shougo/vimshell.vim'
Plugin 'Shougo/vimfiler.vim'
Plugin 'Shougo/neomru.vim'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'bling/vim-airline'
Plugin 'PProvost/vim-ps1'
call vundle#end()
filetype plugin indent on     " required!
" NOTE: comments after Plugin commands are not allowed.

