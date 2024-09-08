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

local available_lsp_servers = {
    clangd = {},
    pyright = {},
    rust_analyzer = {},
    lua_ls = {},
}

now(function()
    -- Use other plugins with `add()`. It ensures plugin is available in current
    -- session (installs if absent)
    add({
    source = 'neovim/nvim-lspconfig',
    -- Supply dependencies near target plugin
    depends = { 'williamboman/mason.nvim' },
    })
    add({
        source = 'williamboman/mason-lspconfig.nvim',
        depends = { 'williamboman/mason.nvim' },
    })
    add({
        source = 'WhoIsSethDaniel/mason-tool-installer.nvim',
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

later(function() require('mason').setup() end)
later(function() require('mason-lspconfig').setup(
    ) end)

later(function() 
require('mason-tool-installer').setup {
    ensure_installed = available_lsp_servers
} end)

later(function() require('mini.ai').setup() end)        -- Add a/i text objects
-- later(function() require('mini.align').setup() end)  -- Add alignment of data
later(function() require('mini.animate').setup() end)   -- Animate actions in neovim
-- later(function() require('mini.base16').setup() end) -- base16 colorscheme
later(function() require('mini.basics').setup() end)    -- Add configuration for basic setup
-- later(function() require('mini.bracketed').setup() end) -- Add jumps using brackets []
-- later(function() require('mini.bufremove').setup() end) -- Add command to remove and hide buffers
later(function() require('mini.clue').setup() end)      -- Add commands clues in a split
-- later(function() require('mini.colors').setup() end) -- Tweak colorschem
-- later(function() require('mini.comment').setup() end)    -- Add comments (already in neovim)
later(function() require('mini.completion').setup() end)    -- Add autocompletion
later(function() require('mini.cursorword').setup() end)    -- highlight word under cursor
-- later(function() require('mini.deps').setup() end)   -- Package manager
later(function() require('mini.diff').setup() end)      -- Add hint about diff in git
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
vim.o.expandtab       = true -- Utilisation d'espace au lieu des tabulations
vim.o.tabstop         = 4 -- La taille d'une tabulation est de 4 caractères

vim.o.cursorline      = true  -- Show the line where the cursor is
vim.o.cursorcolumn    = true  -- show the column where the cursor is

vim.o.cc              = "100" -- set a colon border at 100 characters
vim.o.hlsearch        = true     -- Set Highlight

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

-- Delete all buffer
vim.api.nvim_create_user_command('Bda', function() vim.cmd('%bd') end, {})

-- later(function() require('lspconfig').setup() end)

-- -------------------------------------------------------------------------------------------------
-- LSP
-- -------------------------------------------------------------------------------------------------
--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)      

        -- We create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        -- This may be unwanted, since they displace some of your code
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
        end
    end,
})

-- Configure the LSP servers here
-- Add any additional override configuration in the following tables. Available keys are:
-- - cmd (table): Override the default command used to start the server
-- - filetypes (table): Override the default list of associated filetypes for the server
-- - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
-- - settings (table): Override the default settings passed when initializing the server.
-- See `:help lspconfig-all` for a list of all the pre-configured LSPs

    -- opts = function()
    --
    --     -- TODO seemes unnecessary with mini.completion 
    --     -- check if it is useless 
    --     --
    --     -- LSP servers and clients are able to communicate to each other what features they support.
    --     -- By default, Neovim doesn't support everything that is in the LSP specification.
    --     -- When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --     -- So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    --     -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    --     -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    --
    --
    --
    -- end,
    --








