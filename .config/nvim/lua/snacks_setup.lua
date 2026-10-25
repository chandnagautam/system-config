local M = {}

function M.setup()
    require("snacks").setup({
        input = {enabled = true},
        picker = {
            enabled = true,
            actions = {
                opencode_send = function(...) return require("opencode").snacks_picker_end(...) end
            },
            win = {
                input = {
                    keys = {
                        ["<A-a>"] = {"opencode_send", mode = {"n", "i"}},
                        ["<ESC>"] = {"close", mode = {"n", "i"}}
                    }
                }
            },
        },
        explorer = {
            enabled = true,
        },
        image = {
            enabled = true
        }
    })

    vim.keymap.set({"n"}, "<leader>f", function() Snacks.picker.smart() end, {desc = "Smart Find Files"})
    vim.keymap.set({"n"}, "<leader>;", function() Snacks.picker.buffers() end, {desc = "buffers"})
    vim.keymap.set({"n"}, "<leader>s", function() Snacks.picker.grep() end, {desc = "grep"})
    vim.keymap.set({"n"}, "<leader>n", function() Snacks.picker.explorer() end, {desc = "File explorer"})
    vim.keymap.set({"n"}, "gs", function() Snacks.picker.lsp_symbols() end, {desc = "LSP Symbols"})
    vim.keymap.set({"n"}, "gS", function() Snacks.picker.lsp_workspace_symbols() end, {desc = "LSP Workspace Symbols"})
    vim.keymap.set({"n"},  "gd", function() Snacks.picker.lsp_definitions() end, {desc = "Goto Definition" })
    vim.keymap.set({"n"},  "gD", function() Snacks.picker.lsp_declarations() end, {desc = "Goto Declaration" })
    vim.keymap.set({"n"}, "gr", function() Snacks.picker.lsp_references() end, {nowait = true, desc = "References" })
    vim.keymap.set({"n"}, "gi", function() Snacks.picker.lsp_implementations() end, {desc = "Goto Implementation" })
    vim.keymap.set({"n"}, "gy", function() Snacks.picker.lsp_type_definitions() end, {desc = "Goto T[y]pe Definition" })
    vim.keymap.set({"n"}, "gai", function() Snacks.picker.lsp_incoming_calls() end, {desc = "C[a]lls Incoming" })
    vim.keymap.set({"n"}, "gao", function() Snacks.picker.lsp_outgoing_calls() end, {desc = "C[a]lls Outgoing" })
end

return M
