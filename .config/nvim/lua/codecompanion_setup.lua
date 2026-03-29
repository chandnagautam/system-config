local M = {}

function M.setup() 
    -- Improve diff highlight colors for CodeCompanion float (Gruvbox styled)
    vim.api.nvim_set_hl(0, "CodeCompanionDiffAdd", { bg = "#32361a" })    -- Subtle green background
    vim.api.nvim_set_hl(0, "CodeCompanionDiffDelete", { bg = "#3c1f1e" }) -- Subtle red background
    vim.api.nvim_set_hl(0, "CodeCompanionDiffText", { bg = "#4a4a4a" })   -- Subtle grey for changed text

    require("codecompanion").setup({
        display = {
            diff = {
                provider = "inline",
                provider_opts = {
                    inline = {
                        layout = "float",
                    }
                }
            },
        },
        interactions = {
            chat = {
                adapter = "gemini_cli",
            }
        },
        adapters = {
            acp = {
                gemini_cli = function ()
                    return require("codecompanion.adapters").extend("gemini_cli", {
                        defaults = {
                            auth_method = "oauth-personal",
                        },
                        env = {
                            GEMINI_API_KEY = "cmd:secret-tool lookup gemini key"
                        }
                    })
                end
            }
        }
    })
end

return M
