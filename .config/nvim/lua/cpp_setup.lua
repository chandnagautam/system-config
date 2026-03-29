local M = {}

function M.setup()
    vim.lsp.config['clangd'] = {
        on_attach = function (client, buffer)
            local opts = {noremap = true, silent = false}
		    local commons = require("commons")

		    commons.common_bindings(buffer, opts)
        end
    }
end

return M
