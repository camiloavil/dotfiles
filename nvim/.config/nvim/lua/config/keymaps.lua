-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "i", "v" }, "<C-x>", "<cmd> w <cr>", { desc = "CMD save buffer" })
vim.api.nvim_set_keymap("n", ";", ":", { desc = "CMD enter command mode" })
vim.api.nvim_set_keymap("i", "jj", "<ESC>", { desc = "CMD exit insert mode" })
vim.api.nvim_set_keymap("n", "QQ", ":qa!<enter>", { desc = "exit nvim" })

vim.api.nvim_set_keymap("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate left in Tmux" })
vim.api.nvim_set_keymap("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate down in Tmux" })
vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate up in Tmux" })
vim.api.nvim_set_keymap("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate right in Tmux" })
