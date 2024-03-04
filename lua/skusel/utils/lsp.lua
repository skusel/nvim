local M = {}

M.on_attach = function(_, _)
  local keymapopts = { noremap = true, silent = true }

	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, keymapopts)
	vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>", keymapopts)
	vim.keymap.set("n", "gi", ":Telescope lsp_implementations<CR>", keymapopts)
	vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>", keymapopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, keymapopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, keymapopts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, keymapopts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, keymapopts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, keymapopts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, keymapopts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, keymapopts)
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
end

return M
