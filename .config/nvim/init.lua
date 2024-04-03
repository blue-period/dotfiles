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
            -- Load treesitter grammar for org
            require('orgmode').setup_ts_grammar()

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
                    yadm = {
                        enable = false
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
})

-- notes to add, shift over on comments when using v block for some reason it never works
