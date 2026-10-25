local M = {}

function M.setup()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local commons = require("commons")
    vim.lsp.config.clangd = {
        -- capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm"
        },
        init_options = {
          fallbackFlags = { "-std=c++20" }, -- Default fallback if no project flag is found
        },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
        root_markers = { '.clangd', 'compile_commands.json', 'compile_flags.txt', '.git' },
    }

    if not vim.lsp.is_enabled("clangd") then
        vim.lsp.enable("clangd")
    end
end

return M
