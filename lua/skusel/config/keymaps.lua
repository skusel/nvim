local utils = require("skusel.utils")

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c"

-- Options
--   noremap = non-recursive mapping
--   silent = execute command silently

-- Better window navitation
vim.keymap.set("n", "<C-c>", "<C-w>c", { noremap = true, silent = true, desc = "Close window" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Move left one window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Move down one window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Move up one window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Move right one window" })

-- Resize window with arrows
vim.keymap.set("n", "<S-Up>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Down>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })

-- Select all
vim.keymap.set("n", "<C-a>", "ggVG<CR>", { noremap = true, silent = true, desc = "Select all" })

-- Clear search results
vim.keymap.set("n", "<leader>c", ":noh<CR>", { noremap = true, silent = true })

-- Paste without replacing clipboard
vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true })

-- Diagnostic shortcuts
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { noremap = true, silent = true })

-- Toggles
vim.keymap.set("n", "<leader>tw", function()
  utils.toggle("wrap")
end, { desc = "Toggle line wrap" })

vim.keymap.set("n", "<leader>tn", ":set invnumber<CR>", { noremap = true, silent = true, desc = "Toggle show numbers" })

vim.keymap.set("n", "<leader>tr", function()
  utils.toggle("relativenumber")
end, { desc = "Toggle relaive line numbers" })

vim.keymap.set("n", "<leader>td", utils.toggle_diagnostics, { noremap = true, silent = true, desc = "Toggle Diagnostics" })
