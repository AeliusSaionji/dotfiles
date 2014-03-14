" Link's stuff
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
" Jump to matches as you search
set incsearch
" ignore case for vim commands, unless you throw a capital in
set ignorecase
set smartcase
" Turn wrapping on
set wrap
" Wrap per word, not character
set lbr
" Number of characters from right window border where newline is inserted (wrap long lines for copying). 0 disables.
set wrapmargin=0
" Set some GUI specific options
if has("gui_running")
	" Hide mouse while typing. GVIM only
	set mousehide
	" Toggle menubar with \mb
	nnore <expr><leader>mb &go =~# 'm' ? ":\<C-U>set go-=m\<CR>" : ":\<C-U>set go+=m\<CR>"
	" tearoff menubar menus
	set guioptions=t
endif

" Set pate mode for pasting things over ssh I guess
if !has('win32')
	set paste
endif

" Syntax highlighting. If you turn it on more than once it screws up colors, hence the if statement
if !exists("syntax_on")
	syntax on
endif

" Redraw screen + search highlighting off until search
nnoremap <C-L> :nohl<CR><C-L>
" Hide vim pr0n
noremap <F3> mzggVGg?`z

"Elevate vim under windows.
if has('win32')
	noremap <C-e> :mksession! ~/vimfiles/elevate.vim<Return>:silent exec '!\%SKYDRV\%\Miscut~1\elevate64.exe ' . v:progname '-S C:/Users/Link/vimfiles/elevate.vim --cmd "let $HOME=''C:\Users\Link\''"'<Return>:q<Return>
endif

" Detects if vim is opened without a file, moves to my documents for easy saving.
if argc() == 0 && has('vim_starting') && has('win32')
  cd $SKYDRV\Documents
endif

" Stop vim from writing stuff to viminfo if an encrypted file is being edited.
augroup Security
autocmd vimleavepre * if strlen(&key) | set viminfo= | endif
augroup End

" Copy sprunge urls to the external clipboard
let sprunge_clipboard = 'external'
" Highlight strings inside C comments
let c_comment_strings=1

" Theme stuff
colorscheme torte
highlight Comment ctermfg=8 guifg=#808080
hi StatusLine   guibg=#c2bfa5 guifg=black  gui=none cterm=bold,reverse
hi StatusLineNC guibg=#c2bfa5 guifg=grey40 gui=none cterm=reverse

" ----------------------------------------------        
" vundle stuff
filetype off
if has('win32')
        if !isdirectory(expand("~/vimfiles/bundle/vundle")) && executable('git')
                !git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
                so ~/_vimrc
        elseif !executable('git')
		echo "You need git and curl for the vundle plugin, ignore if you don't care"
		filetype plugin indent on
		finish
	elseif !executable('curl')
		echo "You need git and curl for the vundle plugin, ignore if you don't care"
		filetype plugin indent on
		finish
	endif
	set rtp+=~/vimfiles/bundle/vundle/
	call vundle#rc("~/vimfiles/bundle")
else
	if !isdirectory(expand("~/.vim/bundle/vundle")) && executable('git')
		!git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
		so ~/.vimrc
	elseif or(!executable('git'), !executable('curl'))
		echo "You need git and curl for the vundle plugin, ignore if you don't care"
		filetype plugin indent on
		finish
	endif
	set rtp+=~/.vim/bundle/vundle/
	call vundle#rc("~/.vim/bundle")
endif

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
" original repos on GitHub
Bundle 'yegappan/mru'
Bundle 'scrooloose/nerdtree'
Bundle 'chilicuil/vim-sprunge'
Bundle 'paradigm/SkyBison'
Bundle 'ivalkeen/nerdtree-execute'
Bundle 'kien/ctrlp.vim'
Bundle 'AnsiEsc.vim'
" Bundle 'irssilog.vim' this thing is mostly useless and broken by AnsiEsc
" vim-scripts repos
" Bundle 'sessionman.vim'
" Bundle 'FuzzyFinder'
" non-GitHub repos
" Bundle 'git://git.wincent.com/command-t.git'
" Git repos on your local machine (i.e. when working on your own plugin)
" Bundle 'file:///Users/gmarik/path/to/plugin'
filetype plugin indent on     " required!
" NOTE: comments after Bundle commands are not allowed.
" see :h vundle for more details or wiki for FAQ

