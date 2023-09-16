local servers = {
    --"efm", couldnt install efm with mason (wasnt working so I brew installed it: brew install efm-langserver)
    "eslint",
    "pyright",
    "rust_analyzer",
    "lua_ls",
    "ruff_lsp",
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
        local ruff = require('efmls-configs.formatters.ruff')
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
            python = { black, ruff },
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

        -- Javascript
        lsp.eslint.setup({
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
        lsp["ruff_lsp"].setup({
            capabilities = capabilities,
            init_options = {
                settings = {
                    args = { "--select", "A,B,E,F,I,N,PT,PTH,S,SIM,UP", "--per-file-ignores", "test*:S101",
                        "--target-version", "py311" }
                }
            }
        })

    end
}
