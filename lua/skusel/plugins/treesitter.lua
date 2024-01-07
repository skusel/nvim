local M = {
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
  end,
}

return M
