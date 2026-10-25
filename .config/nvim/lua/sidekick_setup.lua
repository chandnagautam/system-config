local M = {}

function M.setup()
    require("sidekick").setup({
        nes = {enabled = false},
        cli = {
            mux = {
                enabled = true,
                backend = "tmux",
                create = "split",
                split = {
                    size = 0.3
                }
            },
            tools  ={
                anitgravity = {
                    cmd = {"agy"}
                }
            }
        }
    })
    vim.o.autoread = true
    vim.keymap.set({ "n", "x" }, "<leader>a", function() require("sidekick.cli").send("{this}: ", { submit = true }) end, { desc = "Ask sidekick…" })
    vim.keymap.set({ "n", "x" }, "<leader>x", function() require("sidekick.cli").prompt() end,                          { desc = "Select sidekick…" })
    vim.keymap.set({ "n", "t" }, "<A-t>", function() require("sidekick.cli").toggle() end,                          { desc = "Toggle sidekick" })

    vim.keymap.set({ "n", "x" }, "go",  function() return require("sidekick.cli").operator("{selection} ") end,        { desc = "Add range to sidekick", expr = true })
    vim.keymap.set("n",          "goo", function() return require("sidekick.cli").operator("{file} ") .. "_" end, { desc = "Add file to sidekick", expr = true })
end

return M
