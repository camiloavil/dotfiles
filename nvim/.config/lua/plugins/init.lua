return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    -- require("mason").setup {
    --   ui = {
    --     icons = {
    --       package_installed = "✓",
    --       package_pending = "➜",
    --       package_uninstalled = "✗",
    --     },
    --   },
    -- },
    opts = require "configs.mason",
  },
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
