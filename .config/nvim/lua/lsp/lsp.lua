local servers = {
    "pyright",
    "rust_analyzer",
    "lua_ls",
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "creativenull/efmls-configs-nvim"
    },
    event = "BufReadPre",
    config = function()
        -- LSP
        local lsp = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
        require("mason-lspconfig").setup({ ensure_installed = servers })

        -- EFM
        local prettier = require('efmls-configs.formatters.prettier_d')
        local black = require('efmls-configs.formatters.black')
        local languages = {
            css = { prettier },
            scss = { prettier },
            sass = { prettier },
            less = { prettier },
            html = { prettier },
            javascript = { prettier },
            typescript = { prettier },
            json = { prettier },
            markdown = { prettier },
            python = { black},
            yaml = { prettier },
        }
        local efmls_config = {
            filetypes = vim.tbl_keys(languages),
            settings = {
                rootMarkers = { '.git/' },
                languages = languages,
            },
            init_options = {
                documentFormatting = true,
                documentRangeFormatting = true,
            },
        }
        lsp.efm.setup(vim.tbl_extend('force', efmls_config, {
            capabilities = capabilities,
        }))

        -- Elixir
        lsp.elixirls.setup({
            capabilities = capabilities,
        })

        -- Lua
        lsp.lua_ls.setup {
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        globals = { 'vim', "local" },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false
                    },
                    telemetry = {
                        enable = false,
                    },
                    format = {
                        enable = true,
                        defaultConfig = {
                            indent_style = "space",
                            indent_size = "2",
                        }
                    },
                },
            },
            capabilities = capabilities,
        }

        -- Python
        lsp["pyright"].setup({
            capabilities = capabilities,
        })

    end
}
