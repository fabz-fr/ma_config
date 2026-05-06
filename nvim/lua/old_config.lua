-- --------------------------------------------------------------------------------------------
-- OPTIONS CONFIGURATION
-- --------------------------------------------------------------------------------------------

-- Set <space> as the leader key
vim.g.mapleader       = ' '
vim.g.maplocalleader  = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font  = false

-- Make line numbers default
vim.opt.number        = true
-- Set relative number
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse         = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode      = false

-- Enable break indent
vim.opt.breakindent   = true

-- Save undo history
vim.opt.undofile      = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase    = true
vim.opt.smartcase     = true

-- Keep signcolumn on by default
vim.opt.signcolumn    = 'yes'

-- Decrease update time
vim.opt.updatetime    = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen    = 300

-- Configure how new splits should be opened
vim.opt.splitright    = true
vim.opt.splitbelow    = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list          = true
-- Configure the characters used for end of line, tab and space
vim.opt.listchars     = {
    tab   = '--',
    trail = '·',
    space = '·',
    eol   = '↴'
}

-- Preview substitutions live, as you type!
vim.opt.inccommand    = 'split'

-- Show which line your cursor is on
vim.opt.cursorline    = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff     = 10

-- Gestion des tabulations
vim.o.shiftwidth      = 4     -- La taille définit pour l'appui sur la touche tab est de 4 caractères
vim.o.expandtab       = true  -- Utilisation d'espace au lieu des tabulations
vim.o.tabstop         = 4     -- La taille d'une tabulation est de 4 caractères

vim.o.cursorline      = true  -- Show the line where the cursor is
vim.o.cursorcolumn    = true  -- show the column where the cursor is

vim.o.cc              = "100" -- set a colon border at 100 characters
vim.o.hlsearch        = true  -- Set Highlight

--vim.opt.nowrap          = true  -- Faire en sorte que les lignes dépassent de l'écran plutôt qu'elles reviennent au début de la ligne suivante
vim.wo.wrap           = false
vim.wo.linebreak      = true

-- Automatically reload file when externally updated
vim.o.autoread        = true

-- Remove r : We don't want to set comment at every CR
-- Remove o : We don't want to set comment at every o or O
-- Add a : To auto format comment paragraph. If error check "h auto-format"
-- Delete a : It is very intrusive, and join lines to easily !
-- Remove l : to Automatically format long lines
vim.opt.formatoptions = "jcql" -- Before the value was jcroql

-- Set textwidth to 100
vim.opt.textwidth     = 100

-- Define the toggle table
local toggles         = {
    ["true"] = "false",
    ["false"] = "true",
    ["True"] = "False",
    ["False"] = "True",
    ["TRUE"] = "FALSE",
    ["FALSE"] = "TRUE",
    ["yes"] = "no",
    ["no"] = "yes",
    ["Yes"] = "No",
    ["No"] = "Yes",
    ["YES"] = "NO",
    ["NO"] = "YES",
    ["on"] = "off",
    ["off"] = "on",
    ["On"] = "Off",
    ["Off"] = "On",
    ["ON"] = "OFF",
    ["OFF"] = "ON",
    ["open"] = "close",
    ["close"] = "open",
    ["Open"] = "Close",
    ["Close"] = "Open",
    ["dark"] = "light",
    ["light"] = "dark",
    ["width"] = "height",
    ["height"] = "width",
    ["first"] = "last",
    ["last"] = "first",
    ["top"] = "right",
    ["right"] = "bottom",
    ["bottom"] = "left",
    ["left"] = "center",
    ["center"] = "top",
}


-- Function to toggle the current word
local function toggle_word()
    -- Get the word under the cursor
    local word = vim.fn.expand("<cword>")

    -- Check if the word exists in the toggles table
    if toggles[word] then
        -- Replace the word using normal mode command
        vim.api.nvim_command('normal! "_ciw' .. toggles[word])
    end
end

-- Register the function in the global scope for mapping
_G.toggle_word = toggle_word

-- Map the function to a key
vim.api.nvim_set_keymap('n', '<leader>t', '<cmd>lua toggle_word()<CR>', { noremap = true, silent = true })

-- Create a command to call the function
vim.api.nvim_create_user_command('ToggleWord', toggle_word, {})

-- --------------------------------------------------------------------------------------------
-- KEYBINDINGS / SHORTCUTS CONFIGURATION
-- --------------------------------------------------------------------------------------------
local keymap = vim.api.nvim_set_keymap
local opts   = { noremap = true }

keymap('v', '>', '>gv', opts) -- combinaison pour décaler un bloc de texte
keymap('v', '<', '<gv', opts) -- combinaison pour décaler un bloc de texte

-- Pour utiliser cette commande, il est nécessaire d'installer xclip (sudo apt install xclip)
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, desc = "[C]opy to clipboard" })    -- Ajout du CTRL+C pour copier un fichier dans le buffer

vim.keymap.set('n', '<C-a>', 'ggVG', { noremap = true, desc = "Select all buffer" })     -- Ajout du control A pour selectionner l'ensemble du fichier

vim.keymap.set('i', '<C-x>', '<esc>lce', { noremap = true, desc = "Delete new word" })   -- En mode insertion, supprime le mot suivant
vim.keymap.set('i', '<C-BS>', '<esc>cvb', { noremap = true, desc = "Delete last word" }) -- En mode insertion, supprime le mot precedent

vim.keymap.set('v', '<Leader>f', '"1y:%s/<C-R>1//gc<Left><Left><Left>',
    { noremap = true, desc = "Start search and replace for selected word" })                                        -- Prend le mot sélectionné et vient automatiquement lancer une rechercher/remplacer en le positionnant au bon endroit
vim.keymap.set('v', '//', 'y/\\V<C-R>=escape(@",\'/\')<CR><CR>', { noremap = true, desc = "Search selected word" }) -- Fait une recherche du pattern sélectionné

vim.keymap.set('n', '<Leader>wz',
    '*#:setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>',
    { noremap = true, desc = "Fold every lines that don't contain word" }) -- Fait une recherche du mot ou se trouve le curseur puis recherche directement le mot et fait un fold de tout ce qui n'est pas le mot
vim.keymap.set('n', '<Leader>Wz',
    'viW*#:setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>',
    { noremap = true, desc = "Fold every lines that don't contain WORD" }) -- Même chose mais en prenant un mot plus large.

vim.keymap.set('n', '<leader>db', ':bn<cr>:bd #<cr>', { desc = '[D]elete [B]uffer' })

vim.keymap.set('n', ']]', ']]zt', { desc = 'Jump to next function, then set cursor to top' })
vim.keymap.set('n', '[[', '[[zt', { desc = 'Jump to previous function, then set cursor to top' })

vim.keymap.set('n', ']m', ']mzt', { desc = 'Jump to next method, then set cursor to top' })
vim.keymap.set('n', '[m', '[mzt', { desc = 'Jump to previous method, then set cursor to top' })

vim.keymap.set('n', '}', '}zt', { desc = 'Jump to next blank line, then set cursor to top' })
vim.keymap.set('n', '{', '{zt', { desc = 'Jump to previous blank line, then set cursor to top' })

vim.keymap.set('n', ']q', '<cmd>:cnext<CR>', { desc = 'Jump to next element in quickfix list' })
vim.keymap.set('n', '[q', '<cmd>:cprevious<CR>', { desc = 'Jump to previous element in quickfix list' })

-- Delete all buffer
vim.api.nvim_create_user_command('Bda', function() vim.cmd('%bd') end, {})

vim.keymap.set('t', '<ESC>', '<C-\\><C-n>', { desc = 'Quit terminal mode' })
