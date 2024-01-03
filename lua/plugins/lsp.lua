return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    config = function(_, _)
      local lspconfig = require("lspconfig")

      lspconfig.clangd.setup({})
      lspconfig.pyright.setup({})
    end
  }
}
