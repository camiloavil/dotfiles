return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = require "configs.treesitter",
  },
  { "echasnovski/mini.nvim", version = false },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
}
