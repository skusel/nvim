return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason-lspconfig.nvim"
    },
    config = function(_, _)
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = {
          "bashls",
          "clangd",
          "gopls",
          "lua_ls",
          "pyright"
        }
      })

      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({})
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                diagnostics = {
                  globals = { 'vim' }
                }
              }
            }
          })
        end
      })
    end
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
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
      local utils = require("utils")
      local mr = require("mason-registry")
      local packages = {
        "bash-language-server",
        "clangd",
        "gopls",
        "lua-language-server",
        "pyright",
      }
      local function ensure_installed()
        for _, package in ipairs(packages) do
          local p = mr.get_package(package)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  }
}
