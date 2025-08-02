-- ----------------------------------------------------------------------------
-- General Configuration
-- ----------------------------------------------------------------------------

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
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' } -- show completions in a pop-up menu even if there is only 1 item and don't automatically select the first item

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

-- ----------------------------------------------------------------------------
-- Auto-commands
-- ----------------------------------------------------------------------------

-- pick up where you last left off in the file
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- check spelling and wrap text for gitcommit and markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- follow pep 8 spacing guidelines for python files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Go file settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- ----------------------------------------------------------------------------
-- Utils
-- ----------------------------------------------------------------------------
local utils = {}

function utils.warn(msg, notify_opts)
  vim.notify(msg, vim.log.levels.WARN, notify_opts)
end

function utils.error(msg, notify_opts)
  vim.notify(msg, vim.log.levels.ERROR, notify_opts)
end

function utils.info(msg, notify_opts)
  vim.notify(msg, vim.log.levels.INFO, notify_opts)
end

function utils.toggle(option)
  vim.opt_local[option] = not vim.opt_local[option]:get()
end

utils.diagnostics_active = true
function utils.toggle_diagnostics()
  utils.diagnostics_active = not utils.diagnostics_active
  if utils.diagnostics_active then
    vim.diagnostic.show()
    require("utils").info("Enabled Diagnostics", { title = "LSP" })
  else
    vim.diagnostic.hide()
    require("utils").warn("Disabled Diagnostics", { title = "LSP" })
  end
end

function utils.go_installed()
  local handle = io.popen("go version 2>&1")
  if handle ~= nil then
    local result = handle:read("*a")
    handle:close()
    return result:find("go version") ~= nil
  else
    return false
  end
end

function utils.jdk_installed()
  local handle = io.popen("javac -version 2>&1")
  if handle ~= nil then
    local result = handle:read("*a")
    handle:close()
    return result:find("javac version") ~= nil
  else
    return false
  end
end

-- ----------------------------------------------------------------------------
-- Plugins
-- ----------------------------------------------------------------------------
local plugins = {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        style = "night",
        on_highlights = function(h1, _)
          h1.LineNr = { fg = "#d9d9d9" }
        end,
      }
    end,
    config = function(_, opts)
      local tokyonight = require("tokyonight")
      tokyonight.setup(opts)
      tokyonight.load()
    end,
  },
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    event = "BufReadPre",
    keys = {
      { "<leader>ff", "<CMD>lua require('telescope.builtin').find_files()<CR>", noremap = true, desc = "Telescope find files"  },
      { "<leader>fg", "<CMD>lua require('telescope.builtin').live_grep()<CR>", noremap = true, desc = "Telescope live grep" },
      { "<leader>fb", "<CMD>lua require('telescope.builtin').buffers()<CR>", noremap = true, desc = "Telescope buffers" },
      { "<leader>fh", "<CMD>lua require('telescope.builtin').help_tags()<CR>", noremap = true, desc = "Telescope help" }
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          mappings = { i = { ["<ESC>"] = actions.close } },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    tag = "v4.9.1",
    opts = {
      options = {
        mode = "buffers",
        close_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        mid_mouse_command = "bdelete! %d",
        right_mouse_command = nil,
        buffer_close_icon = 'X',
        close_icon = 'X',
        left_trunc_marker = '...',
        right_trunc_marker = '...',
        disgnostics = "nvim_lsp",
        diagnostices_indicator = nil,
        color_icons = false,
        show_buffer_icons = false, --disable filetype icons for buffers
        show_buffer_close_icons = true,
        show_close_icon = true
      }
    }
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = false,
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_b = {
          "branch",
          {
            "diagnostics",
            sections = { "error", "warn" },
            update_in_insert = true,
            always_visible = true,
          }
        },
        lualine_x = {
          "filesize",
          "encoding",
          "filetype"
        }
      }
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    opts = {
      highlight = {
        enable = true,
        disable = function(lang, buf)
          local max_filesize = 500 * 1024 -- 500 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "cmake",
        "css",
        "csv",
        "cuda",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "html",
        "java",
        "javascript",
        "json",
        "json5",
        "llvm",
        "lua",
        "make",
        "ninja",
        "objdump",
        "proto",
        "python",
        "sql",
        "strace",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml"
      },
      sync_install = true,
      ignore_install = {}, -- List of parsers to ignore installation
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.opt.foldmethod = "expr" -- uses a custom expression (specified in foldexpr) to define folds
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- use Treesitter's syntax-aware folding
      vim.opt.foldenable = false -- start with folds open
      vim.opt.foldlevel = 99 -- prevents folds from being closed by default
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    priority = 999,
    build = ":MasonUpdate",
    opts = {
      PATH = "append", -- preference already installed packages
      pip = {
        upgrade_pip = true,
      },
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local packages = {
        "bash-language-server",
        "clangd",
        "lua-language-server",
        "pyright",
        "ruff",
        "shellcheck", -- needed for bashls to show diagnostics
      }
      if utils.go_installed() then
        table.insert(packages, "gopls")
      end
      if utils.jdk_installed() then
        table.insert(packages, "jdtls")
      end
      local function ensure_installed()
        for _, package in ipairs(packages) do
          local p = mr.get_package(package)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      mr.refresh(ensure_installed)
    end,
  },
  {
    "nvim-java/nvim-java",
    lazy = false,
    priority = 998,
    enabled = utils.jdk_installed()
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    prority = 997
  }
}

-- ----------------------------------------------------------------------------
-- Lazy Plugin Manager
-- ----------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(plugins, {
  defaults = { lazy = true },
  install = { colorscheme = { "tokyonight" } },
  ui = {
    border = "rounded",
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})

-- ----------------------------------------------------------------------------
-- LSPs
-- ----------------------------------------------------------------------------
local function on_lsp_attach(client, bufnr)
  local keymapopts = { buffer = bufnr, noremap = true, silent = true }
  if client.supports_method("textDocument/completion") then
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end
  if client.supports_method("textDocument/declaration") then
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, keymapopts)
  end
  if client.supports_method("textDocument/definition") then
    vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>", keymapopts)
  end
  if client.supports_method("textDocument/implementation") then
    vim.keymap.set("n", "gi", ":Telescope lsp_implementations<CR>", keymapopts)
  end
  if client.supports_method("textDocument/references") then
    vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>", keymapopts)
  end
  if client.supports_method("textDocument/hover") then
    vim.keymap.set("n", "K", vim.lsp.buf.hover, keymapopts)
  end
  if client.supports_method("textDocument/signatureHelp") then
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, keymapopts)
  end
  if client.supports_method("textDocument/rename") then
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, keymapopts)
  end
  if client.supports_method("textDocument/codeAction") then
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, keymapopts)
  end
  -- show diagnostics in hover window when cursor is stationary
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      local opts = {
        focusable = false,
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        scope = "cursor",
        close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
      }
      vim.diagnostic.open_float(nil, opts)
    end,
  })
  -- diagnostic shortcuts
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, keymapopts)
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, keymapopts)
  -- workspace folder keymappings
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, keymapopts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, keymapopts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, keymapopts)
end

-- Turn LSP logging off
vim.lsp.set_log_level("off") -- change to "debug" to diagnose LSP issues

vim.lsp.config("bashls", {
  on_attach = on_lsp_attach
})
vim.lsp.enable("bashls")

vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  on_attach = on_lsp_attach
})
vim.lsp.enable("clangd")

if utils.go_installed() then
  vim.lsp.config("gopls", {
    on_attach = on_lsp_attach
  })
  vim.lsp.enable("gopls")
end

if utils.jdk_installed() then
  vim.lsp.enable("jdtls")
end

vim.lsp.config("lua_ls", {
  on_attach = on_lsp_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      }
    }
  },
})
vim.lsp.enable("lua_ls")

vim.lsp.config("pyright", {
  on_attach = on_lsp_attach
})
vim.lsp.enable("pyright")

vim.lsp.config("ruff", {
  on_attach = on_lsp_attach
})
vim.lsp.enable("ruff")

-- ----------------------------------------------------------------------------
-- Keymaps
-- ----------------------------------------------------------------------------

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
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })

-- Select all
vim.keymap.set("n", "<C-a>", "ggVG<CR>", { noremap = true, silent = true, desc = "Select all" })

-- Clear search results
vim.keymap.set("n", "<leader>c", ":noh<CR>", { noremap = true, silent = true })

-- Paste without replacing clipboard
vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true })

-- Toggles
vim.keymap.set("n", "<leader>tw", function()
  utils.toggle("wrap")
end, { desc = "Toggle line wrap" })

vim.keymap.set("n", "<leader>tn", ":set invnumber<CR>", { noremap = true, silent = true, desc = "Toggle show numbers" })

vim.keymap.set("n", "<leader>tr", function()
  utils.toggle("relativenumber")
end, { desc = "Toggle relaive line numbers" })

vim.keymap.set("n", "<leader>td", utils.toggle_diagnostics, { noremap = true, silent = true, desc = "Toggle Diagnostics" })
