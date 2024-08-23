-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later


now(function()
  -- Use other plugins with `add()`. It ensures plugin is available in current
  -- session (installs if absent)
  add({
    source = 'neovim/nvim-lspconfig',
    -- Supply dependencies near target plugin
    depends = { 'williamboman/mason.nvim' },
  })
end)

later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  -- Possible to immediately execute code which depends on the added plugin
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc', 'rust', 'cpp', 'python' },
    highlight = { enable = true },
  })
end)

-- later(function() require('mason.nvim').setup() end)

later(function() require('mini.ai').setup() end)
-- later(function() require('mini.align').setup() end)
later(function() require('mini.animate').setup() end)
-- later(function() require('mini.base16').setup() end)
later(function() require('mini.basics').setup() end)
-- later(function() require('mini.bracketed').setup() end)
-- later(function() require('mini.bufremove').setup() end)
later(function() require('mini.clue').setup() end)
-- later(function() require('mini.colors').setup() end)
-- later(function() require('mini.comment').setup() end)
later(function() require('mini.completion').setup() end)
later(function() require('mini.cursorword').setup() end)
-- later(function() require('mini.deps').setup() end)
later(function() require('mini.diff').setup() end)
-- later(function() require('mini.doc').setup() end)
later(function() require('mini.extra').setup() end)
later(function() require('mini.files').setup() end)
later(function() require('mini.fuzzy').setup() end)
later(function() require('mini.git').setup() end)
later(function() require('mini.hipatterns').setup() end)
-- later(function() require('mini.hues').setup() end)
-- later(function() require('mini.icons').setup() end)
later(function() require('mini.indentscope').setup() end) -- Affiche une ligne pour voir la fin du scope 
-- later(function() require('mini.jump').setup() end)
-- later(function() require('mini.jump2d').setup() end)
later(function() require('mini.map').setup() end)
later(function() require('mini.misc').setup() end)
later(function() require('mini.move').setup() end)
later(function() require('mini.notify').setup() end)
later(function() require('mini.operators').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.pick').setup() end)
-- later(function() require('mini.sessions').setup() end)
later(function() require('mini.splitjoin').setup() end)
-- later(function() require('mini.starter').setup() end)
later(function() require('mini.statusline').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.tabline').setup() end)
-- later(function() require('mini.test').setup() end)
-- later(function() require('mini.trailspace').setup() end)
-- later(function() require('mini.visits').setup() end) -- Garde une liste des fichiers visités


-- --------------------------------------------------------------------------------------------
-- OPTIONS CONFIGURATION
-- --------------------------------------------------------------------------------------------

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- " Disable compatibility with vi which can cause unexpected issues.
-- set nocompatible

-- " Enable type file detection. Vim will be able to try to detect the type of file in use.
-- filetype on

-- " Enable plugins and load plugin for the detected file type.
-- filetype plugin on

-- " While searching though a file incrementally highlight matching characters as you type.
-- set incsearch

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- Make line numbers default
vim.opt.number = true
-- Set relative number
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
later(function() vim.opt.clipboard = 'unnamedplus' end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
-- Configure the characters used for end of line, tab and space
vim.opt.listchars     = {
    tab   = '--',
    trail = '·',
    space = '·',
    eol   = '↴'
}

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Gestion des tabulations
vim.o.shiftwidth      = 4 -- La taille définit pour l'appui sur la touche tab est de 4 caractères
vim.o.expandtab       = 1 -- Utilisation d'espace au lieu des tabulations
vim.o.tabstop         = 4 -- La taille d'une tabulation est de 4 caractères

vim.o.cursorline      = true  -- Show the line where the cursor is
vim.o.cursorcolumn    = true  -- show the column where the cursor is

vim.o.cc              = "100" -- set a colon border at 100 characters
vim.o.hlsearch        = 1     -- Set Highlight

vim.o.nowrap          = true  -- Faire en sorte que les lignes dépassent de l'écran plutôt qu'elles reviennent au début de la ligne suivante
vim.wo.wrap           = false
vim.wo.linebreak      = true
vim.wo.list           = false -- extra option I set in addition to the ones in your questions

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



-- --------------------------------------------------------------------------------------------
-- KEYBINDINGS / SHORTCUTS CONFIGURATION
-- --------------------------------------------------------------------------------------------
local keymap               = vim.api.nvim_set_keymap
local opts                 = { noremap = true }

keymap('v', '>', '>gv', opts) -- combinaison pour décaler un bloc de texte
keymap('v', '<', '<gv', opts) -- combinaison pour décaler un bloc de texte

-- Pour utiliser cette commande, il est nécessaire d'installer xclip (sudo apt install xclip)
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, desc = "[C]opy to clipboard" }) -- Ajout du CTRL+C pour copier un fichier dans le buffer

vim.keymap.set('n', '<C-a>', 'ggVG', { noremap = true, desc = "Select all buffer" }) -- Ajout du control A pour selectionner l'ensemble du fichier

vim.keymap.set('i', '<C-x>', '<esc>lce', { noremap = true, desc = "Delete new word" }) -- En mode insertion, supprime le mot suivant 
vim.keymap.set('i', '<C-BS>', '<esc>cvb', { noremap = true, desc = "Delete last word" }) -- En mode insertion, supprime le mot precedent 

vim.keymap.set('v', '<Leader>f', '"1y:%s/<C-R>1//gc<Left><Left><Left>', { noremap = true, desc = "Start search and replace for selected word" }) -- Prend le mot sélectionné et vient automatiquement lancer une rechercher/remplacer en le positionnant au bon endroit
vim.keymap.set('v', '//', 'y/\\V<C-R>=escape(@",\'/\')<CR><CR>', { noremap = true, desc = "Search selected word" }) -- Fait une recherche du pattern sélectionné

vim.keymap.set('n', '<Leader>wz', '*#:setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>', { noremap = true, desc = "Fold every lines that don't contain word" }) -- Fait une recherche du mot ou se trouve le curseur puis recherche directement le mot et fait un fold de tout ce qui n'est pas le mot
vim.keymap.set('n', '<Leader>Wz', 'viW*#:setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>', { noremap = true, desc = "Fold every lines that don't contain WORD" }) -- Même chose mais en prenant un mot plus large.

vim.keymap.set('n', '<leader>db', ':bn<cr>:bd #<cr>', { desc = '[D]elete [B]uffer' })

vim.keymap.set('n', ']]', ']]zt', { desc = 'Jump to next function, then set cursor to top' })
vim.keymap.set('n', '[[', '[[zt', { desc = 'Jump to previous function, then set cursor to top' })

vim.keymap.set('n', ']m', ']mzt', { desc = 'Jump to next method, then set cursor to top' })
vim.keymap.set('n', '[m', '[mzt', { desc = 'Jump to previous method, then set cursor to top' })

vim.keymap.set('n', '}', '}zt', { desc = 'Jump to next blank line, then set cursor to top' })
vim.keymap.set('n', '{', '{zt', { desc = 'Jump to previous blank line, then set cursor to top' })
