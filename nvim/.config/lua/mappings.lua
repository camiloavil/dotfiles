require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "CMD exit insert mode" })
map({ "n", "i", "v" }, "<C-x>", "<cmd> w <cr>", { desc = "CMD save buffer" })

map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate left in Tmux" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate down in Tmux" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate up in Tmux" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate right in Tmux" })
