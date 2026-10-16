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

" Do not save backup files.
"set nobackup

" Set to true if you have a Nerd Font installed and selected in the terminal
let g:have_nerd_font = v:false

" Add numbers to each line on the left-hand side.
set number
" Set relative number
" set relativenumber

" Enable mouse mode
set mouse=a

" Don't show the mode, since it's already in the status line
set noshowmode

" Enable break indent (When cursor goes to nextline it keeps the same indentation)
set breakindent

" Save undo history in path `undodir`
set undofile

" Stop using swap file (swap file are temporary file that can be retrieved if vim crashes)
set noswapfile

" Case-insensitive searching UNLESS \C or one or more capital letters in the search term
set ignorecase
set smartcase

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Set Highlight search
set hlsearch

" Show matching words during a search.
set showmatch

" Set signcolumn on the left of the buffer. This column add informations like git, folds, diagnostics etc.
set signcolumn=yes

" Decrease update time (time between user push a key and the trigger of CursorHold autocommand event)
set updatetime=250

" Decrease mapped sequence wait time. timeoutlen is the timeout that trigger the user keymaps. If
" user didn't add a key to the keymap sequence, the current keymap sequence will be triggered
set timeoutlen=400

" Configure how new splits should be opened
set splitright
set splitbelow

" Configure how Neovim will display whitespace characters
set list
set listchars=tab:--,trail:·,space:·,eol:↴

" command is not compatible with vim
if exists('+inccommand')
    " Preview substitutions live, as you type
    set inccommand=split
endif

" Minimal number of screen lines to keep above and below the cursor
set scrolloff=5

" Set tabulation as 4 spaces
set shiftwidth=4
set expandtab
set tabstop=4

" Show the line and column where the cursor is
set cursorline
set cursorcolumn

" Set a colon border at 100 characters
set colorcolumn=100

" Wrap lines by default 
set wrap " nowrap
" When break occurs, if possible, the word is kept full at next line
set linebreak
" Set textwidth to 100
set textwidth=100

" Don't jump over wrapped lines parts
nnoremap j gj
nnoremap k gk

" Automatically reload file when externally updated
set autoread

" configure formatoptions (how vim formats text) (more info with `:h fo-table`)
" j : If vim know what to do, when joining comments lines, vim removes the comments pattern `//`
" c : auto-wrap comments when texwidth is reached
" q : allows formatting of comment with "gq" (TBD)
" l : when switching to insert mode in a long line (over textwidth), don't wrap line
set formatoptions=jcql

" Show partial command you type in the last line of the screen.
set showcmd

" Set the commands to save in history default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=longest:full,full

" configure folds level (tabulation level) to a high value to prevent vim from folding whole files at startup
set foldlevel=99

" configure folds level (tabulation level) to a high value to prevent vim from folding whole files at startup
set foldlevelstart=99

" Enable fold feature
set foldenable

" Ajoute une colonne pour indiquer qu'il y a un fold.
" Add a column a left side of vim, to show folds
set foldcolumn=0

" Automatically save before commands like :next or :make
set autowrite

" --------------------------------------------------------------------------------------------
" WILD IGNORE
" --------------------------------------------------------------------------------------------
" There are certain files that we would never want to edit with Vim. Wildmenu will ignore files with these extensions.
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

" Disable some standard keymaps that are not that are re-used by me
nnoremap <space> <NOP>
vnoremap <space> <NOP>
nnoremap s <NOP>
vnoremap s <NOP>
vnoremap <CR> <NOP>
nnoremap <CR> <NOP>
vnoremap <S-CR> <NOP>
nnoremap <S-CR> <NOP>

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
    vnoremap y "+y
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
command! Fdisplayhex call Fdisplayhexfunction()
function! Fdisplayhexfunction()
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
"command! -range Banglines <line1>,<line2>call Fbanglines()
function! Fbanglines() range
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
vnoremap <leader>e :<C-u>call Fbanglines()<CR>
"vnoremap <leader>e :'<,'>w !sh<CR> is a shorter version but uses ex command

"" --------------------------------------------------------------------------------------------
"" Add a jump function if config is no plugins
"" --------------------------------------------------------------------------------------------
if ! exists('g:init_lua_loaded')
    "highlight WordLabelHighlight guifg=#fffff0 guibg=#ffff00
    highlight WordLabelHighlight guifg=#ffffff guibg=#623417

    function! LabelWordsWithLetters()
        let ns_id = nvim_create_namespace('word_labels_alpha')
        let bufnr = bufnr('%')
        call nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

        let first = line('w0')
        let last  = line('w$')
        let lines = nvim_buf_get_lines(bufnr, first-1, last, v:false)

        let idx = 0
        for i in range(len(lines))
            let l = lines[i]
            let start = 0
            while 1
                let m = matchstrpos(l, '\w\+', start)
                if m[1] == -1 | break | endif
                if idx >= 26*26 | return | endif

                let lbl = nr2char(char2nr('a')+idx/26) . nr2char(char2nr('a')+idx%26)
                call nvim_buf_set_extmark(bufnr, ns_id, first+i-1, m[1], {
                            \ 'virt_text': [[lbl, 'WordLabelHighlight']],
                            \ 'virt_text_pos': 'overlay'
                            \ })
                let idx += 1
                let start = m[2]
            endwhile
        endfor
    endfunction

    function! ClearWordLabels()
        let ns_id = nvim_create_namespace('word_labels_alpha')
        call nvim_buf_clear_namespace(bufnr('%'), ns_id, 0, -1)
        echo "Labels deleted"
    endfunction

    function! GoToLabel()
        call LabelWordsWithLetters()
        redraw
        let lbl = input('Go to label :')
        if lbl ==# ''
            call ClearWordLabels()
            return
        endif

        let ns = nvim_create_namespace('word_labels_alpha')
        let marks = nvim_buf_get_extmarks(bufnr('%'), ns, 0, -1, {'details': v:true})

        for m in marks
            if has_key(m[3], 'virt_text') && m[3].virt_text[0][0] ==# lbl
                call nvim_win_set_cursor(0, [m[1]+1, m[2]])
                break
            endif
        endfor

        call ClearWordLabels()
    endfunction

    command! LabelWordsWithLetters call LabelWordsWithLetters()
    command! ClearWordLabels call ClearWordLabels()
    command! GoToLabel call GoToLabel()

    nmap <CR> :GoToLabel<CR>
    vmap <CR> :GoToLabel<CR>

endif

"" --------------------------------------------------------------------------------------------
"" If we are in a git repository, update findfunc() otherwise, set path to **
"" --------------------------------------------------------------------------------------------
if !isdirectory('.git')
    set path=**
else
    " Use the 'git ls-files' output
    func FindGitFiles(cmdarg, cmdcomplete)
    let main_files = systemlist('git ls-files -oc --deduplicate --exclude-standard')
    let sub_files = systemlist('git submodule foreach --quiet "git ls-files -oc --deduplicate --exclude-standard"')
    let all_files = uniq(sort(main_files + sub_files))
    return all_files->filter('v:val =~? a:cmdarg')
    endfunc
    set findfunc=FindGitFiles

    " Add a rg for :grep command
    set grepprg=rg\ --vimgrep
    set grepformat^=%f:%l:%c:%m

endif

"" using <c-v> transform :find to :vs
cmap <c-S> <home><s-right><c-w>vs<end>
cmap <c-s> <home><s-right><c-w>sp<end>
cmap <c-t> <home><s-right><c-w>tabe<end>

" bugfix, <CR> mapping above, remove <CR> in quickfix list. It must be forced 
augroup QuickFixMappings
  autocmd!
  autocmd FileType qf nnoremap <buffer> <CR> <CR>
augroup END


" find function in no plugin mode
function! FdFiles(path)
    let output = systemlist('fdfind --type f ' . shellescape(a:path))

    let items = []
    for file in output
        call add(items, {'filename': file})
    endfor

    call setqflist([], ' ', {
        \ 'title': 'fd',
        \ 'items': items
        \ })

    copen
endfunction

" find occurence of pattern in no plugin mode
function! RgSearch(pattern, ...)
    let path = a:0 > 0 ? a:1 : '.'

    let output = systemlist(
        \ 'rg --vimgrep ' . shellescape(a:pattern) . ' ' . shellescape(path)
        \ )

    let items = []
    for line in output
        let parts = split(line, ':', 4)

        if len(parts) >= 4
            call add(items, {
                \ 'filename': parts[0],
                \ 'lnum': str2nr(parts[1]),
                \ 'col': str2nr(parts[2]),
                \ 'text': parts[3]
                \ })
        endif
    endfor

    call setqflist([], ' ', {
        \ 'title': 'rg: ' . a:pattern,
        \ 'items': items
        \ })

    copen
endfunction

" ~/.vimrc ou ~/.config/nvim/init.vim
" Flash-like word jump avec étiquettes à 2 lettres, compatible Vim et Neovim

function! s:FlashLabels(n) abort
  let alphabet = split('asdfghjklqwertyuiopzxcvbnm', '\zs')
  let labels = []
  for c1 in alphabet
    for c2 in alphabet
      call add(labels, c1 . c2)
      if len(labels) >= a:n
        return labels
      endif
    endfor
  endfor
  return labels
endfunction

function! s:FlashClearOverlays(use_nvim, ns, overlay_ids) abort
  if a:use_nvim
    call nvim_buf_clear_namespace(0, a:ns, 0, -1)
  elseif has('popupwin')
    for id in a:overlay_ids
      silent! call popup_close(id)
    endfor
  else
    for id in a:overlay_ids
      silent! call matchdelete(id)
    endfor
  endif
endfunction

function! s:FlashDrawOverlays(entries, use_nvim, ns) abort
  let overlay_ids = []
  for [lbl, lnum, col] in a:entries
    if a:use_nvim
      let id = nvim_buf_set_extmark(0, a:ns, lnum - 1, col - 1,
            \ {'virt_text': [[lbl, 'IncSearch']], 'virt_text_pos': 'overlay'})
      call add(overlay_ids, id)
    elseif has('popupwin')
      let scr = screenpos(0, lnum, col)
      if scr.row > 0
        let id = popup_create(lbl, {
              \ 'line': scr.row, 'col': scr.col,
              \ 'highlight': 'IncSearch', 'zindex': 300, 'wrap': 0,
              \ })
        call add(overlay_ids, id)
      endif
    else
      let id = matchaddpos('IncSearch', [[lnum, col, 1]], 20)
      call add(overlay_ids, id)
    endif
  endfor
  return overlay_ids
endfunction

function! s:FlashWordJump() abort
  let top = line('w0')
  let bot = line('w$')
  let save_cursor = getpos('.')

  " Recherche du début de chaque mot visible à l'écran
  let matches = []
  call cursor(top, 1)
  while 1
    let pos = searchpos('\<\k\+', 'W', bot)
    if pos == [0, 0]
      break
    endif
    call add(matches, pos)
  endwhile
  call setpos('.', save_cursor)

  if empty(matches)
    echo 'Flash: aucun mot trouvé'
    return
  endif

  let labels = s:FlashLabels(len(matches))
  let matches = matches[0 : len(labels) - 1]

  " entries : liste de [label, lnum, col]
  let entries = []
  for i in range(len(matches))
    call add(entries, [labels[i], matches[i][0], matches[i][1]])
  endfor

  let use_nvim = has('nvim')
  let ns = use_nvim ? nvim_create_namespace('flash_word_jump') : 0

  let overlay_ids = s:FlashDrawOverlays(entries, use_nvim, ns)
  redraw
  echohl Question | echo 'Flash> ' | echohl None

  " --- Premier caractère ---
  let c1 = getchar()
  call s:FlashClearOverlays(use_nvim, ns, overlay_ids)
  redraw

  if c1 == 27
    return
  endif
  let c1 = nr2char(c1)

  let filtered = filter(copy(entries), 'v:val[0][0] ==# c1')

  if empty(filtered)
    echo 'Flash: aucune correspondance'
    return
  endif

  " Une seule cible restante avec ce premier caractère : saut direct
  if len(filtered) == 1
    call cursor(filtered[0][1], filtered[0][2])
    return
  endif

  " --- Second caractère : on n'affiche plus que la 2e lettre des labels restants ---
  let entries2 = []
  for [lbl, lnum, col] in filtered
    call add(entries2, [lbl[1], lnum, col])
  endfor

  let overlay_ids = s:FlashDrawOverlays(entries2, use_nvim, ns)
  redraw
  echohl Question | echo 'Flash> ' . c1 | echohl None

  let c2 = getchar()
  call s:FlashClearOverlays(use_nvim, ns, overlay_ids)
  redraw

  if c2 == 27
    return
  endif
  let c2 = nr2char(c2)

  for [lbl, lnum, col] in filtered
    if lbl[1] ==# c2
      call cursor(lnum, col)
      return
    endif
  endfor

  echo 'Flash: aucune correspondance'
endfunction

nnoremap <silent> <CR> :call <SID>FlashWordJump()<CR>
xnoremap <silent> <CR> :<C-u>call <SID>FlashWordJump()<CR>


" format xml code 
function! FormatXml()
    %!xmllint --format -
endfunction
command! FormatXml call FormatXml()

