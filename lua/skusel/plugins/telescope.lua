local M = {
	"nvim-telescope/telescope.nvim",
	event = "BufReadPre",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
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
}

return M
