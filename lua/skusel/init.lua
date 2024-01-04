require("skusel.config.options")
require("skusel.config.autocmds")
require("skusel.config.lazy")

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("skusel.config.keymaps")
  end,
})
