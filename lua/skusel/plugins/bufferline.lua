local M = {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  tag = "v4.5.2",
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
      diagnostics = "nvim_lsp",
      diagnostics_indicator = nil,
      color_icons = false,
      show_buffer_icons = false, -- disable filetype icons for buffers
      show_buffer_close_icons = true,
      show_close_icon = true
    }
  }
}

return M
