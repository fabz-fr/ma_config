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


