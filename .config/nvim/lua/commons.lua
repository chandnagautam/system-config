local M = {}

function M.buf_set_keymap(bufnr, lhs, rhs, opts)
    vim.keymap.set('n', lhs, rhs, vim.tbl_extend('force', { buffer = bufnr }, opts or {}))
end

function M.common_bindings(bufnr, opts)
    opts = opts or { noremap = true, silent = true }

    -- Diagnostics
    M.buf_set_keymap(bufnr, '[g', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
    M.buf_set_keymap(bufnr, ']g', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
    M.buf_set_keymap(bufnr, '<leader>e', function() vim.diagnostic.open_float({ scope = 'line' }) end, opts)

    -- LSP actions
    M.buf_set_keymap(bufnr, 'gD', vim.lsp.buf.declaration, opts)
    M.buf_set_keymap(bufnr, 'K', vim.lsp.buf.hover, opts)
    M.buf_set_keymap(bufnr, 'rn', vim.lsp.buf.rename, opts)
    M.buf_set_keymap(bufnr, 'ga', vim.lsp.buf.code_action, opts)

    -- DAP (Debug Adapter Protocol)
    local has_dap, dap = pcall(require, "dap")
    if has_dap then
        M.buf_set_keymap(bufnr, '<leader>b', dap.toggle_breakpoint, opts)
        M.buf_set_keymap(bufnr, '<leader>B', function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, opts)
        M.buf_set_keymap(bufnr, '<leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, opts)
        M.buf_set_keymap(bufnr, '<F5>', dap.continue, opts)
        M.buf_set_keymap(bufnr, '<F6>', dap.step_over, opts)
        M.buf_set_keymap(bufnr, '<F7>', dap.step_into, opts)
        M.buf_set_keymap(bufnr, '<F8>', dap.step_out, opts)
    end

    -- Terminal navigation
    local t_opts = { silent = true }
    vim.keymap.set('t', '<C-w>h', '<C-\\><C-n><C-w>h', t_opts)
    vim.keymap.set('t', '<C-w>j', '<C-\\><C-n><C-w>j', t_opts)
    vim.keymap.set('t', '<C-w>k', '<C-\\><C-n><C-w>k', t_opts)
    vim.keymap.set('t', '<C-w>l', '<C-\\><C-n><C-w>l', t_opts)
end

function M.get_lsp_client()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    return clients[1] or nil
end

function M.get_current_root()
    local client = M.get_lsp_client()
    if not client or not client.config.root_dir then
        return vim.fn.expand("%:p:h")
    end
    return client.config.root_dir
end

return M
