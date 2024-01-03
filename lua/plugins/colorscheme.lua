local M = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = function()
    return {
      style = "night",
      on_highlights = function(h1, c)
        h1.LineNr = { fg = "#d9d9d9" }
      end,
    }
  end,
  config = function(_, opts)
    local tokyonight = require("tokyonight")
    tokyonight.setup(opts)
    tokyonight.load()
  end,
}

return M
