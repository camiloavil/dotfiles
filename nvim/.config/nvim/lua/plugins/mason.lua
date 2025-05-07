return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "lua-language-server",
                    "clangd",
                    "clang-format",
                    "prettierd",
                    "eslint_d",
                    "hadolint",
                    "black",
                    "mypy",
                    "pyright",
                    "ruff",
                    "stylua",
                    "shellcheck",
                    "json-to-struct",
                    { "bash-language-server", auto_update = true },
                },
                auto_update = false,
                run_on_start = true,
                integrations = {
                    ["mason-lspconfig"] = true,
                    ["mason-null-ls"] = true,
                    ["mason-nvim-dap"] = true,
                },
            })
        end,
    },
}
