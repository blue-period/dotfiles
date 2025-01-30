--append all other parts of the config, the required name is the name of the folder in the lua folder as the working director
--that folder should also have an init.lua file in it, its a way of organizing your config
--this top most init.lua will have require statemnts and lazy plugin declarations only
--find out why I need to have utils before adding all the other modules?
--vim.fn.stdpath how to print where the data folder is

local fn = vim.fn
--Map leader to space
vim.g.mapleader = " "
local execute = vim.api.nvim_command
require("color")  
--
require("settings")
require("keybindings")

local lualine = require("plugins.lualine")
local telescope = require("plugins.telescope")

local lspconfig = require("lsp.lsp")
local mason = require("lsp.mason")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.3",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" },
        opts = telescope,
        keys = {
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file" },
        },
    },
    {'nvim-telescope/telescope-symbols.nvim'},
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
        opts = lualine,
    },
    { "hrsh7th/cmp-nvim-lsp" },
    lspconfig,
    mason,
    {
        "mason-lspconfig.nvim",
        opts = {}
    },
    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
        dependencies = { 'hrsh7th/cmp-nvim-lsp',
        {
            "L3MON4D3/LuaSnip",
            -- follow latest release.
            version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- install jsregexp (optional!).
            build = "make install_jsregexp",
            config = function() require("luasnip.loaders.from_vscode").lazy_load() end
        },
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        'saadparwaiz1/cmp_luasnip',
        "quangnguyen30192/cmp-nvim-ultisnips",
        "SirVer/ultisnips",
        "hrsh7th/cmp-vsnip",
        'hrsh7th/vim-vsnip',

    },

    config = function()
        require("lsp.cmp")
    end
},
{
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
},
{ 'saadparwaiz1/cmp_luasnip' },
{
    "ggandor/leap.nvim",
    dependencies = {"tpope/vim-repeat"},
    config = function() require('leap').add_default_mappings() end

},
{ "lukas-reineke/indent-blankline.nvim" },
{'norcalli/nvim-colorizer.lua'},
{
    'iamcco/markdown-preview.nvim',
    build = 'cd app && yarn install'
},
{
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "windwp/nvim-ts-autotag",
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
    config = function()
        require("plugins.treesitter")
    end
},

{
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = true,
    event = "VeryLazy",
    config = function()
        require('nvim-ts-autotag').setup({
            filetypes = {
                'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
                'xml',
                'php',
                'markdown',
                'astro', 'glimmer', 'handlebars', 'hbs'
            }
        })
    end
},
{
    "onsails/lspkind.nvim",
    config = function()
        require("lsp.kind")
    end
},
{
    'nvim-orgmode/orgmode',
    dependencies = {
        { 'nvim-treesitter/nvim-treesitter', lazy = true },
    },
    event = 'VeryLazy',
    config = function()

        -- Setup treesitter
        require('nvim-treesitter.configs').setup({
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { 'org' },
            },
            ensure_installed = { 'org' },
        })

        -- Setup orgmode
        require('orgmode').setup({
            org_agenda_files = '~/orgfiles/**/*',
            org_default_notes_file = '~/orgfiles/refile.org',
        })
    end,
},
{
    "lewis6991/gitsigns.nvim",
    config =
    function()
        require('gitsigns').setup {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
            numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                follow_files = true
            },
            attach_to_untracked = true,
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
            },
            current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000, -- Disable if file is longer than this (in lines)
            preview_config = {
                -- Options passed to nvim_open_win
                border = 'single',
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1
            },
        }
    end
},
{"tpope/vim-fugitive"},
{
    "rcarriga/nvim-notify",
    config = function()
        require("notify").setup({
            background_colour = "#000000",
        })
    end
},
{ -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',

        -- Useful status updates for LSP
        'j-hui/fidget.nvim',
    }
},
{
    'norcalli/nvim-colorizer.lua',
    config = function()
        require'colorizer'.setup()
    end
},
{
    'ojroques/vim-oscyank',
    config = function()
        vim.keymap.set('n', '<leader>c', '<Plug>OSCYankOperator')
        vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
        vim.keymap.set('v', '<leader>c', '<Plug>OSCYankVisual')
    end,
},
{
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    config = function()
        require("typescript-tools").setup {
            --on_attach = function() ... end,
            handlers = {},
            settings = {
                -- spawn additional tsserver instance to calculate diagnostics on it
                separate_diagnostic_server = true,
                -- "change"|"insert_leave" determine when the client asks the server about diagnostic
                publish_diagnostic_on = "insert_leave",
                -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
                -- "remove_unused_imports"|"organize_imports") -- or string "all"
                -- to include all supported code actions
                -- specify commands exposed as code_actions
                expose_as_code_action = {},
                -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
                -- not exists then standard path resolution strategy is applied
                tsserver_path = nil,
                -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
                -- (see 💅 `styled-components` support section)
                tsserver_plugins = {},
                -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
                -- memory limit in megabytes or "auto"(basically no limit)
                tsserver_max_memory = "auto",
                -- described below
                tsserver_format_options = {},
                tsserver_file_preferences = {},
                -- locale of all tsserver messages, supported locales you can find here:
                -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
                tsserver_locale = "en",
                -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
                complete_function_calls = false,
                include_completions_with_insert_text = true,
                -- CodeLens
                -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
                -- possible values: ("off"|"all"|"implementations_only"|"references_only")
                code_lens = "off",
                -- by default code lenses are displayed on all referencable values and for some of you it can
                -- be too much this option reduce count of them by removing member references from lenses
                disable_member_code_lens = true,
                -- JSXCloseTag
                -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
                -- that maybe have a conflict if enable this feature. )
                jsx_close_tag = {
                    enable = false,
                    filetypes = { "javascriptreact", "typescriptreact" },
                }
            },
        }

    end
},
{
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
        library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            {"nvim-dap-ui"}
        },
    },
},
{
    "mfussenegger/nvim-dap",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
        local dap = require("dap")
        --dap python setup manual
        -- adapter
        dap.adapters.python = function(cb, config)
        if config.request == 'attach' then
            ---@diagnostic disable-next-line: undefined-field
            local port = (config.connect or config).port or '5678'
            ---@diagnostic disable-next-line: undefined-field
            local host = (config.connect or config).host or '127.0.0.1'
            cb(
                {
                    type = 'server',
                    port = assert(port, '`connect.port` is required for a python `attach` configuration'),
                    host = host,
                    options = {
                        source_filetype = 'python',
                    },
                }
            )
        else
            cb(
                {
                    type = 'executable',
                    command = ' /home/ramsddc1/miniconda3/envs/Comfy/bin/python',
                    args = { '-m', 'debugpy.adapter' },
                    options = {
                        source_filetype = 'python',
                    },
                }
            )
        end
        end
        --configuration for python manual
        dap.configurations.python = {
        {
            -- The first three options are required by nvim-dap
            type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = 'attach';
            name = "Launch file";

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            program = "${file}"; -- This configuration will launch the current file if used.
            pythonPath = function()
            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                return cwd .. '/.venv/bin/python'
            else
                return '/usr/bin/python'
            end
            end;
        },
        }


        local dapui = require("dapui")
        dapui.setup()
        require("dapui").setup({})


        require("nvim-dap-virtual-text").setup({
            commented = true, -- Show virtual text alongside comment
        })

        vim.fn.sign_define("DapBreakpoint", {
            text = "",
            texthl = "DiagnosticSignError",
            linehl = "",
            numhl = "",
        })

        vim.fn.sign_define("DapBreakpointRejected", {
            text = "", -- or "❌"
            texthl = "DiagnosticSignError",
            linehl = "",
            numhl = "",
        })

        vim.fn.sign_define("DapStopped", {
            text = "", -- or "→"
            texthl = "DiagnosticSignWarn",
            linehl = "Visual",
            numhl = "DiagnosticSignWarn",
        })

          -- Automatically open/close DAP UI
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end

        local opts = { noremap = true, silent = true }

        -- Toggle breakpoint
        vim.keymap.set("n", "<leader>db", function()
            dap.toggle_breakpoint()
        end, opts)

        -- Continue / Start
        vim.keymap.set("n", "<leader>dc", function()
            dap.continue()
        end, opts)

        -- Step Over
        vim.keymap.set("n", "<leader>do", function()
            dap.step_over()
        end, opts)

        -- Step Into
        vim.keymap.set("n", "<leader>di", function()
            dap.step_into()
        end, opts)

        -- Step Out
        vim.keymap.set("n", "<leader>dO", function()
            dap.step_out()
        end, opts)
                
        -- Keymap to terminate debugging
        vim.keymap.set("n", "<leader>dq", function()
            require("dap").terminate()
        end, opts)

        -- Toggle DAP UI
        vim.keymap.set("n", "<leader>du", function()
            dapui.toggle()
        end, opts)

    end,
},

})

-- notes to add, shift over on comments when using v block for some reason it never works
