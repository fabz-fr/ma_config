require('configuration')

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

now(function() add({ source = 'ibhagwan/fzf-lua', }) end)
later(function() add({ source = 'kevinhwang91/nvim-bqf', }) end) -- Better quickfix handling
later(function() add({ source = 'kevinhwang91/nvim-ufo', }) end) -- Better fold handling

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

now(function()
    require('mason').setup()
    require('mason-lspconfig').setup()
    require('mason-tool-installer').setup { ensure_installed = available_lsp_servers }

    -- Importer lspconfig
    local lspconfig = require('lspconfig')
    -- Boucle sur chaque serveur dans le tableau et l'initialise
    for server, config in pairs(available_lsp_servers) do
        lspconfig[server].setup(config)
    end
end)

later(function() require('fzf-lua').setup() end)

-- later(function() require('mini.align').setup() end)  -- Add alignment of data
-- later(function() require('mini.base16').setup() end) -- base16 colorscheme
-- later(function() require('mini.basics').setup() end)    -- Add action for basic programming: moving splits, 
-- later(function() require('mini.bracketed').setup() end) -- Add several jumps based on brackets []
-- later(function() require('mini.bufremove').setup() end) -- Add command to remove and hide buffers
-- later(function() require('mini.colors').setup() end) -- Tweak colorscheme
-- later(function() require('mini.comment').setup() end)    -- Add comments (already in neovim)
-- later(function() require('mini.deps').setup() end)   -- Package manager (is already installed) 
-- later(function() require('mini.doc').setup() end)    -- Gestion de la doc pour neovim
-- later(function() require('mini.fuzzy').setup() end)    -- Fuzzy sorter
-- later(function() require('mini.hipatterns').setup() end)  -- Gère l'arrière plan de certains patterns et couleurs
-- later(function() require('mini.hues').setup() end) -- Change le fond d'écran
-- later(function() require('mini.map').setup() end)       -- Ajoute une barre latérale à droite représentant globalement l'état du fichier
-- later(function() require('mini.misc').setup() end)       -- Ajoute des fonctions lua
-- later(function() require('mini.jump').setup() end)       -- améliore t T f F en permettant des jumps sur plusieurs ligne ainsi que plusieurs sauts.
-- later(function() require('mini.operators').setup() end)  -- Fait un truc bizarre dans les copier
-- later(function() require('mini.pick').setup() end)       -- équivalent de fzf et telescope
-- later(function() require('mini.sessions').setup() end)   -- gestionnaire de sessions nvim. Intéressant si on veut avoir des workspaces
-- later(function() require('mini.splitjoin').setup() end)     -- Change la mise en forme de tableau et liste
-- later(function() require('mini.starter').setup() end)    -- Change l'écran de démarrage
-- later(function() require('mini.test').setup() end)       -- Lance des tests
-- later(function() require('mini.trailspace').setup() end) -- Highlight les trailings spaces
-- later(function() require('mini.visits').setup() end) -- Garde une liste des fichiers visités
later(function() require('mini.ai').setup() end)        -- Add a/i text objects
later(function() require('mini.animate').setup() end)   -- Animate actions in neovim to observe cursor jumps
later(function() require('mini.clue').setup() end)      -- Add commands clues in a split
later(function() require('mini.completion').setup() end)    -- Add autocompletion
later(function() require('mini.cursorword').setup() end)    -- highlight word under cursor
later(function() require('mini.diff').setup() end)      -- Add hint about diff in git
later(function() require('mini.extra').setup() end)    -- Add extra picker for mini.pick add extends text object from mini.ai add highlighter
later(function() require('mini.files').setup() end)    -- File manager
later(function() require('mini.git').setup() end)      -- Gestion de Git 
-- later(function() require('mini.icons').setup() end)      -- Ajoute des icônes dans les menus nvim
later(function() require('mini.indentscope').setup() end) -- Affiche une ligne pour voir la fin du scope 
later(function() require('mini.jump2d').setup() end)     -- Permet les quickjump
later(function() require('mini.move').setup() end)          -- Ajout un mécanisme de mouvement avec ALT+hjkl pour bouger des blocs en visual mode
later(function() require('mini.notify').setup() end)        -- Permet l'ajout de notification en haut à droite de l'écran
later(function() require('mini.pairs').setup() end)         -- Feature pour la gestion des paires ({"etc."})
later(function() require('mini.statusline').setup() end)    -- statusline
later(function() require('mini.surround').setup() end)      -- Fonctionalité pour ajouter et gérer les caractères de wrapping '([{}])'
later(function() require('mini.tabline').setup() end)       -- gère les buffers dans des onglets "tabs"

-- See `:help telescope.builtin`
local builtin = require('fzf-lua')
vim.keymap.set('n', '<leader>sf', builtin.files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sw', builtin.grep_cword, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sW', builtin.grep_cWORD, { desc = '[S]earch current [W]ORD' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = '[G]it [F]iles search' })
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus search' })

-- -------------------------------------------------------------------------------------------------
-- AUTO COMMANDS
-- -------------------------------------------------------------------------------------------------
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
--
-- -------------------------------------------------------------------------------------------------
-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
later(function() vim.opt.clipboard = 'unnamedplus' end)

-- LSP
-- -------------------------------------------------------------------------------------------------
-- Jump to the definition of the word under your cursor.
--  This is where a variable was first declared, or where a function is defined, etc.
--  To jump back, press <C-t>.
vim.keymap.set('n','gd', require('fzf-lua').lsp_definitions, { desc = '[G]oto [D]efinition'})

-- Find references for the word under your cursor.
vim.keymap.set('n','gr', require('fzf-lua').lsp_references, { desc = '[G]oto [R]eferences'})

-- Jump to the implementation of the word under your cursor.
--  Useful when your language has ways of declaring types without an actual implementation.
vim.keymap.set('n','gI', require('fzf-lua').lsp_implementations, { desc = '[G]oto [I]mplementation'})

-- Jump to the type of the word under your cursor.
--  Useful when you're not sure what type a variable is and you want to see
--  the definition of its *type*, not where it was *defined*.
vim.keymap.set('n','<leader>D', require('fzf-lua').lsp_typedefs, { desc = 'Type [D]efinition'})

-- Fuzzy find all the symbols in your current document.
--  Symbols are things like variables, functions, types, etc.
vim.keymap.set('n','<leader>ds', require('fzf-lua').lsp_document_symbols, { desc = '[D]ocument [S]ymbols'})

-- Rename the variable under your cursor.
--  Most Language Servers support renaming across files, etc.
vim.keymap.set('n','<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame'})

-- Execute a code action, usually your cursor needs to be on top of an error
-- or a suggestion from your LSP for this to activate.
vim.keymap.set('n','<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction'})

-- Search every elements from lsp
vim.keymap.set('n','<leader>gg', require('fzf-lua').lsp_finder, { desc = '[G]et [G]odshit'})
--
-- WARN: This is not Goto Definition, this is Goto Declaration.
--  For example, in C this would take you to the header.
vim.keymap.set('n','gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration'})

-- vim.keymap.set('vn', '<leader>j', require('mini.jump2d').start, {desc ='[J]ump'})
vim.keymap.set( {'n', 'v'}, '<leader>j', '<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.default)<CR>')


