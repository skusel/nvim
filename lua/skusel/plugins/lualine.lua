local M = {
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
        "encoding",
        "filetype"
      }
    }
  },
}

return M
