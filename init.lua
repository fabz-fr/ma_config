----------------------------------------------------------------------------------------------------
-- Set flag for config.nvim
----------------------------------------------------------------------------------------------------
vim.g.init_lua_loaded = true
vim.cmd('source ~/.config/nvim/lua/config.vim')

----------------------------------------------------------------------------------------------------
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
----------------------------------------------------------------------------------------------------
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

----------------------------------------------------------------------------------------------------
-- Set up 'mini.deps' (customize to your liking)
-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
----------------------------------------------------------------------------------------------------
require('mini.deps').setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

----------------------------------------------------------------------------------------------------
-- Define LSP servers
----------------------------------------------------------------------------------------------------
local available_lsp_servers = {
    clangd = { cmd = { "clangd", "--background-index", "--header-insertion=never", --[["--clang-tidy",]] }, },
    pyright = {}, -- To use pyright, node must be installed from nvm. Install nvm (go to github page) then install node, then symlink node to /usr/bin/node
    rust_analyzer = {},
    lua_ls = {},
    cmake = {},
    bashls = {},
}

----------------------------------------------------------------------------------------------------
-- Download Plugins
----------------------------------------------------------------------------------------------------
---@format disable
now(function()   add({ source = 'neovim/nvim-lspconfig',                     depends = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' }, 'WhoIsSethDaniel/mason-tool-installer.nvim', }) end)
now(function()   add({ source = 'williamboman/mason.nvim',                   depends = { 'mason-org/mason-registry' } })
                 add({ source = 'williamboman/mason-lspconfig.nvim',         depends = { 'williamboman/mason.nvim' }, })
                 add({ source = 'WhoIsSethDaniel/mason-tool-installer.nvim', depends = { 'williamboman/mason.nvim' }, }) end)
now(function()   add({ source = 'Mofiqul/vscode.nvim' }) end)
later(function() add({ source = 'ibhagwan/fzf-lua', }) end)
later(function() add({ source = 'kevinhwang91/nvim-ufo',                     depends = { 'kevinhwang91/promise-async' }, }) end) -- Better fold handling
later(function() add({ source = 'skywind3000/asyncrun.vim' }) end)
later(function() add({ source = 'tversteeg/registers.nvim' }) end)
later(function() add({ source = 'okuuva/auto-save.nvim' }) end)
later(function() add({ source = 'Saghen/blink.cmp',                          depends = { "rafamadriz/friendly-snippets" }, checkout = "v1.0.0", }) end)
later(function() add({ source = "mikavilpas/yazi.nvim",                      depends = { "folke/snacks.nvim", "nvim-lua/plenary.nvim" }, }) end)
later(function() add({ source = "mfussenegger/nvim-dap",
                    depends = { 'rcarriga/nvim-dap-ui',           --[[Creates a beautiful debugger UI]]
                                'nvim-neotest/nvim-nio',          --[[Required dependency for nvim-dap-ui]]
                                'williamboman/mason.nvim',        --[[Installs the debug adapters for you]]
                                'jay-babu/mason-nvim-dap.nvim',   --[[Installs the debug adapters for you]]
                                'theHamsta/nvim-dap-virtual-text',--[[Install plugins that allows variables values inside editor]] } }) end)
now(function()   add({ source = 'nvim-treesitter/nvim-treesitter', --[[Use 'master' while monitoring updates in 'main']] checkout = 'master', monitor = 'main', --[[Perform action after every checkout]] hooks = { post_checkout = function() vim.cmd('TSUpdate') end }, }) end)
---@format enable

----------------------------------------------------------------------------------------------------
-- Install TreeSitter
----------------------------------------------------------------------------------------------------
later(function() require('nvim-treesitter.configs').setup({ -- Possible to immediately execute code which depends on the added plugin
        ensure_installed = { 'lua', 'vimdoc', 'rust', 'c', 'cpp', 'cmake', 'python', 'vim', 'bash' },
        highlight = { enable = true },
    })
end)

----------------------------------------------------------------------------------------------------
-- Install Mason & LSP servers
----------------------------------------------------------------------------------------------------
now(function()
    require('mason').setup()
    require('mason-lspconfig').setup()
    -- require('mason-lspconfig').setup()
    local servers_to_install = vim.tbl_keys(available_lsp_servers or {})

    require('mason-tool-installer').setup({
        ensure_installed = servers_to_install,
    })
end)

now(function()
    -- Importer lspconfig
    local lspconfig = require('lspconfig')
    -- Boucle sur chaque serveur dans le tableau et l'initialise
    for server, config in pairs(available_lsp_servers) do
        lspconfig[server].setup(config)
    end
end)

----------------------------------------------------------------------------------------------------
-- Install colorscheme
----------------------------------------------------------------------------------------------------
now(function()
    vim.cmd.colorscheme "vscode"
    require('vscode').setup({})
    vim.api.nvim_set_hl(0, 'DiagnosticDeprecated', { strikethrough = false })

    -- set cursorline to make cursorline clearer
    vim.cmd("highlight CursorLine guibg=#404040")
    vim.cmd("highlight CursorColumn guibg=#404040")
end)

----------------------------------------------------------------------------------------------------
-- Install fzf-lua
----------------------------------------------------------------------------------------------------
later(function()
    require('fzf-lua').setup({
        winopts = { height = 1, width = 1, },
        keymap  = { fzf = { ["ctrl-q"] = "select-all+accept", }, },
    })
end)

later(function() require("registers").setup() end)
later(function() require('mini.ai').setup() end) -- Add a/i text objects
later(function() require('mini.clue').setup({
        triggers = {
            -- Leader triggers
            { mode = 'n', keys = '<Leader>' },
            { mode = 'n', keys = 's' },
            { mode = 'n', keys = '<Leader>s' },
            { mode = 'n', keys = '<Leader>g' },
            { mode = 'n', keys = 'g' },
            { mode = 'n', keys = ']' },
            { mode = 'n', keys = '[' },
            { mode = 'n', keys = 'z' },
        }
    }
    )
end)
later(function() require('mini.cursorword').setup() end) -- highlight word under cursor
later(function() require('mini.diff').setup() end)       -- Add hint about diff in git
later(function() require('mini.git').setup() end)         -- Gestion de Git
later(function() require('mini.indentscope').setup() end) -- Affiche une ligne pour voir la fin du scope
local jump2d = require('mini.jump2d')
local jump_line_start = jump2d.builtin_opts.word_start
later(function() require('mini.jump2d').setup({ spotter = jump_line_start.spotter, labels = 'abcdefghijklmnopqrstuvwxyz', allowed_windows = { current = true, not_current = false, }, }) end)                                                     -- Permet les quickjump
later(function() require('mini.move').setup() end)       -- Ajout un mécanisme de mouvement avec ALT+hjkl pour bouger des blocs en visual mode
later(function() require('mini.notify').setup() end)     -- Permet l'ajout de notification en haut à droite de l'écran
later(function() require('mini.pairs').setup() end)      -- Feature pour la gestion des paires ({"etc."})
later(function() require('mini.statusline').setup() end) -- statusline
later(function() require('mini.surround').setup() end)   -- Fonctionalité pour ajouter et gérer les caractères de wrapping '([{}])'
later(function() require('mini.tabline').setup() end)    -- gère les buffers dans des onglets "tabs"
later(function() require('auto-save').setup({ event = { "insertLeave", }, --[[Several other value can set here: TextChanged]] }) end)

later(function()
    require('blink.cmp').setup({
        completion = {
            menu = { auto_show = true },
            documentation = { auto_show = true },
        },

        signature = { enabled = true },
    })
end) -- instead of mini.completion

----------------------------------------------------------------------------------------------------
-- Install dap plugins
----------------------------------------------------------------------------------------------------
later(function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
            -- 'delve',
        },
    }

    require("nvim-dap-virtual-text").setup()

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
            icons = {
                pause = '⏸',
                play = '▶',
                step_into = '⏎',
                step_over = '⏭',
                step_out = '⏮',
                step_back = 'b',
                run_last = '▶▶',
                terminate = '⏹',
                disconnect = '⏏',
            },
        },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug start/continue' })
    vim.keymap.set('n', '<F6>', dap.step_into, { desc = 'Debug Step into' })
    vim.keymap.set('n', '<F7>', dap.step_over, { desc = 'Debug step over' })
    vim.keymap.set('n', '<F8>', dap.step_out, { desc = 'Debug step out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug toggle breakpoint' })
    vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
        { desc = 'Debug toggle breakpoint' })
    -- vim.keymap.set('n', '<leader>?', function() dapui.eval(nil, {enter = true}) end, { desc = 'show variable' })

    dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode-14', -- adjust as needed, must be absolute path
        name = 'lldb'
    }

    dap.configurations.cpp =
    {
        {
            name = 'Launch',
            type = 'lldb',
            request = 'launch',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},

            -- 💀
            -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
            --
            --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
            --
            -- Otherwise you might get the following error:
            --
            --    Error on launch: Failed to attach to the target process
            --
            -- But you should be aware of the implications:
            -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
            -- runInTerminal = false,
        },
    }

    dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb-vscode-14",
        name = "lldb",
    }
    dap.configurations.rust =
    {
        {
            name = "d6",
            type = "lldb",
            request = "launch",
            program = function()
                return vim.fn.getcwd() .. "/target/debug/rust"
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        }
    }
end)

later(function()
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
end)

vim.keymap.set('n', 'gt', '<cmd>lua MiniDiff.toggle_overlay()<CR>', { desc = 'Toggle diff overlay' })
vim.keymap.set('n', '<A-o>', '<cmd>ClangdSwitchSourceHeader<CR>', { desc = 'Switch Source Header' })

vim.keymap.set('n', 'yc', function() vim.api.nvim_feedkeys('yygccp', 'm', false) end)

-- -------------------------------------------------------------------------------------------------
-- AUTO COMMANDS
-- Highlight when yanking (copying) text
-- -------------------------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- -------------------------------------------------------------------------------------------------
-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
later(function() vim.opt.clipboard = 'unnamedplus' end)

-- LSP
-- -------------------------------------------------------------------------------------------------
later(function()
    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    vim.keymap.set('n', 'gd', require('fzf-lua').lsp_definitions, { desc = '[G]oto [D]efinition' })

    -- Find references for the word under your cursor.
    vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { desc = '[G]oto [R]eferences' })

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    vim.keymap.set('n', 'gI', require('fzf-lua').lsp_implementations, { desc = '[G]oto [I]mplementation' })

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    vim.keymap.set('n', '<leader>D', require('fzf-lua').lsp_typedefs, { desc = 'Type [D]efinition' })

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    vim.keymap.set('n', '<leader>ds', require('fzf-lua').lsp_document_symbols, { desc = '[D]ocument [S]ymbols' })

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction (diagnostics)' })

    -- Search every elements from lsp
    vim.keymap.set('n', '<leader>gg', require('fzf-lua').lsp_finder, { desc = '[G]et [G]odshit' })

    -- Search into dap
    vim.keymap.set('n', '<F4>', require('fzf-lua').dap_commands, { desc = 'Get DAP commands' })
    --
    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })
end)
-- vim.keymap.set('vn', '<leader>j', require('mini.jump2d').start, {desc ='[J]ump'})
-- vim.keymap.set( {'n', 'v'}, '<leader>j', '<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.default)<CR>')


vim.keymap.set({ 'n' }, '<leader>mc', ':AsyncStop<CR> :AsyncRun make clean<CR> ', { desc = '[M]ake [C]lean' })
vim.keymap.set({ 'n' }, '<leader>M', ':AsyncStop<CR> :AsyncRun make<CR> ', { desc = '[M]ake' })
vim.keymap.set({ 'n' }, '<leader>mb', ':AsyncStop<CR> :AsyncRun make build<CR> ', { desc = '[M]ake [B]uild' })
vim.keymap.set({ 'n' }, '<leader>mr', ':AsyncStop<CR> :AsyncRun make run<CR> ', { desc = '[M]ake [R]un' })
vim.keymap.set({ 'n' }, '<leader>ms', ':AsyncStop<CR>', { desc = '[M]ake [S]stop' })

vim.keymap.set({ 'n', 'x' }, 'f', '<cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<CR>',
    { desc = '[F]ind' })
vim.keymap.set({ 'n', 'x' }, 'F', '<cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<CR>',
    { desc = '[F]ind' })
vim.keymap.set({ 'n', 'x' }, 't', '<cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<CR>',
    { desc = '[F]ind' })
vim.keymap.set({ 'n', 'x' }, 'T', '<cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<CR>',
    { desc = '[F]ind' })

later(function()
    -- Option 3: treesitter as a main provider instead
    -- (Note: the `nvim-treesitter` plugin is *not* needed.)
    -- ufo uses the same query files for folding (queries/<lang>/folds.scm)
    -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
    require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
            return { 'treesitter', 'indent' }
        end
    })

    -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
end)

vim.keymap.set({ 'n' }, '<leader>fc', '/<<<<CR>', { desc = '[F]ind [C]onflicts' })
vim.keymap.set({ 'n' }, '<leader>gcu', 'dd/|||<CR>0v/>>><CR>$x', { desc = '[G]it [C]onflict Choose [U]pstream' })
vim.keymap.set({ 'n' }, '<leader>gcb', '0v/|||<CR>$x/====<CR>0v/>>><CR>$x', { desc = '[G]it [C]onflict Choose [B]ase' })
vim.keymap.set({ 'n' }, '<leader>gcs', '0v/====<CR>$x/>>><CR>dd', { desc = '[G]it [C]onflict Choose [S]tashed' })

vim.keymap.set({ 'n' }, '<leader>ti', function() if next(vim.lsp.get_active_clients()) == nil then print("No client for Inlay hints") else vim.lsp .inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end end, { desc = '[T]oggle [I]nlay hints' })
vim.keymap.set({ 'n' }, '<leader>=', function() if next(vim.lsp.get_active_clients()) == nil then print("No client for formatting code") else vim.lsp.buf .format() end end, { desc = 'Format code' })

vim.diagnostic.config({
    -- virtual_text = { prefix = "", format = diagnostic_format, },
    signs = {
        text = {
    [vim.diagnostic.severity.ERROR] = "",
    [vim.diagnostic.severity.WARN] = "",
    [vim.diagnostic.severity.INFO] = "",
    [vim.diagnostic.severity.HINT] = "󰌵",
}
,
    },
    virtual_lines = {
        current_line = true,
    },
    underline = true,
    severity_sort = true,
})

function toggle_diagnostics()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

toggle_diagnostics()

vim.keymap.set("n", "<leader>td", "<cmd>lua toggle_diagnostics()<cr>", { desc = "Toggle diagnostics" })

-- autocommand to wrap line in quickfix list
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true -- Évite les coupures de mots en plein milieu
    end,
})

vim.keymap.set({ 'n' }, '<leader>e', '<cmd>Yazi<cr>', { desc = '[E]xplore' })

vim.o.winborder = 'rounded'
