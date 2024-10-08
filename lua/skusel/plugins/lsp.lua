local M = {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason-lspconfig.nvim"
    },
    config = function(_, _)
      local utils_lsp = require("skusel.utils.lsp")
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = {
          "bashls",
          "clangd",
          "eslint",
          "lua_ls",
          "pyright"
        }
      })

      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = utils_lsp.on_attach()
          })
        end,
        ["clangd"] = function()
          lspconfig.clangd.setup({
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy"
            },
            on_attach = utils_lsp.on_attach(),
            -- explicitly set filetypes to exclude "proto"
            filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
          })
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            on_attach = utils_lsp.on_attach(),
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
        "eslint-lsp",
        "lua-language-server",
        "pyright",
        "shellcheck" -- needed for bashls to show diagnostics
      }
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
  }
}

return M
