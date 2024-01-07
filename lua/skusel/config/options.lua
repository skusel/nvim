-- Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set vim options
vim.opt.number = true -- set line numbers
vim.opt.clipboard = "unnamedplus" -- share clipboard with system
vim.opt.undofile = true -- preserve undo history between restarts
vim.opt.ignorecase = true -- case insensitive compares
vim.opt.smartcase = true -- case sensitive compare if search contains upper case char
vim.opt.smartindent = true -- smart indenting for C-like programs
vim.opt.wrap = false -- do not wrap long lines
vim.opt.incsearch = true -- show where the pattern matches as it is typed (default: true)
vim.opt.hlsearch = true -- highlight all matches to previous search pattern
vim.opt.scrolloff = 5 -- min num of screen lines to keep above and below cursor
vim.opt.sidescrolloff = 5 -- min num of screen columns to keep to left and right of cursor
vim.opt.signcolumn = "yes" -- always show the sign column
vim.opt.wildmenu = true -- show completion popup menu when typing command (default: true)
vim.opt.pumheight = 10 -- number of items to show in the popup menu
vim.opt.termguicolors = true -- enabled 24-bit RGB colors
vim.opt.splitbelow = true -- force all horizontal splits below current window
vim.opt.splitright = true -- force all vertical splits to the right of current window
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.tabstop = 2 -- number of spaces a tab counts for
vim.opt.shiftwidth = 2 -- number of spaces for an indent via ">>", "<<", or smartindent
vim.opt.updatetime = 1000 -- reduce cursor hold time to show disagnostics quicker (defualt: 4000ms)

-- Turn LSP logging off
vim.lsp.set_log_level("off") -- change to "debug" to diagnose LSP issues

-- Improve the look of diagnostics
vim.diagnostic.config({
  virtual_text = false,
  float = {
    focusable = false, -- don't allow window to be focused by mouse or keyboard
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    scope = "line" -- default: "line"
  },
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})

-- Add boarders to all LSP floating windows
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
