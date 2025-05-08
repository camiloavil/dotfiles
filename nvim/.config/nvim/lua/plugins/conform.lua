return {
    {
        "stevearc/conform.nvim",
        -- event = "BufWritePre", -- uncomment for format on save
        opts = require("config.conform"),
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = require("config.treesitter"),
    },
    { "echasnovski/mini.nvim", version = false },
}
