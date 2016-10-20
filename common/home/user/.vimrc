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
set cryptmethod=blowfish2
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
" Windows fix for context menu + msys2
set directory+=./,~/tmp//,/var/tmp//,/tmp//
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
	"set guifontwide=DFKai-SB:h12
endif

" Syntax highlighting. If you turn it on more than once it screws up colors, hence the if statement
if !exists("syntax_on")
	syntax on
endif

" Call SkyBison with \;
nnoremap <leader>; :<c-u>call SkyBison("")<cr>
let g:skybison_fuzz = 2
" Exit insert mode with jj
inoremap jj <Esc>
" Hide vim pr0n
"noremap <F3> mzggVGg?`z
"if has('win32') || has('win64')
	" Build C++ amd64 binary with Visual Studio 2013
"	noremap <F7> :VimShellBufferDir -popup<CR><ESC>:wincmd p<CR>:call vimshell#interactive#send("C:/PROGRA~2/MICROS~1.0/VC/bin/amd64/vcvars64.bat & cl /EHsc <C-r>=expand("%:t")<CR>")<CR>
	" Build C binary with MinGW GCC
"	noremap <F8> :VimShellBufferDir -popup<CR><ESC>:wincmd p<CR>:call vimshell#interactive#send("C:/MinGW/bin/cc.exe <C-r>=expand("%:t")<CR>")<CR>
"endif

" Unite search recent files and directories
nnoremap <C-p> :Unite -start-insert file_mru directory_mru<cr>
" Unite quick select buffers
nnoremap <leader>b :Unite -quick-match buffer<cr>
" Unite yank history
let g:unite_source_history_yank_enable = 1
nnoremap <leader>y :Unite history/yank<cr>

" Fix temp folder under Windows
" breaks vundle
"if has('win32') || has('win64')
"	let $TMP="$TEMP"
"endif

"Elevate vim under windows.
" Update me to use powershell elevation
"if has('win32') || has('win64')
"	noremap <C-e> :mksession! ~/vimfiles/elevate.vim<Return>:silent exec '!elevate.exe ' . v:progname '-S C:/Users/Link/vimfiles/elevate.vim --cmd "let $HOME=''C:\Users\Link\''"'<Return>:q<Return>
"endif

" Detects if vim is opened without a file, moves to my documents for easy saving.
" add a || win64 when you can test it
"if argc() == 0 && has('vim_starting') && has('win32')
"  cd $OneDrive\Documents
"endif

" Stop vim from writing stuff to viminfo if an encrypted file is being edited.
augroup Security
	autocmd vimleavepre * if strlen(&key) | set viminfo= | endif
augroup End

" Copy sprunge urls to the external clipboard
"let g:sprunge_clipboard = 'external'
let g:sprunge_clipboard_cmd='xsel -i'
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

" Ranger file chooser
" Compatible with ranger 1.4.2 through 1.7.*
"
" Add ranger as a file chooser in vim
"
" If you add this code to the .vimrc, ranger can be started using the command
" ":RangerChooser" or the keybinding "<leader>r".  Once you select one or more
" files, press enter and ranger will quit again and vim will open the selected
" files.

function! RangeChooser()
    let temp = tempname()
    " The option "--choosefiles" was added in ranger 1.5.1. Use the next line
    " with ranger 1.4.2 through 1.5.0 instead.
    "exec 'silent !ranger --choosefile=' . shellescape(temp)
    if has("gui_running")
        exec 'silent !xterm -e ranger --choosefiles=' . shellescape(temp)
    else
        exec 'silent !ranger --choosefiles=' . shellescape(temp)
    endif
    if !filereadable(temp)
        redraw!
        " Nothing to read.
        return
    endif
    let names = readfile(temp)
    if empty(names)
        redraw!
        " Nothing to open.
        return
    endif
    " Edit the first item.
    exec 'edit ' . fnameescape(names[0])
    " Add any remaning items to the arg list/buffer list.
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction
command! -bar RangerChooser call RangeChooser()
nnoremap <leader>r :<C-U>RangerChooser<CR>

" ----------------------------------------------        
" Vundle stuff
set nocompatible
filetype off
if !isdirectory(expand("~/.vim/bundle/Vundle.vim")) && executable('git')
		let vundlefolder = expand("~/.vim/bundle/Vundle.vim")
		silent execute '!mkdir ' . vundlefolder
		silent execute '!git clone https://github.com/gmarik/Vundle.vim.git ' . vundlefolder
		so ~/.vimrc
elseif or(!executable('git'), !executable('curl'))
		echo "git and/or curl not found [Vundle]"
		filetype plugin indent on
		finish
endif
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()

" let Vundle manage Vundle. Required! 
Plugin 'gmarik/Vundle.vim'
" repos on GitHub
Plugin 'chilicuil/vim-sprunge'
Plugin 'paradigm/SkyBison'
"Plugin 'AnsiEsc.vim'
Plugin 'spolu/dwm.vim'
Plugin 'Shougo/neocomplete.vim'
Plugin 'Shougo/neomru.vim'
Plugin 'Shougo/unite.vim'
Plugin 'bling/vim-airline'
Plugin 'PProvost/vim-ps1'
" Plugin 'chrisbra/csv.vim'

call vundle#end()
filetype plugin indent on     " required!
" NOTE: comments after Plugin commands are not allowed.

