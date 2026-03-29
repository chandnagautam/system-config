local commons = require("commons")

local bufnr = vim.api.nvim_get_current_buf()
local opts = {noremap = true, silent = false}
commons.common_bindings(bufnr, opts)
