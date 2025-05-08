return {
  "stevearc/conform.nvim",
  enable = false,
  event = { "BufWritePre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        -- python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = {
        async = false,
        timeout_ms = 750,
        lsp_fallback = true,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mf", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 750,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = require("config.treesitter"),
  -- },
  -- { "echasnovski/mini.nvim", version = false },
}
