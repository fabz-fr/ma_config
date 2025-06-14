" --------------------------------------------------------------------------------------------
" OPTIONS CONFIGURATION
" --------------------------------------------------------------------------------------------

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
set syntax=on

" Highlight matching pairs of brackets. Use the '%' character to jump between them.
set matchpairs+=<:>

" Add numbers to each line on the left-hand side.
set number

" Do not save backup files.
"set nobackup

" Set to true if you have a Nerd Font installed and selected in the terminal
let g:have_nerd_font = v:false

" Make line numbers default
set number
" Set relative number
" set relativenumber

" Enable mouse mode
set mouse=a

" Don't show the mode, since it's already in the status line
set noshowmode

" Enable break indent
set breakindent

" Save undo history
set undofile

" Stop using swap file
set noswapfile

" Case-insensitive searching UNLESS \C or one or more capital letters in the search term
set ignorecase
set smartcase

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Set Highlight
set hlsearch

" Show matching words during a search.
set showmatch

" Keep signcolumn on by default
set signcolumn=yes

" Decrease update time
set updatetime=250

" Decrease mapped sequence wait time
set timeoutlen=300

" Configure how new splits should be opened
set splitright
set splitbelow

" Configure how Neovim will display certain whitespace characters
set list
set listchars=tab:--,trail:·,space:·,eol:↴

" command is not compatible with vim
if exists('g:neovim')
    " Preview substitutions live, as you type
    set inccommand=split
endif

" Show which line your cursor is on
set cursorline

" Minimal number of screen lines to keep above and below the cursor
set scrolloff=5

" Gestion des tabulations
set shiftwidth=4
set expandtab
set tabstop=4

" Show the line and column where the cursor is
set cursorline
set cursorcolumn

" Set a colon border at 100 characters
set colorcolumn=100

" Don't wrap lines, Allow long lines to extend as far as the line goes. But allow breaking at word boundaries
set nowrap
set linebreak

" Automatically reload file when externally updated
set autoread

" Set formatoptions for auto-formatting
set formatoptions=jcql

" Set textwidth to 100
set textwidth=100

" Show partial command you type in the last line of the screen.
set showcmd

" Set the commands to save in history default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=longest:full,full

" Permet de faire des folds par défaut à partir d'un certain niveau. On met à 99 pour ne pas activer cette fonctionnalité.
set foldlevel=99

" Même paramètre pour le niveau de départ des folds.
set foldlevelstart=99

" Active les folds par défaut.
set foldenable

" Ajoute une colonne pour indiquer qu'il y a un fold.
set foldcolumn=1

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=**/.git/**,**/build/**,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx,**/documentation/**

function! SetWildignore() abort
    let l:cmd = 'git check-ignore *'
    let l:files = systemlist(l:cmd)

    if v:shell_error == 0
        let l:ignored = join(l:files, ',')
        execute 'setlocal wildignore+=' . l:ignored
    endif
endfunction

augroup gitignore
    autocmd!
    autocmd! BufReadPost * call SetWildignore()
augroup END


" Automatically save before commands like :next or :make
set autowrite

" --------------------------------------------------------------------------------------------
" STATUS LINE 
" --------------------------------------------------------------------------------------------
" Clear status line when vimrc is reloaded.
set statusline=
" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R
" Use a divider to separate the left side from the right side.
set statusline+=%=
" Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%
" Show the status on the second to last line.
set laststatus=2


" --------------------------------------------------------------------------------------------
" KEYBINDINGS / SHORTCUTS CONFIGURATION
" --------------------------------------------------------------------------------------------

" Delete <space> and s map
nnoremap <space> <NOP>
vnoremap <space> <NOP>
nnoremap s <NOP>
vnoremap s <NOP>
vnoremap <CR> <NOP>
nnoremap <CR> <NOP>

" Set <space> as the leader key
let mapleader = ' '
let maplocalleader = ' '

" Map key for shifting text right in visual mode
vnoremap > >gv
" Map key for shifting text left in visual mode
vnoremap < <gv

" Copy to clipboard using xclip (requires xclip installation)
vnoremap <C-c> "+y

" Select all buffer content in normal mode
nnoremap <C-a> ggVG

" Delete next word in insert mode
inoremap <C-x> <esc>lce

" Delete previous word in insert mode
inoremap <C-BS> <esc>cvb

" Start search and replace for selected word
vnoremap <Leader>f "1y:%s/<C-R>1//gc<Left><Left><Left>

" Search for selected word
vnoremap // y/\V<C-R>=escape(@",'/')<CR><CR>

" Fold every line that doesn't contain the word under cursor
nnoremap <Leader>zw *#:setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>

" Fold every line that doesn't contain the WORD under cursor
nnoremap <Leader>zW viW*#:setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>

" Delete current buffer and switch to the next one
nnoremap <leader>db :bn<cr>:bd #<cr>

" Navigation shortcuts
nnoremap ]] ]]zt
nnoremap [[ [[zt
nnoremap ]m ]mzt
nnoremap [m [mzt
nnoremap } }zt
nnoremap { {zt
nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>

" Delete all buffers
command! Bda %bd

" Quit terminal mode
"tnoremap <ESC> <C-\><C-n>
" https://github.com/junegunn/fzf.vim/issues/544#issuecomment-457456166
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"


" Check if the primary init.lua file was loaded
if exists('g:init_lua_loaded')
    echo "plugins configuration"
else
    " --------------------------------------------------------------------------------------------
    " FZF Fuzzy Finder configuration
    " --------------------------------------------------------------------------------------------
    "set runtimepath+=~/.fzf
    source ~/.fzf/plugin/fzf.vim

    command! -nargs=* Rg call fzf#run({
                \ 'source': 'rg --column --line-number --no-heading --smart-case -- ' . shellescape(<q-args>),
                \ 'sink': { res -> execute('cexpr ' . string(res)) },
                \ 'down': '40%',
                \ 'options': '--multi --delimiter ":" --preview "cat {1}"'
                \ })
    "
    " Map search file with fuzzy finder
    nmap <leader>sf :FZF<cr>
    nmap <leader>sg :Rg<cr>
    echo "no plugin configuration"
endif

" Automatically refresh file when externally modified 
set autoread
augroup AutoReload
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold * checktime
augroup END

" --------------------------------------------------------------------------------------------
" Display buffer as hexadecimal
" --------------------------------------------------------------------------------------------
command! DisplayHex call DisplayHexFunction()
function! DisplayHexFunction()
  " Sauvegarde la position du curseur et du fichier courant
  let l:current_buf = bufnr('%')

  " Récupère tout le contenu du buffer courant
  let l:content = getline(1, '$')

  " Ouvre un nouveau buffer sans nom
  enew
  ""buftype=nofile : indique que ce buffer ne correspond pas à un fichier.
  ""bufhidden=hide : évite les avertissements quand on quitte sans sauvegarder.
  ""noswapfile : évite la création de fichiers de swap pour ce buffer.
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  " Met le contenu dans le nouveau buffer
  call setline(1, l:content)
  " Applique la commande xxd
  %!xxd
endfunction

"" --------------------------------------------------------------------------------------------
"" Execute the line where cursor is
"" --------------------------------------------------------------------------------------------
function! BangLines() range
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]

    for i in lines
        execute "!".i
    endfor
endfunction
nnoremap <leader>e V"ey:!<C-R>e<CR>
vnoremap <leader>e :<C-u>call BangLines()<CR>
"vnoremap <leader>e :'<,'>w !sh<CR> is a shorter version but uses ex command

