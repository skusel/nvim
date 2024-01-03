local M = {}

function M.warn(msg, notify_opts)
  vim.notify(msg, vim.log.levels.WARN, notify_opts)
end

function M.error(msg, notify_opts)
  vim.notify(msg, vim.log.levels.ERROR, notify_opts)
end

function M.info(msg, notify_opts)
  vim.notify(msg, vim.log.levels.INFO, notify_opts)
end

function M.toggle(option)
  vim.opt_local[option] = not vim.opt_local[option]:get()
end

M.diagnostics_active = true
function M.toggle_diagnostics()
    M.diagnostics_active = not M.diagnostics_active
    if M.diagnostics_active then
        vim.diagnostic.show()
        require("utils").info("Enabled Diagnostics", { title = "LSP" })
    else
        vim.diagnostic.hide()
        require("utils").warn("Disabled Diagnostics", { title = "LSP" })
    end
end

return M
